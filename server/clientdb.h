#ifndef CLIENTDB_H
#define CLIENTDB_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "mysql.h"

class Clientdb {
public:
	Clientdb();
	bool init();
	bool tryInsertClient(const char *name, const char *password, int language);
	bool tryInsertFriend(const char *name, const char *friendName, int language);
	bool checkClient(const char *name, const char *password, char *language);
	void getFriends(const char *name, char *friends);
private:
	bool checkData(MYSQL_ROW &sqlrow, const char *password, char *language);
	void mergeFriends(MYSQL_ROW &sqlrow, char *friends);
	MYSQL client_conn;
	bool isFirstFriend;
};


#endif
