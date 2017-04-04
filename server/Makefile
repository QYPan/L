obj = main.o Server.o TcpServer.o OnlineManager.o IOManager.o Clientdb.o
link = -lpthread -ljson -I/usr/include/mysql -L/usr/lib64/mysql -lmysqlclient -g

server : $(obj)
	g++ -o server $(obj) $(link)
Server.o : Server.cpp Server.h TcpServer.h OnlineManager.h IOManager.h
	g++ -c -std=c++11 -Wall Server.cpp $(link)
TcpServer.o : TcpServer.h TcpServer.cpp
	g++ -c -std=c++11 -Wall TcpServer.cpp $(link)
Clientdb.o : Clientdb.h Clientdb.cpp
	g++ -c -std=c++11 -Wall Clientdb.cpp $(link)
IOManager.o : Clientdb.h IOManager.h IOManager.cpp
	g++ -c -std=c++11 -Wall IOManager.cpp $(link)
OnlineManager.o : OnlineManager.h OnlineManager.cpp
	g++ -c -std=c++11 -Wall OnlineManager.cpp $(link)
main.o : Server.h main.cpp
	g++ -c -std=c++11 -Wall main.cpp $(link)
.PHONY : clean
clean :
	rm server $(obj)
