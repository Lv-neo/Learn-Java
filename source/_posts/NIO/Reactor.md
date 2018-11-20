---
title:  Reactor
tag: nio
---
<!-- toc -->
#  Reactor

## Reactor的由来

Reactor是一种广泛应用在服务器端开发的设计模式。Reactor中文大多译为“反应堆”，我当初接触这个概念的时候，就感觉很厉害，是不是它的原理就跟“核反应”差不多？后来才知道其实没有什么关系，从Reactor的兄弟“Proactor”（多译为前摄器）就能看得出来，这两个词的中文翻译其实都不是太好，不够形象。实际上，Reactor模式又有别名“Dispatcher”或者“Notifier”，我觉得这两个都更加能表明它的本质。

那么，Reactor模式究竟是个什么东西呢？这要从事件驱动的开发方式说起。我们知道，对于应用服务器，一个主要规律就是，CPU的处理速度是要远远快于IO速度的，如果CPU为了IO操作（例如从Socket读取一段数据）而阻塞显然是不划算的。好一点的方法是分为多进程或者线程去进行处理，但是这样会带来一些进程切换的开销，试想一个进程一个数据读了500ms，期间进程切换到它3次，但是CPU却什么都不能干，就这么切换走了，是不是也不划算？

这时先驱们找到了事件驱动，或者叫回调的方式，来完成这件事情。这种方式就是，应用业务向一个中间人注册一个回调（event handler），当IO就绪后，就这个中间人产生一个事件，并通知此handler进行处理。这种回调的方式，也体现了“好莱坞原则”（Hollywood principle）-“Don’t call us, we’ll call you”，在我们熟悉的IoC中也有用到。看来软件开发真是互通的！

好了，我们现在来看Reactor模式。在前面事件驱动的例子里有个问题：我们如何知道IO就绪这个事件，谁来充当这个中间人？Reactor模式的答案是：由一个不断等待和循环的单独进程（线程）来做这件事，它接受所有handler的注册，并负责先操作系统查询IO是否就绪，在就绪后就调用指定handler进行处理，这个角色的名字就叫做Reactor。

## Reactor与NIO
Java中的NIO可以很好的和Reactor模式结合。关于NIO中的Reactor模式，我想没有什么资料能比Doug Lea大神（不知道Doug Lea？看看JDK集合包和并发包的作者吧）在《Scalable IO in Java》解释的更简洁和全面了。NIO中Reactor的核心是Selector，我写了一个简单的Reactor示例，这里我贴一个核心的Reactor的循环（这种循环结构又叫做EventLoop），剩余代码在这里。

```
public void run() {
    try {
        while (!Thread.interrupted()) {
            selector.select();
            Set selected = selector.selectedKeys();
            Iterator it = selected.iterator();
            while (it.hasNext())
                dispatch((SelectionKey) (it.next()));
            selected.clear();
        }
    } catch (IOException ex) { /* ... */
    }
}
```

## 与Reactor相关的其他概念

前面提到了Proactor模式，这又是什么呢？简单来说，Reactor模式里，操作系统只负责通知IO就绪，具体的IO操作（例如读写）仍然是要在业务进程里阻塞的去做的，而Proactor模式则更进一步，由操作系统将IO操作执行好（例如读取，会将数据直接读到内存buffer中），而handler只负责处理自己的逻辑，真正做到了IO与程序处理异步执行。所以我们一般又说Reactor是同步IO，Proactor是异步IO。

关于阻塞和非阻塞、异步和非异步，以及UNIX底层的机制，大家可以看看这篇文章IO – 同步，异步，阻塞，非阻塞 （亡羊补牢篇），以及陶辉（《深入理解nginx》的作者）《高性能网络编程》的系列。


## 附录
摘自[Netty源码解读（四）Netty与Reactor模式](http://ifeve.com/netty-reactor-4/)

