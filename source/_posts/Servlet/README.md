---
title:  Servlet概述
tag: servlet
---
<!-- toc -->
#  Servlet概述

Servlet是一种独立于平台和协议的服务器端的Java应用程序，可以生成动态的Web页面。它是位于Web服务器内部由服务器端调用和执行的Java类，与传统的从命令行启动的Java应用程序不同，Servlet由Web服务器进行加载，该Web服务器必须包含支持Servlet的Java虚拟机。

Servlet相当于在服务器端运行的Applet，但是它与Applet也有区别，由于Servlet运行在服务器端，因此它是可信赖的程序，不受Java安全性限制，拥有和普通Java应用程序一样的权限。

## Servlet的特点

* 高效：在服务器上仅有一个Java虚拟机在运行，只有当Servlet被调用时，它才被加载。一旦Servlet被加载，在它被更改之前都不需要重新加载，同时，在Servlet被更改后再次加载时，不需要重新启动服务器。Servlet最主要的优势是，当Servlet被客户端的请求激活后，它将继续运行于后台，等待以后的请求，每个请求都只会生成一个新的线程，而不是一个完整的进程。
* 可移植性强：由于Servlet是用Java编写的，所以具有跨平台性，Servlet API（Application Programming Interface应用程序接口）具有完善的标准，因此Servlet不需要任何修改就可以在几乎所有的主流服务器上运行。
* 灵活：Servlet提供了大量的实用工具例程，并且可以和HTML页面、JSP页面、Applet以及Java Bean进行交流。例如，可以从客户发来的HTML表单中读取数据，并将这些数据保存在服务器中。也可以将Servlet的运行结果送到JSP中或从Java Bean获取运行结果，还可以读取和设置HTTP头、处理Cookie、跟踪会话状态等。
* 功能强大：Servlet能够直接和Web服务器交互，还能够在各个程序之间共享数据，使数据库链接功能很容易实现。
* 投资小：不仅有许多廉价甚至免费的Web服务器可供个人或小规模网站使用，而且对于现有的服务器，即使不支持Servlet但要加上这部分功能也是免费的。

## Servlet的应用范围
Servlet的主要功能在于交互式的浏览和修改数据，生成动态Web内容，具有广泛的应用范围。具体如下：

* 可以处理HTTP请求，并将HTTP响应反馈给客户端。
* 可以用于处理HTTP表单通过HTTP协议产生的POST/GET数据，如买卖订单、信用卡数据等。
* 可以同时处理多个请求。
* 可以将请求转送给其他服务器和Servlet，按照任务类型或组织范围，允许在几个服务器中划分逻辑上的服务器。

## Servlet与JSP的关系

在JSP之前，Sun公司最先推出的是Servlet，用于替代功能有限的CGI技术，从某种程度上可以认为Servlet是JSP的前身。Servlet在编写HTML文本时，采用print或println方法逐句打印，这给编程人员带来了很大不便，限制了Servlet的应用。为了适应网络编程的需要，Sun又在Servlet的基础上推出了JSP技术。JSP技术从根本上改变了Servlet的编程方法，该技术通过HTML（或XML）与Java代码的结合，并在其中加入JSP标记来实现JSP文件的编写。在第17章中我们已经详细地介绍了这种技术。

推出JSP及Java Bean的初衷就是要取代Servlet，但是学习Servlet还是非常有必要的。当运行某个JSP页面时，这个页面首先会被服务器编译成一个Servlet然后才被执行。这一过程是由Servlet引擎自动完成的，而不需要编程人员介入，因此极大地提高了程序编写的效率。但是相对于直接应用Servlet来说，这样会降低响应的速度。而且现有的程序中还有不少是使用Servlet编写的，因此程序编写人员还必须能够读懂这些程序。



