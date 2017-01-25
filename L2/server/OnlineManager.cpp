#include "OnlineManager.h"

OnlineManager::OnlineManager()
	: max_fd(-1)
{
	init();
}

void OnlineManager::init(){
	FD_ZERO(&readfds);
}

void OnlineManager::set_fd(int fd){
	FD_SET(fd, &readfds);
	if(fd > max_fd)
		max_fd = fd;
}

void OnlineManager::kill_client(int fd){
	close(fd);
	FD_CLR(fd, &readfds);
}

int OnlineManager::try_select(fd_set *testfds){
	int activity = select(max_fd+1, testfds, (fd_set *)0,
			              (fd_set *)0, (struct timeval *)0);
	return activity;
}

OnlineManager::~OnlineManager(){
}
