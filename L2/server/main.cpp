#include "Server.h"

void *check_heart_thread(void *arg){
	Server *server = (Server *)arg;
	while(true){
		sleep(20);
		server->check_heart();
	}
	return ((void *)0);
}

int main(){
	Server server;
	if(!server.init())
		return 1;

	pthread_t heart_tid;
	if(pthread_create(&heart_tid, NULL, check_heart_thread, (void *)&server) != 0){
		perror("thread");
		return 1;
	}
	
	server.loop();
	return 0;
}
