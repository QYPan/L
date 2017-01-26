#include "Clientdb.h"

Clientdb::Clientdb(){
}

Clientdb::~Clientdb(){
}

bool Clientdb::init(){
	mysql_init(&client_conn);
	if(mysql_real_connect(&client_conn, "localhost", "rick", "rick", "clientdb", 0, NULL, 0)){
		printf("connect clientdb success\n");
		return true;
	}else{
		fprintf(stderr, "connect clientdb failed\n");
		if(mysql_errno(&client_conn)){
			fprintf(stderr, "connection error %d: %s\n",
					mysql_errno(&client_conn), mysql_error(&client_conn));
		}
		return false;
	}
}

bool Clientdb::tryInsertClient(const UserInfo &userInfo){
	char sql_sentence[200];
	sprintf(sql_sentence, "INSERT INTO clients(cname, password, language, sex) VALUES('%s', '%s', '%s', '%d')",
			userInfo.name.c_str(), userInfo.password.c_str(), userInfo.language.c_str(), userInfo.sex);
	int res = mysql_query(&client_conn, sql_sentence);
	if(!res){
		printf("Inserted %lu rows\n", (unsigned long)mysql_affected_rows(&client_conn));
		return true;
	}else{
		fprintf(stderr, "Insert error %d: %s\n",
				mysql_errno(&client_conn), mysql_error(&client_conn));
		return false;
	}
}
