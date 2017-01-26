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
	bool tryInsertClient(const UserInfo &userInfo);
private:
	MYSQL client_conn;
};

#endif
