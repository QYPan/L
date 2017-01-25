#ifndef SERVER_H
#define SERVER_H

#include "TcpServer.h"
#include "OnlineManager.h"

class Server{
public:
	Server();
	~Server();
	bool init();
	bool loop();
private:
	void deal_fd(int fd);
	TcpServer tcpServer;
	OnlineManager onlineManager;
};

#endif
