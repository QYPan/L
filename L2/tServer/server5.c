/*  For our final example, server5.c, 
    we include the sys/time.h and sys/ioctl.h headers in place of signal.h
    in our last program and declare some extra variables to deal with select.  */

#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <stdio.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h>

fd_set readfds;
pthread_mutex_t heart_lock = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t readfds_lock = PTHREAD_MUTEX_INITIALIZER;

int heartCount[1200];
int max_fd;
int min_client_fd = 1200;

int server_sockfd, client_sockfd;

void initHeartCount(){
	for(int i = 0; i < 1200; i++){
		heartCount[i] = 0;
	}
}

void close_fd(int fd){
	close(fd);
	pthread_mutex_lock(&readfds_lock);
	FD_CLR(fd, &readfds);
	pthread_mutex_unlock(&readfds_lock);
}

void *checkHeart(void *arg){
	while(1){
		sleep(8);
		for(int fd = min_client_fd; fd <= max_fd; fd++){
			if(fd != server_sockfd && FD_ISSET(fd,&readfds)){
				if(heartCount[fd] < 1){

					pthread_mutex_lock(&heart_lock);
					heartCount[fd]++;
					pthread_mutex_unlock(&heart_lock);

				}else{
					heartCount[fd] = 0;
					close_fd(fd);
					printf("client on fd %d timeout, remove it\n", fd);
				}
			}
		}
	}
	return ((void *)0);
}

int main()
{
    int server_len, client_len;
    struct sockaddr_in server_address;
    struct sockaddr_in client_address;
    int result;

	pthread_t tid;
    fd_set testfds;

/*  Create and name a socket for the server.  */

    server_sockfd = socket(AF_INET, SOCK_STREAM, 0);
	if(server_sockfd == -1){
		perror("socket");
		exit(1);
	}

	int on = 1;
	setsockopt(server_sockfd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));

    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = htonl(INADDR_ANY);
    server_address.sin_port = htons(9734);
    server_len = sizeof(server_address);

    if(bind(server_sockfd, (struct sockaddr *)&server_address, server_len) == -1){
		perror("bind");
		exit(1);
	}

/*  Create a connection queue and initialize readfds to handle input from server_sockfd.  */

    if(listen(server_sockfd, 5) == -1){
		perror("listen");
		exit(1);
	}

    FD_ZERO(&readfds);
    FD_SET(server_sockfd, &readfds);
	max_fd = server_sockfd;

/*  Now wait for clients and requests.
    Since we have passed a null pointer as the timeout parameter, no timeout will occur.
    The program will exit and report an error if select returns a value of less than 1.  */

	initHeartCount();

	int err = pthread_create(&tid, NULL, checkHeart, NULL);
	if(err != 0){
		perror("thread");
		exit(1);
	}

    while(1) {
        int fd;
        int nread;

        testfds = readfds;

        printf("server waiting\n");
        result = select(max_fd+1, &testfds, (fd_set *)0, 
            (fd_set *)0, (struct timeval *) 0);

        if(result < 1) {
            perror("server5");
            exit(1);
        }

/*  Once we know we've got activity,
    we find which descriptor it's on by checking each in turn using FD_ISSET.  */

        for(fd = 0; fd <= max_fd; fd++) {
            if(FD_ISSET(fd,&testfds)) {

/*  If the activity is on server_sockfd, it must be a request for a new connection
    and we add the associated client_sockfd to the descriptor set.  */

                if(fd == server_sockfd) {
                    client_len = sizeof(client_address);
                    client_sockfd = accept(server_sockfd, 
                        (struct sockaddr *)&client_address, (socklen_t *)&client_len);
					pthread_mutex_lock(&readfds_lock);
                    FD_SET(client_sockfd, &readfds);
					pthread_mutex_unlock(&readfds_lock);
					if(client_sockfd > max_fd) max_fd = client_sockfd;
					if(client_sockfd < min_client_fd) min_client_fd = client_sockfd;
                    printf("adding client on fd %d\n", client_sockfd);
					pthread_mutex_lock(&heart_lock);
					heartCount[fd] = 0;
					pthread_mutex_unlock(&heart_lock);
                }

/*  If it isn't the server, it must be client activity.
    If close is received, the client has gone away and we remove it from the descriptor set.
    Otherwise, we 'serve' the client as in the previous examples.  */

                else {
                    ioctl(fd, FIONREAD, &nread);

                    if(nread == 0) {
						close_fd(fd);
                        printf("removing client on fd %d\n", fd);
                    }

                    else {
						char str[1000] = {0};
                        int count = read(fd, str, sizeof(str));

						pthread_mutex_lock(&heart_lock);
						heartCount[fd] = 0;
						pthread_mutex_unlock(&heart_lock);

						printf("count: %d\n", count);
						printf("get data from client %d: %s\n", fd, str);
                        write(fd, str, strlen(str));
                    }
                }
            }
        }
    }
}
