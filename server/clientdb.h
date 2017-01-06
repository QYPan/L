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
	bool tryInsertFriend(const char *name, const char *friendName);
	bool checkClient(const char *name, const char *password, char *language);
private:
	bool checkData(MYSQL_ROW &sqlrow, const char *password, char *language);
	MYSQL client_conn;
};


#endif
