---
title:  配置简介
tag: mybatis
---
<!-- toc -->
#  配置简介
* properties：用于配置属性信息。

* settings：用于配置MyBatis的运行时方式。

* typeAliases：配置类型别名，可以在xml中用别名取代全限定名。

* typeHandlers：配置类型处理器。

* plugins：配置拦截器，用于拦截sql语句的执行。

* environments：配置数据源信息、连接池、事务属性等。

* mappers：配置SQL映射文件。


## properties


配置properties采用键值对的格式进行配置。

* 文件内配置properties

```
<property name="name1" value="value1"/>
<property name="name2" value="value2"/>
<property name="name3" value="value3"/>
    ......
<property name="nameN" value="valueN"/>
```

* 文件外配置properties
```
<properties resource="config.properties" />
```

config.properties中的内容如下所示：

```
name1:value1 
name2:value2 
name3:value2 
...... 
nameN:valueN
```

###setting

格式
```
<settings>
  <setting name="name1" value="value1" />
  <setting name="name2" value="value2" />
  <setting name="name3" value="value3" />
        ...... 
  <setting name="nameN" value="valueN" />
 </settings>
```

|设置参数	|描述|	有效值	|默认值|
|----|---- |---- |---- |
| cacheEnabled	| 这个配置使全局的映射器启用或禁用 缓存。	| boolen| 	true| 
| lazyLoadingEnabled	| 全局启用或禁用延迟加载。当禁用时, 所有关联对象都会即时加载。                 This value can be superseded for an specific relation by using the fetchType attribute on it.	| boolen| 	false| 
| aggressiveLazyLoading	| 当启用时, 有延迟加载属性的对象在被               调用时将会完全加载任意属性。否则,                每种属性将会按需要加载。	| boolen| true|
| multipleResultSetsEnabled| 	允许或不允许多种结果集从一个单独                 的语句中返回(需要适合的驱动)	| boolen|	true|
| useColumnLabel| 	使用列标签代替列名。                不同的驱动在这                 方便表现不同。                 参考驱动文档或充分测                 试两种方法来决定所使用的驱动。	| boolen| 	true| 
| useGeneratedKeys	| 允许 JDBC 支持生成的键。                 需要适合的                 驱动。                 如果设置为 true 则这个设置强制                 生成的键被使用,                  尽管一些驱动拒绝兼                 容但仍然有效(比如 Derby)	| boolen| 	False|
| autoMappingBehavior	| 指定 MyBatis 如何自动映射列到字段/                 属性。PARTIAL 只会自动映射简单,                  没有嵌套的结果。FULL 会自动映射任                 意复杂的结果(嵌套的或其他情况)                   。	| NONE, PARTIAL, FULL	| PARTIAL| 
| defaultExecutorType	| 配置默认的执行器。SIMPLE 执行器没                 有什么特别之处。REUSE 执行器重用                 预处理语句。BATCH 执行器重用语句                 和批量更新	| SIMPLE                REUSE                BATCH| 	SIMPLE| 
| defaultStatementTimeout	| 设置超时时间,                 它决定驱动等待一个数                据库响应的时间。	Any positive integer	Not Set (null)| 
| safeRowBoundsEnabled	| Allows using RowBounds on nested                statements.	| boolen|	False|
| mapUnderscoreToCamelCase	| Enables automatic mapping from                classic database column names                A_COLUMN to camel case classic Java                property names aColumn.	| boolen| 	False| 
| localCacheScope| 	MyBatis uses local cache to prevent circular references and speed up repeated nested queries.                 By default (SESSION) all queries executed during a session are cached. If localCacheScope=STATEMENT local session will be used just for                 statement execution, no data will be shared between two different calls to the same SqlSession.	| SESSION or STATEMENT	| SESSION| 
| jdbcTypeForNull| 	Specifies the JDBC type for null values when no specific JDBC type was provided for the parameter.                 Some drivers require specifying the column JDBC type but others work with generic values like NULL, VARCHAR or OTHER.| 	JdbcType enumeration. Most common are: NULL, VARCHAR and OTHER| 	OTHER| 
| lazyLoadTriggerMethods| 	Specifies which Object's methods trigger a lazy load	| A method name list separated by commas| 	equals,clone,hashCode,toString| 
| defaultScriptingLanguage| 	Specifies the language used by default for dynamic SQL generation.	A type alias or fully qualified class name.| 	| org.apache.ibatis.scripting.xmltags.XMLDynamicLanguageDriver| 
| callSettersOnNulls| 	当结果集中含有Null值时是否执行映射对象的setter或者Map对象的put方法。此设置对于原始类型如int,boolean等无效。	| boolen	| false| 
| logPrefix	Specifies | the prefix string that MyBatis will add to the logger names.	| Any String	| Not set| 
| logImpl| 	Specifies which logging implementation MyBatis should use. If this setting is not present logging implementation will be autodiscovered.	| SLF4J LOG4J LOG4J2  JDK_LOGGING COMMONS_LOGGING STDOUT_LOGGING NO_LOGGING	| Not set| 
| proxyFactory| 	Specifies the proxy tool that MyBatis will use for creating lazy loading capable objects.	| CGLIB or JAVASSIST| 	CGLIB| 


