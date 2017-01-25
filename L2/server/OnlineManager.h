#ifndef ONLINEMANAGER_H
#define ONLINEMANAGER_H

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

class OnlineManager{
public:
	OnlineManager();
	~OnlineManager();
	void set_fd(int fd);
	void kill_client(int fd);
	int get_max_fd() const {return max_fd;}
	int try_select(fd_set *testfds);
	fd_set get_fd_set() const {return readfds;}
private:
	void init();
	fd_set readfds;
	int max_fd; // 当前最大套接字描述符
};

#endif
