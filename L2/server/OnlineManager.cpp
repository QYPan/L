#include "OnlineManager.h"

OnlineManager::OnlineManager()
{
}

OnlineManager::~OnlineManager(){
}

void OnlineManager::addToMap(int fd, const string &name){
	removeFromMap(fd);
	fdMapName[fd] = name;
	nameMapFd[name] = fd;
}

void OnlineManager::removeFromMap(int fd){
	auto it = fdMapName.find(fd);
	if(it != fdMapName.end()){
		string name = it->second;
		fdMapName.erase(fd);
		nameMapFd.erase(name);
	}
}
