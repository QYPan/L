#ifndef ONLINEMANAGER_H
#define ONLINEMANAGER_H

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <map>
using namespace std;

class OnlineManager{
public:
	OnlineManager();
	~OnlineManager();
	int isOnline(const string &name);
	void addToMap(int fd, const string &name);
	void removeFromMap(int fd);
	void removeFromMap(const string &name);
private:
	void init();
	map<int, string> fdMapName;
	map<string, int> nameMapFd;
};

#endif
