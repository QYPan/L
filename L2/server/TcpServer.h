#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <sys/socket.h>
#include <sys/types.h>
#include <errno.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

class TcpServer{
public:
	TcpServer();
	~TcpServer();
	int get_fd() const {return server_sockfd;}
	int try_accept();
	bool is_client(int fd);
	bool is_outtime(int fd);
	bool begin_listen();
	bool init();

	void init_heart_time(int fd);
	void set_outtime(int fd);
	void set_fd(int fd);
	void close_fd(int fd);
	int get_max_fd() const {return max_fd;}
	int try_select(fd_set *testfds);
	fd_set get_fd_set() const {return readfds;}
private:
	bool init_socket();
	void init_address();
	void init_heart_count();

	bool heartCount[1200];
	fd_set readfds;

	pthread_mutex_t heart_lock;
	pthread_mutex_t readfds_lock;

	struct sockaddr_in server_address;
	struct sockaddr_in client_address;
	int server_sockfd;
	int client_sockfd;
	int server_len;
	int client_len;
	int max_fd; // 当前最大套接字描述符
};

#endif
