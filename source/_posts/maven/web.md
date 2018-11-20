# 使用Maven创建Web应用程序项目

###从Maven模板创建Web项目

您可以通过使用Maven的maven-archetype-webapp模板来创建一个快速启动Java Web应用程序的项目。在终端(* UNIX或Mac)或命令提示符(Windows)中，导航至您想要创建项目的文件夹。

```
$ mvn archetype:generate -DgroupId=com.yiibai -DartifactId=CounterWebApp -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false
```

新的Web项目命名为 “CounterWebApp”，以及一些标准的 web 目录结构也会自动创建。

###项目目录布局
查看生成的项目结构布局：

```
.|____CounterWebApp
||____pom.xml
||____src
|||____main
||||____resources
||||____webapp
|||||____index.jsp
|||||____WEB-INF
||||||____web.xml
```

Maven 产生了一些文件夹，一个部署描述符 web.xml，pom.xml 和 index.jsp。

注意，
请查看[官方Maven标准目录布局指南](http://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html)来了解更多。

```
<project xmlns="http://maven.apache.org/POM/4.0.0" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
	http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.yiibai</groupId>
  <artifactId>CounterWebApp</artifactId>
  <packaging>war</packaging>
  <version>1.0-SNAPSHOT</version>
  <name>CounterWebApp Maven Webapp</name>
  <url>http://maven.apache.org</url>
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <build>
    <finalName>CounterWebApp</finalName>
  </build>
</project>
```

附录
http://www.yiibai.com/maven/create-a-web-application-project-with-maven.html


