#ifndef SERVER_H
#define SERVER_H

#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <iostream>
#include "managemsg.h"
using namespace std;

class Server{
public:
	Server();
	~Server();
	bool init();
	bool loop();
private:
	void judgeFd(int fd);

	struct sockaddr_in server_address;
	struct sockaddr_in client_address;
	fd_set readfds;
	ManageMsg manageMsg;

	int server_sockfd;
	int client_sockfd;
	int server_len;
	int client_len;
	int max_fd; // 当前最大套接字描述符
};


#endif
