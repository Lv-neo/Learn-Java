# Gradle 安装

1，安装JDK，并配置JAVA_HOME环境变量。因为Gradle是用Groovy编写的，而Groovy基于JAVA。另外，Java版本要不小于1.5.
2，下载。地址是：http://www.gradle.org/downloads。在这里下载你要的版本。
3，解压。如果你下载的是gradle-xx-all.zip的完整包，它会有以下内容：
* 二进制文件
* 用户手册（包括PDF和HTML两种版本）
* DSL参考指南
* API手册（包括Javadoc和Groovydoc）
* 样例
* 源代码，仅供参考使用。
4，配置环境变量。配置GRADLE_HOME到你的gradle根目录当中，然后把%GRADLE_HOME%/bin（linux或mac的是$GRADLE_HOME/bin）加到PATH的环境变量。
linux用户可以在~/.bashrc文件中配置。

配置完成之后，运行gradle -v，检查一下是否安装无误。如果安装正确，它会打印出Gradle的版本信息，包括它的构建信息，Groovy, Ant, Ivy, 当前JVM和当前系统的版本信息。

另外，可以通过GRADLE_OPTS或JAVA_OPTS来配置Gradle运行时的JVM参数。不过，JAVA_OPTS设置的参数也会影响到其他的JAVA应用程序。

