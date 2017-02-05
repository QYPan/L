#ifndef SERVER_H
#define SERVER_H

#include <json/json.h>
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
	void handle_fd(int fd);
	void handle_client(int fd);
	void handle_syn(int fd, const Json::Value &value);
	void handle_syn_register(int fd, const Json::Value &value);
	void handle_syn_login(int fd, const Json::Value &value);
	void handle_syn_relogin(int fd, const Json::Value &value);
	void handle_syn_linkmans(int fd, const Json::Value &value);
	void handle_syn_search_client(int fd, const Json::Value &value);
	void handle_syn_ready(int fd, const Json::Value &value);
	void handle_syn_verify(int fd, const Json::Value &value);
	void handle_syn_accept_verify(int fd, const Json::Value &value);
	void handle_syn_remove_linkman(int fd, const Json::Value &value);
	void handle_syn_transpond(int fd, const Json::Value &value);
	void handle_ack(int fd, const Json::Value &value);
	void try_send_syn(const string &clientName);
	TcpServer tcpServer;
	OnlineManager onlineManager;
	Clientdb clientdb;
};

#endif
