#include "server.h"

int main(){
	Server server;
	if(!server.init())
		return 1;
	server.loop();
	return 0;
}
