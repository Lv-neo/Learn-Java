---
title:  使用maven profile实现多环境可移植构建
tag: mvn
---
<!-- toc -->
#  使用maven profile实现多环境可移植构建

## 配置profile
首先是profile配置，在pom.xml中添加如下profile的配置：
```
<profiles>     <profile>         <!-- 本地开发环境 -->         <id>dev</id>         <properties>             <profiles.active>dev</profiles.active>         </properties>         <activation>             <activeByDefault>true</activeByDefault>         </activation>     </profile>     <profile>         <!-- 测试环境 -->         <id>test</id>         <properties>             <profiles.active>test</profiles.active>         </properties>     </profile>     <profile>         <!-- 生产环境 -->         <id>pro</id>         <properties>             <profiles.active>pro</profiles.active>         </properties>     </profile> </profiles>
``` 
 
这里定义了三个环境，分别是dev（开发环境）、test（测试环境）、pro（生产环境），其中开发环境是默认激活的（activeByDefault为true），这样如果在不指定profile时默认是开发环境。
同时每个profile还定义了两个属性，其中profiles.active表示被激活的profile的名称
 
## 配置文件
针对不同的环境，我们定义不同的配置文件，而这些配置文件都做为资源文件放到maven工程的resources目录下，即src/main/resources目录下，且各个环境的配置分别放到相应的目录下，而所有环境都公用的配置，直接放到src/main/resources目录下即可。如下图所示：


如图所示，开发环境、测试环境、生产环境的配置文件分别放到src/main/resources目录下的dev、test、pro三个子目录中，而所有环境都公用的配置文件直接放到src/main/resources目录下。
 
## maven资源插件配置
在pom中的build节点下，配置资源文件的位置，如下所示：

```
src/main/resources/
├── dev
│   ├── hibernate.cfg.xml
│   ├── log4j.properties
│   └── redis.properties
├── pro
│   ├── hibernate.cfg.xml
│   ├── log4j.properties
│   └── redis.properties
├── test
│   ├── hibernate.cfg.xml
│   ├── log4j.properties
│   └── redis.properties
```
 
## 配置resources
```
<build>     <resources>         <resource>             <directory>src/main/resources</directory>             <!-- 资源根目录排除各环境的配置，使用单独的资源目录来指定 -->             <excludes>                 <exclude>test/*</exclude>                 <exclude>dev/*</exclude>                 <exclude>pro/*</exclude>             </excludes>         </resource>         <resource>             <directory>src/main/resources/${profiles.active}</directory>         </resource
...
```
 
## 构建或发布
所有需要的配置就完成了，下面是见证奇迹的时候了。通过在运行maven命令时指定不同的profile即可构建不同环境需要的war包或发布到不同的环境了 。如：
```
mvn clean package -Pprod 即构建出生产环境需要的war包
mvn tomcat:redeploy -Ptest 即发布到测试环境
```
由于默认的profile是dev，所以如果我们不指定profile，那么加载就是开发环境deployment下的配置文件了。即我们在本地开发测试时，不用关心profile的问题。
而且本地开发时在eclipse中使用tomcat插件来进行热部署时也不需要额外的配置。真正的做到了根据不同环境来自动切换，即可移植的构建。
 另外，在进行持续集成时，使用hudson集成maven同样是非常非常方便的。


