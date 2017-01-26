#include "TcpServer.h"

TcpServer::TcpServer()
	: heart_lock(PTHREAD_MUTEX_INITIALIZER)
	, readfds_lock(PTHREAD_MUTEX_INITIALIZER)
	, max_fd(-1)
{
	FD_ZERO(&readfds);
}

bool TcpServer::init(){
	init_address();
	init_heart_count();
	if(!init_socket()){
		return false;
	}
	return true;
}

bool TcpServer::is_client(int fd){
	if(fd != server_sockfd && FD_ISSET(fd, &readfds)){
		return true;
	}
	return false;
}

void TcpServer::init_heart_time(int fd){
	pthread_mutex_lock(&heart_lock);
	heartCount[fd] = false;
	pthread_mutex_unlock(&heart_lock);
}

void TcpServer::set_outtime(int fd){
	pthread_mutex_lock(&heart_lock);
	heartCount[fd] = true;
	pthread_mutex_unlock(&heart_lock);
}

bool TcpServer::is_outtime(int fd){
	return heartCount[fd];
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

void TcpServer::init_heart_count(){
	for(int i = 0; i < 1200; i++){
		heartCount[i] = false;
	}
}

void TcpServer::set_fd(int fd){
	FD_SET(fd, &readfds);
	if(fd > max_fd)
		max_fd = fd;
}

void TcpServer::close_fd(int fd){
	close(fd);
	FD_CLR(fd, &readfds);
}

int TcpServer::try_select(fd_set *testfds){
	int activity = select(max_fd+1, testfds, (fd_set *)0,
			              (fd_set *)0, (struct timeval *)0);
	return activity;
}


TcpServer::~TcpServer(){
}
