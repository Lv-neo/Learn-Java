---
title:  mybaits 连接超时配置
tag: mybatis
---
<!-- toc -->
#  mybaits 连接超时配置

## mybaits 常用配置

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    <settings>
        <!-- 这个配置使全局的映射器启用或禁用缓存 -->
        <setting name="cacheEnabled" value="true"/>
        <!-- 设置超时时间，它决定驱动等待一个数据库响应的时间 -->
        <setting name="defaultStatementTimeout" value="10"/>
        <setting name="logPrefix" value="dao."/>
    </settings>
    <typeAliases>
        <typeAlias alias="AccountAddress" type="com.test.AccountAddress"></typeAlias>
    </typeAliases>
    <environments default="development">
        <environment id="development">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="com.mysql.jdbc.Driver"/>
                <property name="url" value="jdbc:mysql://127.0.0.1:3306/account" />
                <property name="username" value="test"/>
                <property name="password" value="test"/>
            </dataSource>
        </environment>
    </environments>

    <!-- mybatis的mapper文件，每个xml配置文件对应一个接口 -->
    <mappers>
        <mapper resource="mybaits/mapper/AccountAddressMapper.xml"/>
    </mappers>
</configuration>
```

## 超时配置

```
<property name="poolPingEnabled" value="true"/>
<property name="poolPingQuery" value="select 10000 as salary"/>
<property name="poolPingConnectionsNotUsedFor" value="14400000"/>
```

* poolPingEnabled
是否开启连接状态检测功能
* poolPingQuery
检查连接状态的SQL语句
* poolPingConnectionsNotUsedFor
多久检查一次

POOLED这个DataSource别名实际上对应的是这个类：org.apache.ibatis.datasource.pooled.PooledDataSource

