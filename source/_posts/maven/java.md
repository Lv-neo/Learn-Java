# 使用Maven创建java项目

###从 Maven 模板创建一个项目
在终端（* UNIX或Mac）或命令提示符（Windows）中，浏览到要创建 Java 项目的文件夹。键入以下命令：

```
mvn archetype:generate -DgroupId={project-packaging} -DartifactId={project-name}-DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

这告诉 Maven 来从 maven-archetype-quickstart 模板创建 Java 项目。如果忽视 archetypeArtifactId 选项，一个巨大的 Maven 模板列表将列出。

在上述情况下，一个新的Java项目命名 “NumberGenerator”, 而整个项目的目录结构会自动创建。

>有少数用户说 mvn archetype:generate 命令未能生成项目结构。 如果您有任何类似的问题，不用担心，只需跳过此步骤，手动创建文件夹，请参阅步骤2的项目结构

###Maven目录布局

```
NumberGenerator
   |-src
   |---main
   |-----java
   |-------com
   |---------yiibai   
   |-----------App.java
   |---test|-----java
   |-------com
   |---------yiibai
   |-----------AppTest.java
   |-pom.xml
```

很简单的，所有的源代码放在文件夹 /src/main/java/, 所有的单元测试代码放入 /src/test/java/.

注意，请阅读 [Maven标准目录布局](http://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html)
附加的一个标准的 pom.xml 被生成。这个POM文件类似于 Ant build.xml 文件，它描述了整个项目的信息，一切从目录结构，项目的插件，项目依赖，如何构建这个项目等，请阅读[POM官方指南] (http://maven.apache.org/guides/introduction/introduction-to-the-pom.html)

附录
http://www.yiibai.com/maven/create-a-java-project-with-maven.html


