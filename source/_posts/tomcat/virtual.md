---
title:  Tomcat服务器虚拟目录的映射方式
tag: tomcat
---
<!-- toc -->
#  Tomcat服务器虚拟目录的映射方式

>Web应用开发好后，若想供外界访问，需要把web应用所在目录交给web服务器管理，这个过程称之为虚似目录的映射。那么在Tomcat服务器中，如何进行虚拟目录的映射呢？总共有如下的几种方式：

## 虚拟目录的映射方式一：在server.xml文件的host元素中配置(不推荐)

```xml
 <Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">

        <!-- SingleSignOn valve, share authentication between web applications
             Documentation at: /docs/config/valve.html -->
        <!--
        <Valve className="org.apache.catalina.authenticator.SingleSignOn" />
        -->

        <!-- Access log processes all example.
             Documentation at: /docs/config/valve.html
             Note: The pattern used is equivalent to using pattern="common" -->
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log" suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />

      </Host>
```

在```<Host></Host>```这对标签加上<Context path="/test" docBase="/vagrant/java/web/test" />即/vagrant/java/web/test这个JavaWeb应用映射到test这个虚拟目录上，test这个虚拟目录是由Tomcat服务器管理的，test是一个硬盘上不存在的目录，是我们自己随便写的一个目录，也就是虚拟的一个目录，所以称之为"虚拟目录"，代码如下：
　

```xml
<Host name="localhost"  appBase="webapps"
              unpackWARs="true" autoDeploy="true"
              xmlValidation="false" xmlNamespaceAware="false">
 
<Context path="/test" docBase="/vagrant/java/web/test" />
 </Host>
```

其中，Context表示上下文，代表的就是一个JavaWeb应用，Context元素有两个属性，

* path：用来配置虚似目录，必须以"/"开头。

* docBase：配置此虚似目录对应着硬盘上的Web应用所在目录。

　使用浏览器访问"/test"这个虚拟目录下的1.jsp这个web资源，访问结果如下：


　　1.jsp可以正常访问，这说明我们已经成功地将将在F盘下的JavaWebDemoProject这个JavaWeb应用映射到JavaWebApp这个虚拟目录上了，访问"/JavaWebApp/1.jsp"就相当于访问"F:\JavaWebDemoProject\1.jsp"

>注意：在Tomcat6之后中，不再建议在server.xml文件中使用配置context元素的方式来添加虚拟目录的映射，因为每次修改server.xml文件后，Tomcat服务器就必须要重新启动后才能重新加载server.xml文件。在Tomcat服务器的文档http://localhost:8080/docs/config/context.html 中有这样的说明：

　　It is NOT recommended to place <Context> elements directly in the server.xml file. This is because it makes modifying the Context configuration more invasive since the main conf/server.xml file cannot be reloaded without restarting Tomcat.

Individual Context elements may be explicitly defined:

In an individual file at /META-INF/context.xml inside the application files. Optionally (based on the Host's copyXML attribute) this may be copied to $CATALINA_BASE/conf/[enginename]/[hostname]/ and renamed to application's base file name plus a ".xml" extension.
In individual files (with a ".xml" extension) in the $CATALINA_BASE/conf/[enginename]/[hostname]/ directory. The context path and version will be derived from the base name of the file (the file name less the .xml extension). This file will always take precedence over any context.xml file packaged in the web application's META-INF directory.
Inside a Host element in the main conf/server.xml.

## 虚拟目录的映射方式二：让tomcat服务器自动映射




