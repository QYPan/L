#include "IOManager.h"
#include <json/json.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

IOManager::IOManager(){
}

IOManager::~IOManager(){
}

void IOManager::readData(int fd, string &data){
	char buffer[1000] = {0};
	read(fd, buffer, sizeof(buffer));
	data = string(buffer);
}

void IOManager::ack_linkmans(int fd, bool result, const vector<Clientdb::UserInfo> &linkmans){
	char buffer[1000] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "LINKMANS";
	if(result){
		root["result"] = "yes";
		Json::Value arrayObj;
		for(auto it : linkmans){
			Json::Value item;
			item["name"] = it.name;
			item["language"] = it.language;
			item["sex"] = it.sex;
			arrayObj.append(item);
		}
		root["linkmans"] = arrayObj;
	}else{
		root["result"] = "no";
	}
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer));
}

void IOManager::ack_login(int fd, bool result, const Clientdb::UserInfo &userInfo){
	char buffer[200] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "LOGIN";
	if(result){
		root["result"] = "yes";
		Json::Value juserInfo;
		juserInfo["name"] = userInfo.name;
		juserInfo["password"] = userInfo.password;
		juserInfo["language"] = userInfo.language;
		juserInfo["sex"] = userInfo.sex;
		root["userInfo"] = juserInfo;
	}else{
		root["result"] = "no";
	}
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer));
}

void IOManager::ack_register(int fd, bool result){
	char buffer[200] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "REGISTER";
	if(result){
		root["result"] = "yes";
	}else{
		root["result"] = "no";
	}
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer));
}

void IOManager::ack_heart(int fd){
	char buffer[100] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "HEART";
	// JSON 转换为 JSON 字符串(已格式化)
	//string strOut = root.toStyledString();
	
	// JSON 转换为 JSON 字符串(未格式化)
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer));
}
