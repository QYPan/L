#include "Server.h"
#include <stdio.h>
#include <sys/ioctl.h>

Server::Server(){
}

bool Server::init(){
	if(!tcpServer.init()){
		return false;
	}
	if(!tcpServer.begin_listen()){
		return false;
	}

	onlineManager.set_fd(tcpServer.get_fd());

	printf("server init successed!\n");

	return true;
}

void Server::deal_fd(int fd){
	if(fd == tcpServer.get_fd()){ // 有新连接
		int new_client_fd = tcpServer.try_accept();
		if(new_client_fd != -1){
			onlineManager.set_fd(new_client_fd);
		}
	}else{ // 肯定是客户请求
		int nread;
		ioctl(fd, FIONREAD, &nread); // 检查套接字缓存有无数据可读
		if(nread == 0){
			onlineManager.kill_client(fd);
		}else{
		}
	}
}

bool Server::loop(){
	while(true){
		fd_set testfds = onlineManager.get_fd_set();
		int activity = onlineManager.try_select(&testfds);
		if(activity < 1){
			perror("select");
			return false;
		}
		int max_fd = onlineManager.get_max_fd();
		for(int fd = 0; fd <= max_fd; fd++){
			if(FD_ISSET(fd, &testfds)){
				deal_fd(fd);
			}
		}
	}
}

Server::~Server(){
}
