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
		}
	}
}

void Server::handle_syn(int fd, const Json::Value &value){
	string dtype = value["dtype"].asString(); // 消息类型
	if(dtype == "HEART"){
		IOManager::ack_heart(fd);
	}else if(dtype == "REGISTER"){
		handle_syn_register(fd, value);
	}else if(dtype == "LOGIN"){
		handle_syn_login(fd, value);
	}else if(dtype == "LINKMANS"){ // 获取好友列表
		handle_syn_linkmans(fd, value);
	}
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
	bool res = clientdb.findClient(login_name, userInfo);
	bool ok = (res && (login_password == userInfo.password));
	IOManager::ack_login(fd, ok, userInfo);
	if(ok){
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
