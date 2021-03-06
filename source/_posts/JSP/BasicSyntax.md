---
title:  JSP基本语法
tag: jsp
---
<!-- toc -->
# JSP基本语法


## 声明

```
<%! java_declaration1;[java_declaration2;....]%>
```

* 声明必须以分号结尾。
* 声明的变量和函数只在本页面有效。
* 对于被＜%@page%＞包含进来的变量和函数，不需要再次声明。
* 不但可以声明变量和函数，也可以声明完整的类。

## 表达式
```
<%=java_expression%>
```

* 表达式不能用分号作为结束符。
* 表达式的元素可以包含任何在Java规范中的有效表达式。
* 有时表达式作为其他JSP元素的属性值，这时，一个表达式可以嵌套多个表达式。

## 脚本

```
<%java_scriptlet%>
```

* 该程序段中只能包含符合Java语法的代码，不允许出现任何HTML标记、JSP标记和JSP指令元素。
* 在脚本中也可以对变量进行声明。
* 脚本中也可以包含表达式，但是必须是用分号作为其结束符。


## 注释

```
<%--注释--%>
```

* 注释在系统进行编译时将被忽略。
* 在浏览器端查看源文件时，看不到使用JSP注释标记的语句，而使用HTML注释标记（＜！--注释--＞）的语句是可以看到的。
* 脚本程序段中的注释方法与Java语法相同。

## 指令

```
<%@指令属性="值"%>
```

## 动作

```
<jsp:动作名动作内容></jsp:动作名>或<jsp:动作名动作内容/>
```

