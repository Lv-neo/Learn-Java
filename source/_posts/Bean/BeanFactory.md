---
title:  BeanFactory介绍
tag: java bean
---
<!-- toc -->
#  BeanFactory介绍
正如其名字所暗示的，Bean工厂采用了工厂设计模式。就是说，这个类负责创建和分发Bean。但是，不像其他工厂模式的实现，它们只是分发一种类型的对象，而Bean工厂是一个通用的工厂，可以创建和分发各种类型的Bean。

但是，除了简单的实例化和分发应用对象以外，Bean工厂还有很多工作需要做。由于Bean工厂知道应用系统中的很多对象，所以它可以在实例化这些对象的时候，创建协作对象间的关联关系。这样就把配置的负担从Bean自身以及Bean的调用者中脱离出来。结果，Bean工厂分发出来的Bean都已经被配置好了，都得到了它们的关联对象，已经可以被使用了。Bean工厂还要参与到Bean的生命周期中，调用用户定义的初始化和销毁方法（如果定义了这些方法的话）。

在Spring中有几种BeanFactory的实现。其中最常使用的是org.springframework.beans.factory.xml.XmlBeanFactory，它根据XML文件中的定义装载Bean。


