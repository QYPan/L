#include "Server.h"
#include "IOManager.h"
#include <stdio.h>
#include <vector>
#include <sys/ioctl.h>
using namespace std;

Server::Server(){
}

bool Server::init(){
	if(!tcpServer.init()){
		return false;
	}
	if(!tcpServer.begin_listen()){
		return false;
	}
	if(!clientdb.init()){
		return false;
	}

	tcpServer.set_fd(tcpServer.get_fd());

	printf("server init successed!\n");

	return true;
}

void Server::check_heart(){ // 这个是子线程函数
	for(int fd = 0; fd <= tcpServer.get_max_fd(); fd++){
		if(tcpServer.is_client(fd)){
			if(!tcpServer.is_outtime(fd)){
				tcpServer.set_outtime(fd);
			}else{
				tcpServer.init_heart_time(fd);
				close_connection(fd);
			}
		}
	}
}

void Server::close_connection(int fd){
	onlineManager.removeFromMap(fd);
	tcpServer.close_fd(fd);
	printf("%d disconnected\n", fd);
}

void Server::handle_fd(int fd){

	if(fd == tcpServer.get_fd()){ // 有新连接

		int new_client_fd = tcpServer.try_accept();
		if(new_client_fd != -1){
			tcpServer.set_fd(new_client_fd);
			tcpServer.init_heart_time(new_client_fd);
			printf("new connection %d\n", new_client_fd);
		}else{
			perror("accept");
		}

	}else{ // 肯定是客户请求

		int nread;
		ioctl(fd, FIONREAD, &nread); // 检查套接字缓存有无数据可读
		if(nread == 0){ // 对端关闭 socket
			close_connection(fd);
		}else{
			handle_client(fd);
		}

	}
}

void Server::handle_client(int fd){
	string data;
	IOManager::readData(fd, data);
	tcpServer.init_heart_time(fd);
	cout << "read data: " << data << endl;
	Json::Reader reader;
	Json::Value value;
	if(reader.parse(data, value)){
		string mtype = value["mtype"].asString(); // 请求 or 应答
		if(mtype == "SYN"){
			handle_syn(fd, value);
		}else if(mtype == "ACK"){
			handle_ack(fd, value);
		}
	}
}

void Server::handle_ack(int fd, const Json::Value &value){
	IOManager::ack_message(fd, string("ACK_ACK_SYN"));
	string clientName = value["clientName"].asString();
	IOManager::handle_ack(fd, clientName);
}

void Server::handle_syn(int fd, const Json::Value &value){
	string dtype = value["dtype"].asString(); // 消息类型
	if(dtype == "HEART"){
		IOManager::ack_heart(fd);
	}else if(dtype == "REGISTER"){
		handle_syn_register(fd, value);
	}else if(dtype == "READY"){ // 对端已经初始化完毕
		handle_syn_ready(fd, value);
	}else if(dtype == "LOGIN"){
		handle_syn_login(fd, value);
	}else if(dtype == "LINKMANS"){ // 获取好友列表
		handle_syn_linkmans(fd, value);
	}else if(dtype == "SEARCH_CLIENT"){ // 查询用户
		handle_syn_search_client(fd, value);
	}else if(dtype == "VERIFY"){ // 添加好友请求
		handle_syn_verify(fd, value);
	}else if(dtype == "ACCEPT_VERIFY"){ // 同意好友请求
		handle_syn_accept_verify(fd, value);
	}else if(dtype == "REMOVE_LINKMAN"){ // 删除好友请求
		handle_syn_remove_linkman(fd, value);
	}else if(dtype == "TRANSPOND"){ // 转发请求
		handle_syn_transpond(fd, value);
	}
}

void Server::try_send_syn(const string &clientName){
	int fd = onlineManager.isOnline(clientName);
	if(fd != -1){
		int counts = IOManager::count_syn(clientName);
		if(counts == 1){
			IOManager::send_syn(fd, clientName);
		}
	}
}

void Server::handle_syn_transpond(int fd, const Json::Value &value){
	Clientdb::UserInfo userInfo;
	Json::Value userInfoObj;

	userInfoObj = value["userInfo"];
	userInfo.name = userInfoObj["name"].asString();
	userInfo.language = userInfoObj["language"].asString();
	userInfo.sex = userInfoObj["sex"].asInt();

	string oppName = value["oppName"].asString();
	string msg = value["msg"].asString();

	bool isFriend = clientdb.findFriend(userInfo.name, oppName);
	IOManager::ack_transpond(fd, isFriend, oppName);
	if(isFriend){
		IOManager::cache_syn_transpond(userInfo, oppName, msg);
		try_send_syn(oppName);
	}
}

void Server::handle_syn_ready(int fd, const Json::Value &value){
	IOManager::ack_message(fd, string("READY")); // 先回应
	string clientName = value["clientName"].asString();
	IOManager::send_syn(fd, clientName);
}

