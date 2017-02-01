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
	char buffer[1000] = {0};
	read(fd, buffer, sizeof(buffer));
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
		char buffer[1000] = {0};
		strcpy(buffer, msg_list.front().c_str());
		write(fd, buffer, sizeof(buffer));
	}
}

void IOManager::ack_remove_linkman(int fd, const string &name){
	char buffer[200] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "REMOVE_LINKMAN";
	root["name"] = name;
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer));
}

void IOManager::ack_bad_accept_verify(int fd, const string &name){
	char buffer[200] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "ACCEPT_VERIFY";
	root["result"] = false;
	root["name"] = name;
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer));
}

void IOManager::cache_syn_accept_verify(int fd, const Clientdb::UserInfo &userInfo, const Clientdb::UserInfo &oppUserInfo){
	// 告诉 user 已经把 oppUser 加为好友
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "ACCEPT_VERIFY";
	root["result"] = true;
	Json::Value juserInfo;
	juserInfo["name"] = oppUserInfo.name;
	juserInfo["language"] = oppUserInfo.language;
	juserInfo["sex"] = oppUserInfo.sex;
	root["userInfo"] = juserInfo;
	Json::FastWriter writer;
	string strOut = writer.write(root);

	char buffer[1000] = {0};
	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer));

	// 告诉 oppUser 已经把 user 加为好友
	Json::Value oppRoot;
	oppRoot["mtype"] = "SYN";
	oppRoot["dtype"] = "ACCEPT_VERIFY";
	Json::Value jOppUserInfo;
	jOppUserInfo["name"] = userInfo.name;
	jOppUserInfo["language"] = userInfo.language;
	jOppUserInfo["sex"] = userInfo.sex;
	root["userInfo"] = jOppUserInfo;
	Json::FastWriter oppWriter;
	string oppStrOut = oppWriter.write(oppRoot);
	auto &opp_msg_list = syn_caches[oppUserInfo.name];
	opp_msg_list.push_back(oppStrOut);
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
	char buffer[200] = {0};
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
	write(fd, buffer, sizeof(buffer));
}

void IOManager::ack_linkmans(int fd, bool result, const vector<Clientdb::UserInfo> &linkmans){
	char buffer[1000] = {0};
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
	write(fd, buffer, sizeof(buffer));
}

void IOManager::ack_login(int fd, bool result, bool logined, const Clientdb::UserInfo &userInfo){
	char buffer[200] = {0};
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
	write(fd, buffer, sizeof(buffer));
}

void IOManager::ack_register(int fd, bool result){
	char buffer[200] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = "REGISTER";
	root["result"] = result;
	Json::FastWriter writer;
	string strOut = writer.write(root);

	strcpy(buffer, strOut.c_str());
	write(fd, buffer, sizeof(buffer));
}

void IOManager::ack_message(int fd, const string &msg){
	char buffer[100] = {0};
	Json::Value root;
	root["mtype"] = "ACK";
	root["dtype"] = msg;
	// JSON 转换为 JSON 字符串(已格式化)
	//string strOut = root.toStyledString();
	
	// JSON 转换为 JSON 字符串(未格式化)
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
