#include "TcpServer.h"

TcpServer::TcpServer(){
}

bool TcpServer::init(){
	init_address();
	if(!init_socket()){
		return false;
	}
	return true;
}

bool TcpServer::begin_listen(){
	if(listen(server_sockfd, 5) == -1){
		perror("listen");
		return false;
	}
	return true;
}

bool TcpServer::init_socket(){
	server_sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if(server_sockfd == -1){
		perror("socket");
		return false;
	}
	int on = 1;
	setsockopt(server_sockfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));
	if(bind(server_sockfd, (struct sockaddr *)&server_address, server_len) == -1){
		perror("bind");
		return false;
	}
	return true;
}

int TcpServer::try_accept(){
	client_sockfd = accept(server_sockfd,
			(struct sockaddr *)&client_address, (socklen_t *)&client_len);
	return client_sockfd;
}

void TcpServer::init_address(){
	server_address.sin_family = AF_INET;
	server_address.sin_addr.s_addr = htonl(INADDR_ANY);
	server_address.sin_port = htons(9658);
	server_len = sizeof(server_address);
}

TcpServer::~TcpServer(){
}
