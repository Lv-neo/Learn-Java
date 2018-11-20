---
title:  JSP指令
tag: jsp
---
<!-- toc -->
#  JSP指令

## page指令

语法格式（其中符号“|”代表“或”，“[]”中内容为可选项，下同）：

```
<%@page
[language="java"]
[extends="package.class"]
[import="{package.class|.*},...."]
....
```

page指令用于给JSP文件的全局属性进行赋值，其赋值动作作用于整个页面。一个页面中可以包含多行page指令，但是除import属性外，其他属性只能用一次。import属性和Java中的import语句相似（参照Java语言），因此可以多次使用。page指令可以写在文件的任何位置，但是无论放在什么地方，其作用范围都是整个页面，因此建议读者最好将其写在JSP文件的头部。

### ```language="java"```

该属性用来指定编写JSP的程序语言类型，由于目前唯一可使用的就是Java语言，因此不用设置，直接使用默认值即可。

### ```extends="package.class"```
该属性用来指定JSP编译时需要继承的父类，这将为Servlet产生一个超类，它会限制JSP的编译能力。在使用此属性时需要慎重，因为，服务器也许已经定义了一个超类。

### ```import="{package.class|.*}，……"```

该属性用于定义引入程序中需要使用到的Java程序包（Package）或类（Class），这些包和类作用于程序段、表达式，以及声明。在import指令中，多个包之间用逗号隔开，如```＜%@page import="java.lang.Runtime, java.util.*"%＞```，也可以分成多个import属性分开书写。import属性是page指令中唯一一个可以在同一JSP页面中重复出现的属性。另外有些包是系统在JSP编译时默认引入的，可以不进行说明，包括```“java.lang.*”、“javax.servlet.*”、“javax.servlet.jsp.*”、“javax.servlet.http.*”```等。

### ```session="true|false"```

如果该属性取值为true（默认值），表明预定义的session变量总能被访问，它应该绑定到一个已存在的session，否则就应该创建一个并将之绑定；如果其值为false，则表示session不可以使用。这时如果试图使用于session相关的元素，就会导致JSP编译错误。

### ```buffer="none|8kb|sizekb"```
该属性为JSP Writer预定义对象，即out对象的输出确定缓冲区的大小。其默认值由服务器而定，但不少于8kB。

### ```autoFlush="true|false"```
值为true（默认值）时表示：当缓冲满时将自动清空；值为false时表示：当缓冲满时传递出一个异常（Exception），这个选项很少使用。如果把buffer值设为none时，将autoFlush值设为false是不合法的。

### ```isThreadSafe="true|false"```
值为true（默认值）时表示：将进行普通的servlet处理，多个请求将被一个Servlet实例并行处理，在这种情况下，编程人员同步访问多个实例变量；值为f a l s e时表示：S e r v l e t将实现单线程模式（SingleThreadModel），不管请求是顺序提交还是并发出现，都将提供不同的分离的Servlet实例。

### ```info="text"```
该属性定义一个可以通过调用Servlet.getServletInfo（）方法得到的字符串，该字符串包含当前JSP文件的一些相关信息，如作者、功能描述等。

### ```errorPage="relativeURL"```

该属性指定一个JSP页面，该页面用于处理任何一个可能抛出的但当前页面并未处理的异常（Exception）。

### ```contentType="mimeType[；charset=characterSet]"|"text/html；charset=ISO-8859-1"```

该属性用于指定输出的mime类型。该属性默认值为text/html，缺省字符集为“ISO-8859-1”。

### ```isErrorPage="true|false"```

指定当前页面是否可以处理来自另一个页面的错误，默认值为false。


### include指令
语法格式：
```
<%@include file="relativeURL"%>
```

说明include指令用于在将JSP文件转换成Servlet时，引入其他包含文本或代码的文件。

include指令的语法规则如下：

* 语法中的relativeURL是欲引入文件的相对路径，不需要端口、协议或域名。
* 文件路径如果以“/”开头，则主要参照JSP应用文件夹所在路径。
* 如果文件路径以文件名或目录名开头，则该路径是正在使用的JSP文件的当前路径。
* 被导入的文件可以是JSP文件、HTML文件或文本文件。
* 被导入的文件必须符合HTML或JSP语法规范。
* 如果包含的是JSP文件，则文件中的JSP代码将被执行。
* 如果包含的是静态文件，该文件将被插入到JSP文件的＜%@include%＞指令处。
* 包含文件的路径一般都是相对路径。



