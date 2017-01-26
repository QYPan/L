#ifndef SERVER_H
#define SERVER_H

#include "TcpServer.h"
#include "OnlineManager.h"
#include "Clientdb.h"

class Server{
public:
	Server();
	~Server();
	bool init();
	bool loop();
	void check_heart();
private:
	void close_connection(int fd);
	void deal_fd(int fd);
	void handle_client(int fd);
	TcpServer tcpServer;
	OnlineManager onlineManager;
	Clientdb clientdb;
};

#endif
