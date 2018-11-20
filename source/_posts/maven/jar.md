---
title:  将jar文件加到Maven的local repository中
tag: mvn
---
<!-- toc -->
#  将jar文件加到Maven的local repository中

http://www.cnblogs.com/davenkin/archive/2012/02/15/install-jar-into-maven-local-repository.html

对于Maven项目来说，日常使用的多数第三方java库文件都可以从Maven的Central Repository中自动下载，但是如果我们需要的jar文件不在Central Repository中，那么我们就需要手动将自己下载的jar文件加入到Maven的local reposotory中了，此时我们需要向Maven提供用于识别jar文件（可能多个）的groupId, artifactId和version等信息。


##
```
package com.neo.test;

public class HelloWorld
{
     public void sayHello()
         {
             System.out.println("Hello, World");
         }
}

```

