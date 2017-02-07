#include "IOManager.h"
#include <json/json.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

map<string, list<string> > IOManager::syn_caches;

IOManager::IOManager(){
}

IOManager::~IOManager(){
}

void IOManager::readData(int fd, string &data){
	char buffer[1001] = {0};
	read(fd, buffer, sizeof(buffer)-1);
	data = string(buffer);
}

int IOManager::count_syn(const string &name){
	auto &msg_list = syn_caches[name];
	return msg_list.size();
}

void IOManager::handle_ack(int fd, const string &name){
	auto &msg_list = syn_caches[name];
	if(!msg_list.empty()){
		msg_list.pop_front(); // 移除前一条消息
		send_syn(fd, name); // 发送下一条消息
	}
}

void IOManager::send_syn(int fd, const string &name){
	auto &msg_list = syn_caches[name];
	if(!msg_list.empty()){
		char buffer[1001] = {0};
		strcpy(buffer, msg_list.front().c_str());
		write(fd, buffer, sizeof(buffer)-1);
	}
}

void IOManager::cache_syn_transpond(const Clientdb::UserInfo &userInfo, const string &name, const string &msg){
	Json::Value root;
	root["mtype"] = "SYN";
	root["dtype"] = "TRANSPOND";
	Json::Value juserInfo;
	juserInfo["name"] = userInfo.name;
	juserInfo["language"] = userInfo.language;
	juserInfo["sex"] = userInfo.sex;
	root["userInfo"] = juserInfo;
	root["msg"] = msg;
	Json::FastWriter writer;
	string strOut = writer.write(root);
	auto &msg_list = syn_caches[name];
	msg_list.push_back(strOut);
}

void IOManager::ack_transpond(int fd, bool isFriend, const string &oppName){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "TRANSPOND";
	root["isFriend"] = isFriend;
	root["oppName"] = oppName;

	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}

void IOManager::ack_remove_linkman(int fd, bool isFriend, const string &name){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "REMOVE_LINKMAN";
	root["isFriend"] = isFriend;
	root["name"] = name;
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}

void IOManager::ack_accept_verify(int fd, bool isFriend, const Clientdb::UserInfo &userInfo){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "ACCEPT_VERIFY";
	root["isFriend"] = isFriend;
	Json::Value juserInfo;
	juserInfo["name"] = userInfo.name;
	juserInfo["language"] = userInfo.language;
	juserInfo["sex"] = userInfo.sex;
	root["userInfo"] = juserInfo;
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}

void IOManager::cache_syn_accept_verify(const Clientdb::UserInfo &userInfo, const string &name){
	Json::Value root;
	root["mtype"] = "SYN";
	root["dtype"] = "ACCEPT_VERIFY";
	Json::Value juserInfo;
	juserInfo["name"] = userInfo.name;
	juserInfo["language"] = userInfo.language;
	juserInfo["sex"] = userInfo.sex;
	root["userInfo"] = juserInfo;
	Json::FastWriter writer;
	string strOut = writer.write(root);
	auto &msg_list = syn_caches[name];
	msg_list.push_back(strOut);
}

void IOManager::cache_syn_verify(const string &name, const Clientdb::UserInfo &userInfo, const string &msg){
	Json::Value root;
	root["mtype"] = "SYN";
	root["dtype"] = "VERIFY";
	Json::Value juserInfo;
	juserInfo["name"] = userInfo.name;
	juserInfo["language"] = userInfo.language;
	juserInfo["sex"] = userInfo.sex;
	root["userInfo"] = juserInfo;
	root["verifyMsg"] = msg;
	Json::FastWriter writer;
	string strOut = writer.write(root);
	auto &msg_list = syn_caches[name];
	msg_list.push_back(strOut);
}


void IOManager::ack_search_client(int fd, bool result, const Clientdb::UserInfo &userInfo){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "SEARCH_CLIENT";
	root["result"] = result;
	if(result){
		Json::Value juserInfo;
		juserInfo["name"] = userInfo.name;
		juserInfo["language"] = userInfo.language;
		juserInfo["sex"] = userInfo.sex;
		root["userInfo"] = juserInfo;
	}
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}

void IOManager::ack_linkmans(int fd, bool result, const vector<Clientdb::UserInfo> &linkmans){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "LINKMANS";
	root["result"] = result;
	if(result){
		Json::Value arrayObj;
		for(auto it : linkmans){
			Json::Value item;
			item["name"] = it.name;
			item["language"] = it.language;
			item["sex"] = it.sex;
			arrayObj.append(item);
		}
		root["linkmans"] = arrayObj;
	}
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}

void IOManager::ack_relogin(int fd, bool result, const Clientdb::UserInfo &userInfo){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "RELOGIN";
	root["result"] = result;
	if(result){
		Json::Value juserInfo;
		juserInfo["name"] = userInfo.name;
		juserInfo["password"] = userInfo.password;
		juserInfo["language"] = userInfo.language;
		juserInfo["sex"] = userInfo.sex;
		root["userInfo"] = juserInfo;
	}
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}

void IOManager::ack_login(int fd, bool result, bool logined, const Clientdb::UserInfo &userInfo){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "LOGIN";
	root["result"] = result;
	if(result){
		root["logined"] = logined;
		if(!logined){
			Json::Value juserInfo;
			juserInfo["name"] = userInfo.name;
			juserInfo["password"] = userInfo.password;
			juserInfo["language"] = userInfo.language;
			juserInfo["sex"] = userInfo.sex;
			root["userInfo"] = juserInfo;
		}
	}
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}

void IOManager::ack_register(int fd, bool result){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "REGISTER";
	root["result"] = result;
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}

void IOManager::ack_message(int fd, const string &msg){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = msg;
	// JSON 转换为 JSON 字符串(已格式化)
	//string strOut = root.toStyledString();
	
	// JSON 转换为 JSON 字符串(未格式化)
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}

void IOManager::ack_heart(int fd){
	char buffer[1001] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "HEART";
	// JSON 转换为 JSON 字符串(已格式化)
	//string strOut = root.toStyledString();
	
	// JSON 转换为 JSON 字符串(未格式化)
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer)-1);
}
