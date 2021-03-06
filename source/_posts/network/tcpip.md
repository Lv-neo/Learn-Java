---
title:  TCP／IP协议
tag: network
---
<!-- toc -->
#  TCP／IP协议

---
title: # IP协议和IP地址
tag: java
---
<!-- toc -->
# # IP协议和IP地址

计算机网络中的每台运行了IP协议的主机，都具有一个IP地址，该地址标识网络中的一台主机。IP地址采用点分十进制方法表示。如192.168.2.1，IP地址是一个32位的二进制序列，点分的每个部分占一个字节，使用十进制表达。显然每个部分最大不超过255，因为二进制的8个1（11111111）用十进制表达就是255。

IP地址由网络部分和主机部分构成，网络部分表示一个通信子网，子网内的主机可以不通过路由器而直接通信，如一个公司办公室的局域网；主机部分标识该通信子网内的主机。

为了区分I P地址的网络部分和主机部分，给出掩码的概念，掩码也用点分十进制表达，如255.255.255.0，不过掩码的前面部分是二进制的1，而后面部分都是二进制的0，这一点与IP地址稍有不同，并且还可以用IP地址后加一个“/”跟上掩码的全部1的数量表达掩码，如掩码255.255.255.0也可以表达为“/24”。通过主机的IP地址和网络掩码就可以计算该主机所在的网络，如主机的IP地址为192.168.2.155/24，则网络地址的计算方式是把网络掩码同IP地址进行二进制与运算。则上述主机的网络号为192.168.2.0。网络号标识一个网络，而主机号标识一个主机。

## TCP协议和端口

TCP协议实现可靠通信的基础是采用“握手”机制实现了数据的同步传输，即在通信的双方发送数据前首先建立连接，协商一些参数，如发送的数据字节数量、缓冲区大小等。首先连接建立再传送数据，并且对于收到的每一个分组进行确认，这样就很好地保证了数据的可靠传输。

一个主机可以和服务器上的多个进程保持TCP链接，如主机1访问服务器的Web服务，同时又使用FTP服务下载视频文件（服务器提供Web和FTP两种服务），这样主机1和服务器建立了两个连接。这里对连接的标识显得很重要，因为主机1上的进程需要知道和服务器上的哪个服务进程建立TCP连接。TCP协议提供了端口号的概念，每个端口号对应一个应用进程，如端口号80代表HTTP连接，端口号21代表FTP连接服务。这样TCP协议软件可以通过端口号识别不同的进程。

端口号的设置有一定的限制，最大数是65535，在1024之前是知名（well-known）端口号，是全世界统一的，如FTP服务进程的端口号是25，HTTP服务进程的端口号是80等。而1024～65535之间由用户自己选择使用。