void Server::handle_syn_remove_linkman(int fd, const Json::Value &value){
	string clientName = value["clientName"].asString();
	string oppName = value["oppName"].asString();

	bool isFriend = clientdb.findFriend(clientName, oppName);
	IOManager::ack_remove_linkman(fd, isFriend, oppName);
	if(isFriend){
		bool ok1 = clientdb.removeFriend(clientName, oppName);
		if(ok1){
			bool ok2 = clientdb.removeFriend(oppName, clientName);
			if(!ok2){
				clientdb.insertFriend(clientName, oppName);
			}
		}
	}
}

void Server::handle_syn_accept_verify(int fd, const Json::Value &value){
	Clientdb::UserInfo userInfo, oppUserInfo;
	Json::Value userInfoObj;
	Json::Value oppUserInfoObj;
	userInfoObj = value["userInfo"];
	userInfo.name = userInfoObj["name"].asString();
	userInfo.language = userInfoObj["language"].asString();
	userInfo.sex = userInfoObj["sex"].asInt();
	oppUserInfoObj = value["oppUserInfo"];
	oppUserInfo.name = oppUserInfoObj["name"].asString();
	oppUserInfo.language = oppUserInfoObj["language"].asString();
	oppUserInfo.sex = oppUserInfoObj["sex"].asInt();

	bool isFriend = clientdb.findFriend(userInfo.name, oppUserInfo.name);
	IOManager::ack_accept_verify(fd, isFriend, oppUserInfo); // 回应请求方
	if(!isFriend){
		bool ok1 = clientdb.insertFriend(userInfo.name, oppUserInfo.name);
		if(ok1){
			bool ok2 = clientdb.insertFriend(oppUserInfo.name, userInfo.name);
			if(ok2){ // 到这步则表示已经把双方的好友关系都添加进数据库
				IOManager::cache_syn_accept_verify(userInfo, oppUserInfo.name);
				try_send_syn(oppUserInfo.name);
			}else{
				clientdb.removeFriend(userInfo.name, oppUserInfo.name);
			}
		}
	}
}

void Server::handle_syn_verify(int fd, const Json::Value &value){
	IOManager::ack_message(fd, "VERIFY"); // 先回应
	Clientdb::UserInfo userInfo;
	Json::Value userInfoObj;
	string oppClientName = value["oppClientName"].asString();
	string msg = value["verifyMsg"].asString();
	userInfoObj = value["userInfo"];
	userInfo.name = userInfoObj["name"].asString();
	userInfo.language = userInfoObj["language"].asString();
	userInfo.sex = userInfoObj["sex"].asInt();
	IOManager::cache_syn_verify(oppClientName, userInfo, msg);

	try_send_syn(oppClientName);
}

void Server::handle_syn_search_client(int fd, const Json::Value &value){
	string clientName = value["clientName"].asString();
	Clientdb::UserInfo userInfo;
	bool res = clientdb.findClient(clientName, userInfo);
	IOManager::ack_search_client(fd, res, userInfo);
}

void Server::handle_syn_linkmans(int fd, const Json::Value &value){
	string clientName = value["clientName"].asString();
	vector<Clientdb::UserInfo> linkmans;
	bool res = clientdb.getFriends(clientName, linkmans);
	IOManager::ack_linkmans(fd, res, linkmans);
}

void Server::handle_syn_register(int fd, const Json::Value &value){
	Clientdb::UserInfo userInfo;
	Json::Value userInfoObj;
	userInfoObj = value["userInfo"];
	userInfo.name = userInfoObj["name"].asString();
	userInfo.password = userInfoObj["password"].asString();
	userInfo.language = userInfoObj["language"].asString();
	userInfo.sex = userInfoObj["sex"].asInt();
	bool res = clientdb.insertClient(userInfo);
	IOManager::ack_register(fd, res);
}

void Server::handle_syn_login(int fd, const Json::Value &value){
	Clientdb::UserInfo userInfo;
	Json::Value userInfoObj;
	userInfoObj = value["userInfo"];
	string login_name = userInfoObj["name"].asString();
	string login_password = userInfoObj["password"].asString();

	int login_fd = onlineManager.isOnline(login_name);
	bool res = clientdb.findClient(login_name, userInfo);
	bool ok = (res && (login_password == userInfo.password));

	IOManager::ack_login(fd, ok, login_fd != -1, userInfo);
	if(ok && (login_fd == -1)){
		onlineManager.addToMap(fd, login_name);
	}
}

bool Server::loop(){
	while(true){
		fd_set testfds = tcpServer.get_fd_set();
		int activity = tcpServer.try_select(&testfds);
		if(activity < 1){
			perror("select");
			return false;
		}
		int max_fd = tcpServer.get_max_fd();
		for(int fd = 0; fd <= max_fd; fd++){
			if(FD_ISSET(fd, &testfds)){
				handle_fd(fd);
			}
		}
	}
}

Server::~Server(){
}
