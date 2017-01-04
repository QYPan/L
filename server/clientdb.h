#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "mysql.h"

class Clientdb {
public:
	Clientdb();
	bool init();
	bool tryInsert(const char *name, const char *password, int language);
	bool checkClient(const char *name, const char *password);
private:
	bool checkData(MYSQL_ROW &sqlrow, const char *password);
	MYSQL client_conn;
};
