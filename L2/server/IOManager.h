#ifndef IOMANAGER_H
#define IOMANAGER_H

#include <unistd.h>
#include <string>
#include <vector>
#include <iostream>
#include "Clientdb.h"
using namespace std;

class IOManager{
public:
	IOManager();
	~IOManager();
	static void readData(int fd, string &data);
	static void ack_heart(int fd);
	static void ack_register(int fd, bool result);
	static void ack_login(int fd, bool result, const Clientdb::UserInfo &userInfo);
	static void ack_linkmans(int fd, bool result, const vector<Clientdb::UserInfo> &linkmans);
private:
};

#endif
