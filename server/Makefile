obj = main.o server.o clientdb.o
dblink = -I/usr/include/mysql -L/usr/lib/mysql -lmysqlclient

server : $(obj)
	g++ -o server $(obj) $(dblink) -g
server.o : server.cpp server.h
	g++ -c -std=c++11 -Wall server.cpp $(dblink) -g
clientdb.o : clientdb.cpp clientdb.h
	g++ -c -std=c++11 -Wall clientdb.cpp $(dblink) -g
main.o : main.cpp server.h clientdb.h
	g++ -c -std=c++11 -Wall main.cpp $(dblink) -g
.PHONY : clean
clean :
	rm server $(obj)
