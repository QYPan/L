obj = main.o Server.o TcpServer.o OnlineManager.o

server : $(obj)
	g++ -o server $(obj) -g
Server.o : Server.cpp Server.h TcpServer.h OnlineManager.h
	g++ -c -std=c++11 -Wall Server.cpp -g
TcpServer.o : TcpServer.h TcpServer.cpp
	g++ -c -std=c++11 -Wall TcpServer.cpp -g
OnlineManager.o : OnlineManager.h OnlineManager.cpp
	g++ -c -std=c++11 -Wall OnlineManager.cpp -g
main.o : Server.h main.cpp
	g++ -c -std=c++11 -Wall main.cpp -g
.PHONY : clean
clean :
	rm server $(obj)
