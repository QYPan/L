#include "server.h"

Server::Server()
{
	server_address.sin_family = AF_INET;
	server_address.sin_addr.s_addr = htonl(INADDR_ANY);
	server_address.sin_port = htons(9734);
	server_len = sizeof(server_address);
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
	return manageMsg.clientdb.init();
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
			manageMsg.disconnect(fd);
		}else{
			manageMsg.deal(fd);
		}
	}
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

