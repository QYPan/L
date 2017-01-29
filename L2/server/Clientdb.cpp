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

bool Clientdb::insertClient(const UserInfo &userInfo){
	char sql_sentence[200];
	sprintf(sql_sentence, "INSERT INTO clients(cname, password, language, sex) VALUES('%s', '%s', '%s', '%d')",
			userInfo.name.c_str(), userInfo.password.c_str(), userInfo.language.c_str(), userInfo.sex);
	int res = mysql_query(&client_conn, sql_sentence);
	if(!res){
		printf("Inserted %lu rows in clients table\n", (unsigned long)mysql_affected_rows(&client_conn));
		int fres = insertFriend(userInfo.name, userInfo.name); // 把自己添加进好友关系表
		if(fres){
			return true;
		}else{
			removeClient(userInfo.name);
			return false;
		}
	}else{
		fprintf(stderr, "Insert error in clients table %d: %s\n",
				mysql_errno(&client_conn), mysql_error(&client_conn));
		return false;
	}
}

bool Clientdb::removeClient(const string &name){
	char sql_sentence[200];
	sprintf(sql_sentence, "DELETE FROM clients WHERE cname = '%s'", name.c_str());
	int res = mysql_query(&client_conn, sql_sentence);
	if(!res){
		printf("Removed %lu rows in clients table\n", (unsigned long)mysql_affected_rows(&client_conn));
		return true;
	}else{
		fprintf(stderr, "Remove error in clients table %d: %s\n",
				mysql_errno(&client_conn), mysql_error(&client_conn));
		return false;
	}
}

bool Clientdb::insertFriend(const string &cname, const string &fname){
	char sql_sentence[200];
	sprintf(sql_sentence, "INSERT INTO friends(cname, fname) VALUES('%s', '%s')",
			cname.c_str(), fname.c_str());
	int res = mysql_query(&client_conn, sql_sentence);
	if(!res){
		printf("Inserted %lu rows in friends table\n", (unsigned long)mysql_affected_rows(&client_conn));
		return true;
	}else{
		fprintf(stderr, "Insert error in friends table %d: %s\n",
				mysql_errno(&client_conn), mysql_error(&client_conn));
		return false;
	}
}

bool Clientdb::removeFriend(const string &name, const string &fname){
	char sql_sentence[200];
	sprintf(sql_sentence, "DELETE FROM friends WHERE cname = '%s' && fname = '%s'",
			name.c_str(), fname.c_str());
	int res = mysql_query(&client_conn, sql_sentence);
	if(!res){
		printf("Removed %lu rows in friends table\n", (unsigned long)mysql_affected_rows(&client_conn));
		return true;
	}else{
		fprintf(stderr, "Remove error in friendss table %d: %s\n",
				mysql_errno(&client_conn), mysql_error(&client_conn));
		return false;
	}
}

bool Clientdb::getFriends(const string &name, vector<UserInfo> &linkmans){
	MYSQL_RES *res_ptr;
	MYSQL_ROW sqlrow;
	char sql_sentence[200];
	sprintf(sql_sentence, "SELECT cname, language, sex FROM clients WHERE cname IN \
			(SELECT fname FROM friends WHERE cname = '%s')", name.c_str());
	int res = mysql_query(&client_conn, sql_sentence);
	if(res){
		printf("SELECT error in frineds table: %s\n", mysql_error(&client_conn));
		return false;
	}else{
		bool ok = false;
		res_ptr = mysql_use_result(&client_conn);
		if(res_ptr){
			while((sqlrow = mysql_fetch_row(res_ptr))){
				appendFriend(sqlrow, linkmans);
				ok = true;
			}
			if(mysql_errno(&client_conn)){
				printf("Retrive error in clients table: %s\n", mysql_error(&client_conn));
			}
			mysql_free_result(res_ptr);
		}
		return ok;
	}
}

void Clientdb::appendFriend(MYSQL_ROW &sqlrow, vector<UserInfo> &linkmans){
	unsigned int field_count = 0;
	UserInfo userInfo;
	while(field_count < mysql_field_count(&client_conn)){ // 提取列
		switch(field_count){
			case 0: // cname
				userInfo.name = string(sqlrow[field_count]);
				break;
			case 1: // language
				userInfo.language = string(sqlrow[field_count]);
				break;
			case 2: // sex
				sscanf(sqlrow[field_count], "%d", &userInfo.sex);
				break;
		}
		field_count++;
	}
	linkmans.push_back(userInfo);
}

bool Clientdb::findClient(const string &name, UserInfo &userInfo){
	MYSQL_RES *res_ptr;
	MYSQL_ROW sqlrow;
	char sql_sentence[200];
	sprintf(sql_sentence, "SELECT * FROM clients WHERE cname = '%s'", name.c_str());
	int res = mysql_query(&client_conn, sql_sentence);
	if(res){
		printf("SELECT error in clients table: %s\n", mysql_error(&client_conn));
		return false;
	}else{
		res_ptr = mysql_use_result(&client_conn);
		if(res_ptr){
			bool ok =false;
			sqlrow = mysql_fetch_row(res_ptr);
			if(sqlrow){ // 该用户存在
				setClient(sqlrow, userInfo);
				ok = true;
			}
			if(mysql_errno(&client_conn)){
				printf("Retrive error in clients table: %s\n", mysql_error(&client_conn));
			}
			mysql_free_result(res_ptr);
			if(ok)
				printf("has client %s\n", name.c_str());
			else
				printf("do not has client %s\n", name.c_str());
			return ok;
		}else{
			return false;
		}
	}
}

void Clientdb::setClient(MYSQL_ROW &sqlrow, UserInfo &userInfo){
	unsigned int field_count = 0;
	while(field_count < mysql_field_count(&client_conn)){ // 提取列
		switch(field_count){
			case 0: // cname
				userInfo.name = string(sqlrow[field_count]);
				break;
			case 1: // password
				userInfo.password = string(sqlrow[field_count]);
				break;
			case 2: // language
				userInfo.language = string(sqlrow[field_count]);
				break;
			case 3: // sex
				sscanf(sqlrow[field_count], "%d", &(userInfo.sex));
				break;
		}
		field_count++;
	}
}

