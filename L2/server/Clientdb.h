#ifndef CLIENTDB_H
#define CLIENTDB_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <vector>
#include <json/json.h>
#include "mysql.h"
using namespace std;

class Clientdb{
public:
	struct UserInfo {
		UserInfo()
			: name("")
			, password("")
			, language("")
			, sex(-1)
		{}
		string name;
		string password;
		string language;
		int sex;
	};
	Clientdb();
	~Clientdb();
	bool init();
	bool insertClient(const UserInfo &userInfo);
	bool removeClient(const string &name);
	bool insertFriend(const string &cname, const string &fname);
	bool removeFriend(const string &cname, const string &fname);
	bool getFriends(const string &name, vector<UserInfo> &linkmans);
	bool findClient(const string &name, UserInfo &userInfo);
	bool findFriend(const string &name, const string &fname);
private:
	void appendFriend(MYSQL_ROW &sqlrow, vector<UserInfo> &linkmans);
	void setClient(MYSQL_ROW &sqlrow, UserInfo &userInfo);
	MYSQL client_conn;
};

#endif
