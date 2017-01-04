#include "server.h"

Server::Server()
{
	server_address.sin_family = AF_INET;
	server_address.sin_addr.s_addr = htonl(INADDR_ANY);
	server_address.sin_port = htons(9734);
	server_len = sizeof(server_address);
	seg_char = '#';
}

Server::~Server(){
}

bool Server::init(){
	server_sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if(server_sockfd == -1){
		perror("socket");
		return false;
	}
	if(bind(server_sockfd, (struct sockaddr *)&server_address, server_len) == -1){
		perror("bind");
		return false;
	}
	if(listen(server_sockfd, 5) == -1){
		perror("listen");
		return false;
	}
	FD_ZERO(&readfds);
	FD_SET(server_sockfd, &readfds);
	max_fd = server_sockfd;
	printf("listen successed!\n");
	return clientdb.init();
}

void Server::judgeFd(int fd){
	if(fd == server_sockfd){ // 新连接
		client_len = sizeof(client_address);
		client_sockfd = accept(server_sockfd,
				(struct sockaddr *)&client_address, (socklen_t *)&client_len);
		FD_SET(client_sockfd, &readfds);
		if(client_sockfd > max_fd) max_fd = client_sockfd;
	}else{ // 肯定是客户请求
		int nread;
		ioctl(fd, FIONREAD, &nread); // 检查套接字缓存有无数据可读
		if(nread == 0){
			close(fd);
			FD_CLR(fd, &readfds);
			disconnect(fd);
		}else{
			DataStruct data;
			readData(fd, data);
			handle(fd, data);
		}
	}
}

void Server::disconnect(int fd){
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

void Server::readData(int fd, DataStruct &data){
	char buffer[2000] = {0};
	string tmp_mark;
	string str_buffer;

	read(fd, buffer, sizeof(buffer));
	str_buffer = string(buffer);
	splitData(str_buffer, 0, data.name);
	splitData(str_buffer, 1, tmp_mark);
	splitData(str_buffer, 2, data.message);

	data.mark = static_cast<MessageType>(tmp_mark[0]-'0');
}

void Server::writeData(int fd, const DataStruct &data){
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

bool Server::loop(){
	while(true){
		fd_set testfds = readfds; // select 调用会改变 readfds，故需用中间变量
		//printf("server waiting\n");

		int activity = select(max_fd+1, &testfds, (fd_set *)0,
				              (fd_set *)0, (struct timeval *)0);
		if(activity < 1){
			perror("server");
			return false;
		}

		for(int fd = 0; fd <= max_fd; fd++){
			if(FD_ISSET(fd, &testfds)){
				judgeFd(fd);
			}
		}
	}
}

// 获取字符串 data 以 seg_char 为分隔符的第 k 段，k 为 0，1，2
void Server::splitData(const string &str, int k, string &sub){
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

void Server::handle(int fd, const DataStruct &data){
	if(data.mark == REGISTER){
		tryRegister(fd, data.name, data.message);
	}else if(data.mark == LOGIN){
		tryLogin(fd, data.name, data.message);
	}else if(data.mark == ADD_ALL){
		tryAddAll(fd, data.name);
	}else if(data.mark == TRANSPOND){
		tryTranspond(data.name, data.message);
	}
}

void Server::tryRegister(int fd, const string &name, const string &message){
	DataStruct data;
	string password, language;
	splitData(message, 0, password);
	splitData(message, 1, language);
	int ilanguage;
	data.name = name;
	sscanf(language.data(), "%d", &ilanguage);
	bool ok = clientdb.tryInsert(name.data(), password.data(), ilanguage);
	if(ok){
		data.mark = REGISTER_SUCCESSED;
		data.message = "注册成功！";
	}else{
		data.mark = REGISTER_FAILURE;
		data.message = "用户名已存在！";
	}
	writeData(fd, data);
}

void Server::tryTranspond(const string &name, const string &message){
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

void Server::tryAddAll(int fd, const string &name){
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

void Server::addToMap(int fd, const string &name){
	nameMapFd[name] = fd; // 將用户名与套接字描述符绑定
	fdMapName[fd] = name;
}

string Server::removeFromMap(int fd){
	string name = fdMapName[fd];
	if(name != ""){
		nameMapFd.erase(name);
		fdMapName.erase(fd);
	}
	return name;
}

void Server::tryLogin(int fd, const string &name, const string &password){
	DataStruct data;
	data.name = name;
	bool ok = clientdb.checkClient(name.data(), password.data());
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
