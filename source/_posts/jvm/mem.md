---
title: jvm内存
tags:
    - jvm
    - HotSpot
    - HeapSize
---

# jvm内存

## Linux下命令查看Xms和Xmx的默认值

```
java -XX:+PrintFlagsFinal -version | grep HeapSize
```
