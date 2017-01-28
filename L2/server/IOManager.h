#ifndef IOMANAGER_H
#define IOMANAGER_H

#include <unistd.h>
#include <string>
#include <iostream>
using namespace std;

class IOManager{
public:
	IOManager();
	~IOManager();
	static void readData(int fd, string &data);
	static void ack_heart(int fd);
	static void ack_register(int fd, bool result);
	static void ack_login(int fd, bool result);
private:
};

#endif
