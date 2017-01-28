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
	void addToMap(int fd, const string &name);
	void removeFromMap(int fd);
private:
	void init();
	map<int, string> fdMapName;
	map<string, int> nameMapFd;
};

#endif
