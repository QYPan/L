#include "clientdb.h"

Clientdb::Clientdb(){
}

bool Clientdb::init(){
	mysql_init(&client_conn);
	if(mysql_real_connect(&client_conn, "localhost", "rick", "rick", "clientdb", 0, NULL, 0)){
		printf("connect clientdb success\n");
		return true;
	}else{
		fprintf(stderr, "connect clientdb failed\n");
		if(mysql_errno(&client_conn)){
			fprintf(stderr, "connection error %d: %s\n", mysql_errno(&client_conn), mysql_error(&client_conn));
		}
		return false;
	}
}

bool Clientdb::tryInsertFriend(const char *name, const char *friendName, int language){
	char sql_sentence[200];
	sprintf(sql_sentence, "INSERT INTO friends(cname, fname, language) VALUES('%s', '%s', %d)", name, friendName, language);
	printf("try %s\n", sql_sentence);
	int res = mysql_query(&client_conn, sql_sentence);
	if(!res){
		printf("Inserted %lu rows\n", (unsigned long)mysql_affected_rows(&client_conn));
		return true;
	}else{
		fprintf(stderr, "Insert err %d: %s\n", mysql_errno(&client_conn),
											mysql_error(&client_conn));
		return false;
	}
}

bool Clientdb::tryInsertClient(const char *name, const char *password, int language){
	char sql_sentence[200];
	sprintf(sql_sentence, "INSERT INTO clients(cname, password, language) VALUES('%s', '%s', %d)", name, password, language);
	printf("try %s\n", sql_sentence);
	int res = mysql_query(&client_conn, sql_sentence);
	if(!res){
		printf("Inserted %lu rows\n", (unsigned long)mysql_affected_rows(&client_conn));
		return true;
	}else{
		fprintf(stderr, "Insert err %d: %s\n", mysql_errno(&client_conn),
											mysql_error(&client_conn));
		return false;
	}
}

bool Clientdb::checkClient(const char *name, const char *password, char *language){
	MYSQL_RES *res_ptr;
	MYSQL_ROW sqlrow;
	char sql_sentence[200];
	sprintf(sql_sentence, "SELECT password, language FROM clients WHERE cname = '%s'", name);
	int res = mysql_query(&client_conn, sql_sentence);
	if(res){
		printf("SELECT error: %s\n", mysql_error(&client_conn));
		return false;
	}else{
		res_ptr = mysql_use_result(&client_conn);
		if(res_ptr){
			bool ok = false;
			printf("out\n");
			while((sqlrow = mysql_fetch_row(res_ptr))){ // 其实这里只有一条或没有记录
				ok = checkData(sqlrow, password, language);
				if(!ok) break;
			}
			if(mysql_errno(&client_conn)){
				printf("Retrive error: %s\n", mysql_error(&client_conn));
			}
			mysql_free_result(res_ptr);
			return ok;
		}
	}
	return false;
}

bool Clientdb::checkData(MYSQL_ROW &sqlrow, const char *password, char *language){
	unsigned int field_count = 0;
	while(field_count < mysql_field_count(&client_conn)){ // 提取列
		if(field_count == 0){ // 密码列
			if(password != NULL){ // 需要核对密码
				printf("%s compare with %s\n", sqlrow[field_count], password);
				if(strcmp(sqlrow[field_count], password))
					return false;
			}
		}else if(field_count == 1){ // 语言列
			if(language != NULL){
				printf("int check: %s\n", sqlrow[field_count]);
				strcpy(language, sqlrow[field_count]);
			}
		}
		field_count++;
	}
	return true;
}

void Clientdb::getFriends(const char *name, char *friends){
	if(friends == NULL)
		return;
	MYSQL_RES *res_ptr;
	MYSQL_ROW sqlrow;
	char sql_sentence[200];
	sprintf(sql_sentence, "SELECT fname, language FROM friends WHERE cname = '%s'", name);
	int res = mysql_query(&client_conn, sql_sentence);
	if(res){
		printf("SELECT error: %s\n", mysql_error(&client_conn));
		return;
	}else{
		isFirstFriend = true;
		res_ptr = mysql_use_result(&client_conn);
		if(res_ptr){
			while((sqlrow = mysql_fetch_row(res_ptr))){
				mergeFriends(sqlrow, friends);
			}
			if(mysql_errno(&client_conn)){
				printf("Retrive error: %s\n", mysql_error(&client_conn));
			}
			mysql_free_result(res_ptr);
			return;
		}
	}
	return;
}

void Clientdb::mergeFriends(MYSQL_ROW &sqlrow, char *friends){
	if(friends == NULL)
		return;
	unsigned int field_count = 0;
	if(isFirstFriend){
		isFirstFriend = false;
	}else{
		strcat(friends, "#");
	}
	while(field_count < mysql_field_count(&client_conn)){ // 提取列
		strcat(friends, sqlrow[field_count]);
		field_count++;
		if(field_count < mysql_field_count(&client_conn)){
			strcat(friends, ":");
		}
	}
}
