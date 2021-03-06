#ifndef IOMANAGER_H
#define IOMANAGER_H

#include <unistd.h>
#include <string>
#include <vector>
#include <list>
#include <map>
#include <iostream>
#include "Clientdb.h"
#include "Server.h"
using namespace std;

class IOManager{
public:
	struct MessageType {
		string type;
		string msg;
	};
	IOManager();
	~IOManager();
	static void readData(int fd, string &data);
	static void ack_heart(int fd);
	static void ack_message(int fd, const string &msg);
	static void ack_transpond(int fd, bool isFriend, const string &oppName);
	static void ack_accept_verify(int fd, bool isFriend, const Clientdb::UserInfo &userInfo);
	static void ack_register(int fd, bool result);
	static void ack_login(int fd, bool result, bool logined, const Clientdb::UserInfo &userInfo);
	static void ack_relogin(int fd, bool result, const Clientdb::UserInfo &userInfo);
	static void ack_linkmans(int fd, bool result, const vector<Clientdb::UserInfo> &linkmans);
	static void ack_remove_linkman(int fd, bool isFriend, const string &name);
	static void ack_search_client(int fd, bool result, const Clientdb::UserInfo &userInfo);
	static void cache_syn_verify(const string &name, const Clientdb::UserInfo &userInfo, const string &msg);
	static void cache_syn_accept_verify(const Clientdb::UserInfo &userInfo, const string &name);
	static void cache_syn_transpond(const Clientdb::UserInfo &userInfo, const string &name, const MessageType &msgInfo);
	static int count_syn(const string &name);
	static void send_syn(int fd, const string &name);
	static void handle_ack(int fd, const string &name); // 收到客户端 ACK，可以发送下一条消息
private:
	static map<string, list<string> > syn_caches; // 待发送给用户的消息链
};

#endif