###typeAliases

```
<typeAliases>
  <typeAlias alias="Author" type="domain.blog.Author"/>
  <typeAlias alias="Blog" type="domain.blog.Blog"/>
  <typeAlias alias="Comment" type="domain.blog.Comment"/>
  <typeAlias alias="Post" type="domain.blog.Post"/>
  <typeAlias alias="Section" type="domain.blog.Section"/>
  <typeAlias alias="Tag" type="domain.blog.Tag"/>
</typeAliases>
```

类型别名必须遵循MyBatis命名规范。

具体参见：http://mybatis.github.io/mybatis-3/zh/configuration.html#typeAliases

###typeHandlers

无论是 MyBatis 在预处理语句中设置一个参数, 还是从结果集中取出一个值时, 类型处 理器被用来将获取的值以合适的方式转换成 Java 类型。下面这个表格描述了默认的类型处 理器。

|类型处理器|	Java类型	|JDBC类型|
|----|----|----|
|BooleanTypeHandler |             	java.lang.Boolean, boolean              	|任何兼容的布尔值|
|ByteTypeHandler   |           	java.lang.Byte, byte              	|任何兼容的数字或字节类型|
|ShortTypeHandler|              	java.lang.Short, short  |            	任何兼容的数字或短整型|
|IntegerTypeHandler   |           	java.lang.Integer, int    |          	任何兼容的数字和整型|
|LongTypeHandler         |     	java.lang.Long, long  |            	任何兼容的数字或长整型|
|FloatTypeHandler         |     	java.lang.Float, float   |           	任何兼容的数字或单精度浮点型|
|DoubleTypeHandler   |           	java.lang.Double, double    |          	任何兼容的数字或双精度浮点型|
|BigDecimalTypeHandler       |       	java.math.BigDecimal     |         	任何兼容的数字或十进制小数类型|
|StringTypeHandler    |          	java.lang.String   |           	CHAR 和 VARCHAR 类型|
|ClobTypeHandler    |          	java.lang.String    |          	CLOB 和 LONGVARCHAR 类型|
|NStringTypeHandler      |        	java.lang.String      |        	NVARCHAR 和 NCHAR 类型|
|NClobTypeHandler  |            	java.lang.String   |           	NCLOB 类型|
|ByteArrayTypeHandler   |           	byte[]          |    	任何兼容的字节流类型|
|BlobTypeHandler   |           	byte[]         |     	BLOB 和 LONGVARBINARY 类型|
|DateTypeHandler     |         	java.util.Date  |            	TIMESTAMP 类型|
|DateOnlyTypeHandler|              	java.util.Date   |           	DATE 类型|
|TimeOnlyTypeHandler   |           	java.util.Date     |         	TIME 类型|
|SqlTimestampTypeHandler  |            	java.sql.Timestamp  |            	TIMESTAMP |类型|
|SqlDateTypeHandler              	java.sql.Date     |         	DATE| 类型|
|SqlTimeTypeHandler              	java.sql.Time     |         	TIME |类型|
|ObjectTypeHandler    |          	Any	|其他或未指定类型|
|EnumTypeHandler   |           	Enumeration Type|	VARCHAR-任何兼容的字符串类型,              |   作为代码存储(而不是索引)|
|EnumOrdinalTypeHandler   |           	Enumeration Type| 	Any compatible NUMERIC or DOUBLE, as the position is stored                (not the code itself).|
你可以重写类型处理器或创建你自己的类型处理器来处理不支持的或非标准的类型。

###plugins

参见：http://mybatis.github.io/mybatis-3/zh/configuration.html#plugins

###environments

参见：http://mybatis.github.io/mybatis-3/zh/configuration.html#environments

###mappers

```
<mappers>
  <mapper resource="model1.xml"/>
  <mapper resource="model2.xml"/>
  <mapper resource="model3.xml"/>
    ...... 
  <mapper resource="modelN.xml"/> 
</mappers>
```

