---
title:  gradle
tag: gradle
---
<!-- toc -->
#  gradle
>Gradle是一个基于Apache Ant和Apache Maven概念的项目自动化建构工具。它使用一种基于Groovy的特定领域语言(DSL)来声明项目设置，抛弃了基于XML的各种繁琐配置。
面向Java应用为主。当前其支持的语言限于Java、Groovy和Scala，计划未来将支持更多的语言。

---
title: #Gradle介绍
tag: java
---
<!-- toc -->
# #Gradle介绍
Gradle是一个基于JVM的构建工具，它提供了：
像Ant一样，通用灵活的构建工具
可以切换的，基于约定的构建框架
强大的多工程构建支持
基于Apache Ivy的强大的依赖管理
支持maven, Ivy仓库
支持传递性依赖管理，而不需要远程仓库或者是pom.xml和ivy.xml配置文件。
对Ant的任务做了很好的集成
基于Groovy，build脚本使用Groovy编写
有广泛的领域模型支持构建

##Gradle 概述
1，基于声明和基于约定的构建。
2，依赖型的编程语言。
3，可以结构化构建，易于维护和理解。
4，有高级的API允许你在构建执行的整个过程当中，对它的核心进行监视，或者是配置它的行为。
5，有良好的扩展性。有增量构建功能来克服性能瓶颈问题。
6，多项目构建的支持。
7，多种方式的依赖管理。
8，是第一个构建集成工具。集成了Ant, maven的功能。
9，易于移值。
10，脚本采用Groovy编写，易于维护。
11，通过Gradle Wrapper允许你在没有安装Gradle的机器上进行Gradle构建。
12，自由，开源。

