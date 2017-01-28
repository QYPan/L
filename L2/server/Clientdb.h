#ifndef CLIENTDB_H
#define CLIENTDB_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include "mysql.h"
using namespace std;

class Clientdb{
public:
	struct UserInfo {
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
	bool findClient(const string &name, UserInfo &userInfo);
private:
	void setClient(MYSQL_ROW &sqlrow, UserInfo &userInfo);
	MYSQL client_conn;
};

#endif
