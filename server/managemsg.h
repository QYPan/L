#ifndef MANAGEMSG_H
#define MANAGEMSG_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <string>
#include <map>
#include <iostream>
#include "clientdb.h"
using namespace std;

class Server;

class ManageMsg{
public:
	friend class Server;
	enum MessageType {LOGIN, ADD_ONE, ADD_ONE_SUCCESSED, ADD_ONE_FAILURE, ADD_ALL, TRANSPOND,
	                  ADD_ALL_SUCCESSED, LOGIN_FAILURE, LOGIN_SUCCESSED,
	                  OFFLINE, TRANSPOND_SUCCESSED, REGISTER,
				      REGISTER_FAILURE, REGISTER_SUCCESSED, CONNECT, SEARCH_REQUEST, SEARCH_SUCCESSED,
	                  SEARCH_FAILURE};
	enum Language {CHINESE, ENGLISH};
	struct DataStruct {
		DataStruct()
			: name("")
			, message("")
		{}
		string name;
		string message;
		MessageType mark;
	};
	ManageMsg();
	void deal(int fd);

private:
	void handle(int fd, const DataStruct &data);
	void splitData(const string &str, int k, string &sub);
	void tryRegister(int fd, const string &name, const string &message);
	void tryAddOne(const string &name, const string &message);
	void tryLogin(int fd, const string &name, const string &password);
	void tryAddAll(int fd, const string &name);
	void trySearch(int fd, const string &name, const string &oppName);
	void tryTranspond(const string &name, const string &message);
	void dealAddOneAnswer(const string &name, const string &message, MessageType type);
	void readData(int fd, DataStruct &data);
	void writeData(int fd, const DataStruct &data);
	void addToMap(int fd, const string &name);
	string removeFromMap(int fd);
	void disconnect(int fd);
	map<string, int> nameMapFd; // 映射用户名与套接字描述符
	map<int, string> fdMapName; // 映射用户名与套接字描述符
	Clientdb clientdb;
	char seg_char; // 数据分隔符
};


#endif
