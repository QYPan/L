#include "OnlineManager.h"

OnlineManager::OnlineManager()
{
}

OnlineManager::~OnlineManager(){
}

int OnlineManager::isOnline(const string &name){
	auto it = nameMapFd.find(name);
	if(it != nameMapFd.end()){
		return it->second;
	}
	return -1;
}

void OnlineManager::addToMap(int fd, const string &name){
	removeFromMap(name);
	fdMapName[fd] = name;
	nameMapFd[name] = fd;
}

void OnlineManager::removeFromMap(const string &name){
	auto it = nameMapFd.find(name);
	if(it != nameMapFd.end()){
		int fd = it->second;
		fdMapName.erase(fd);
		nameMapFd.erase(name);
	}
}

void OnlineManager::removeFromMap(int fd){
	auto it = fdMapName.find(fd);
	if(it != fdMapName.end()){
		string name = it->second;
		fdMapName.erase(fd);
		nameMapFd.erase(name);
	}
}
