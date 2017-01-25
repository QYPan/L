#ifndef TCPSERVER_H
#define TCPSERVER_H

#include <sys/socket.h>
#include <errno.h>
#include <netinet/in.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

class TcpServer{
public:
	TcpServer();
	~TcpServer();
	int get_fd() const {return server_sockfd;}
	int try_accept();
	bool begin_listen();
	bool init();
private:
	bool init_socket();
	void init_address();

	struct sockaddr_in server_address;
	struct sockaddr_in client_address;
	int server_sockfd;
	int client_sockfd;
	int server_len;
	int client_len;
};

#endif
