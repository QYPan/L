#include "managemsg.h"

ManageMsg::ManageMsg()
	: seg_char('#')
{
}

void ManageMsg::deal(int fd){
	DataStruct data;
	readData(fd, data);
	handle(fd, data);
}

void ManageMsg::readData(int fd, DataStruct &data){
	char buffer[2000] = {0};
	string tmp_mark;
	string str_buffer;
	int mark;

	read(fd, buffer, sizeof(buffer));
	str_buffer = string(buffer);
	splitData(str_buffer, 0, data.name);
	splitData(str_buffer, 1, tmp_mark);
	splitData(str_buffer, 2, data.message);
	sscanf(tmp_mark.data(), "%d", &mark);

	data.mark = static_cast<MessageType>(mark);
}

void ManageMsg::writeData(int fd, const DataStruct &data){
	char buffer[2000] = {0};
	char tmp_mark[5];
	int mark = (int)data.mark;
	//itoa(mark, tmp_mark, 10);
	sprintf(tmp_mark, "%d", mark);
	strcat(buffer, data.name.c_str());
	buffer[strlen(buffer)] = seg_char;
	strcat(buffer, tmp_mark);
	buffer[strlen(buffer)] = seg_char;
	strcat(buffer, data.message.c_str());
	write(fd, buffer, sizeof(buffer));
}


// 获取字符串 data 以 seg_char 为分隔符的第 k 段，k 为 0，1，2
void ManageMsg::splitData(const string &str, int k, string &sub){
	int count = 0;
	int beg = 0;
	int n = str.length();
	for(int i = 0; i < n; i++){
		if(str[i] == seg_char || i == n-1){
			if(count == k){
				if(i != n-1)
					sub = str.substr(beg, i-beg);
				else
					sub = str.substr(beg);
				return;
			}else{
				beg = i + 1;
				count++;
				if(count == 2)
					break;
			}
		}
	}
	if(beg != n)
		sub = str.substr(beg);
}

void ManageMsg::handle(int fd, const DataStruct &data){
	if(data.mark == REGISTER){
		tryRegister(fd, data.name, data.message);
	}else if(data.mark == LOGIN){
		tryLogin(fd, data.name, data.message);
	}else if(data.mark == ADD_ONE){
		tryAddOne(data.name, data.message);
	}else if(data.mark == SEARCH_REQUEST){
		trySearch(fd, data.name, data.message);
	}else if(data.mark == TRANSPOND){
		tryTranspond(data.name, data.message);
	}
}

void ManageMsg::trySearch(int fd, const string &name, const string &oppName){
	DataStruct data;
	char language[5];
	bool ok = clientdb.checkClient(oppName.data(), NULL, language);
	data.name = name;
	data.message = string(language);
	if(ok){
		cout << "search successed" << endl;
		data.mark = SEARCH_SUCCESSED;
	}else{
		cout << "search failure" << endl;
		data.mark = SEARCH_FAILURE;
	}
	writeData(fd, data);
}

void ManageMsg::addToMap(int fd, const string &name){
	nameMapFd[name] = fd; // 將用户名与套接字描述符绑定
	fdMapName[fd] = name;
}

string ManageMsg::removeFromMap(int fd){
	string name = fdMapName[fd];
	if(name != ""){
		nameMapFd.erase(name);
		fdMapName.erase(fd);
	}
	return name;
}

void ManageMsg::disconnect(int fd){
	cout << fd << " disconnected" << endl;
	string offline_client = removeFromMap(fd);
	if(offline_client != ""){
		cout << offline_client << " offline" << endl;
		/*
		for(auto elem : nameMapFd){
			DataStruct data;
			data.name = elem.first;
			data.mark = OFFLINE;
			data.message = offline_client;
			writeData(elem.second, data);
		}
		*/
	}
}

void ManageMsg::tryAddOne(const string &name, const string &oppName){
	/*
	if(name == oppName){ // 添加自己为朋友
		auto it = nameMapFd.find(name);
		if(it != nameMapFd.end()){ // 自己在线
			DataStruct data;
			data.name = name;
			data.mark = ADD_ONE_SUCCESSED;
			data.message = oppName;
			writeData(it->second, data);
			cout << "add " << oppName << " successed" << endl;
		}
	}
	*/
}

void ManageMsg::tryRegister(int fd, const string &name, const string &message){
	DataStruct data;
	string password, language;
	splitData(message, 0, password);
	splitData(message, 1, language);
	int ilanguage;
	data.name = name;
	sscanf(language.data(), "%d", &ilanguage);
	bool ok = clientdb.tryInsertClient(name.data(), password.data(), ilanguage);
	if(ok){
		data.mark = REGISTER_SUCCESSED;
		data.message = "注册成功！";
		clientdb.tryInsertFriend(name.data(), name.data()); // 把自己添加进好友关系表
	}else{
		data.mark = REGISTER_FAILURE;
		data.message = "用户名已存在！";
	}
	writeData(fd, data);
}

void ManageMsg::tryTranspond(const string &name, const string &message){
	string oppName; // name 要传消息给 oppName
	string oppMessage;
	splitData(message, 0, oppName);
	splitData(message, 1, oppMessage);
	auto it = nameMapFd.find(oppName);
	if(it != nameMapFd.end()){
		DataStruct data;
		data.name = oppName;
		data.mark = TRANSPOND_SUCCESSED;
		data.message = name;
		data.message.append(1u, seg_char);
		data.message.append(oppMessage);
		writeData(it->second, data);
	}
}

void ManageMsg::tryAddAll(int fd, const string &name){
	DataStruct data;
	data.name = name;
	for(auto it=nameMapFd.begin(); it != nameMapFd.end(); it++){
		if(it->first != name){
			DataStruct sub;
			sub.name = it->first;
			sub.mark = ADD_SUCCESSED;
			sub.message = name;
			writeData(it->second, sub); // 向其他用户发送新用户信息
		}
		data.message += it->first; // 向新用户添加其他用户信息
		auto tmp_it = it;
		tmp_it++;
		if(tmp_it != nameMapFd.end())
			data.message.append(1u, seg_char); // 添加分隔符
	}
	data.mark = ADD_SUCCESSED;
	writeData(fd, data);
}

void ManageMsg::tryLogin(int fd, const string &name, const string &password){
	DataStruct data;
	data.name = name;
	bool ok = clientdb.checkClient(name.data(), password.data(), NULL);
	cout << "check: " << ok << endl;
	if(!ok){
		data.mark = LOGIN_FAILURE;
		data.message = "用户名或密码不正确！";
		writeData(fd, data);
		return;
	}
	auto it = nameMapFd.find(name);
	if(it == nameMapFd.end()){
		addToMap(fd, name);
		cout << name << " online" << endl;
		data.mark = LOGIN_SUCCESSED;
		data.message = "登录成功！";
	}else{
		data.mark = LOGIN_FAILURE;
		data.message = "该用户已登录！";
	}
	writeData(fd, data);
}
