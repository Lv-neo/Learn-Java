# maven安装说明
* 访问 [Maven官方网站](http://maven.apache.org/download.cgi)，打开后找到下载链接

* 下载maven安装包

* 解压
```
unzip apache-maven-3.3.9-bin.zip
```
or
```
tar xzvf apache-maven-3.3.9-bin.tar.gz
```

* 设置MAVEN_HOME
```
vim /etc/profile
export JAVA_HOME=/usr/local/jdk1.8.0_77
export MAVEN_HOME=/usr/local/maven
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
```

* 输入mvn -version 

```
Apache Maven 3.3.9 (bb52d8502b132ec0a5a3f4c09453c07478323dc5; 2015-11-11T00:41:47+08:00)
Maven home: /usr/local/bin/maven
Java version: 1.8.0_92, vendor: Oracle Corporation
Java home: /Library/Java/JavaVirtualMachines/jdk1.8.0_92.jdk/Contents/Home/jre
Default locale: zh_CN, platform encoding: UTF-8
OS name: "mac os x", version: "10.11.5", arch: "x86_64", family: "mac"
```

安装完毕

