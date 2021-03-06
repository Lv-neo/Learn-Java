---
title:  线程同步详解
tag: thread
---
<!-- toc -->
#  线程同步详解

## 互斥

在[共享对数据的访问](shared.md)中，我们讨论了 synchronized 块的特征，并在实现典型互斥锁（即，互斥或临界段）时说明了它们，其中每次只有

一个线程可以执行受给定锁保护的代码块。
互斥是同步所做工作的重要部分，但同步还有其它几种特征，这些特征对于在多处理器系统上取得正确结果非常重要。

## 可见性

除了互斥，同步（如 volatile）强制某些可见性约束。当对象获取锁时，它首先使自己的高速缓存无效，这样就可以保证直接从主内存中装入变量。

同样，在对象释放锁之前，它会刷新其高速缓存，强制使已做的任何更改都出现在主内存中。

这样，会保证在同一个锁上同步的两个线程看到在 synchronized 块内修改的变量的相同值。

## 什么时候必须同步？

要跨线程维护正确的可见性，只要在几个线程之间共享非 final 变量，就必须使用 synchronized（或 volatile）以确保一个线程可以看见另一个线程做的更改。

可见性同步的基本规则是在以下情况中必须同步：

* 	读取上一次可能是由另一个线程写入的变量
* 	写入下一次可能由另一个线程读取的变量

## 用于一致性的同步
除了用于可见性的同步，从应用程序角度看，您还必须用同步来确保一致性得到了维护。当修改多个相关值时，您想要其它线程原子地看到这组更改 ― 要么看到全部更改，要么什么也看不到。这适用于相关数据项（如粒子的位置和速率）和元数据项（如链表中包含的数据值和列表自身中的数据项的链）。

考虑以下示例，它实现了一个简单（但不是线程安全的）的整数堆栈：

```
public class UnsafeStack {
  public int top = 0;
  public int[] values = new int[1000];

  public void push(int n) {
    values[top++] = n;
  }

  public int pop() {
    return values[--top];
  }
}
```

如果多个线程试图同时使用这个类，会发生什么？这可能是个灾难。因为没有同步，多个线程可以同时执行 push() 和 pop()。如果一个线程调用 push()，而另一个线程正好在递增了 top 并要把它用作 values 的下标之间调用 push()，会发生什么？结果，这两个线程会把它们的新值存储到相同的位置！当多个线程依赖于数据值之间的已知关系，但没有确保只有一个线程可以在给定时间操作那些值时，可能会发生许多形式的数据损坏，而这只是其中之一。

对于这种情况，补救办法很简单：同步 push() 和 pop() 这两者，您将防止线程执行相互干扰。

请注意，使用 volatile 还不够 ― 需要使用 synchronized 来确保 top 和 values 之间的关系保持一致。


## 递增共享计数器

通常，如果正在保护一个基本变量（如一个整数），有时只使用 volatile 就可以侥幸过关。但是，如果变量的新值派生自以前的值，就必须使用同步。为什么？考虑这个类：

```
public class Counter {
  private int counter = 0;

  public int  get()      { return counter; }
  public void set(int n) { counter = n; }
  public void increment() {
    set(get() + 1);
  }
}
```

当我们要递增计数器时，会发生什么？请看 increment() 的代码。它很清楚，但不是线程安全的。如果两个线程试图同时执行 increment()，会发生什么？计数器也许会增加 1，也许增加 2。令人惊奇的是，把 counter 标记成 volatile 没有帮助，使 get() 和 set() 都变成 synchronized 也没有帮助。

设想计数器是零，而两个线程同时执行递增操作代码。这两个线程会调用 Counter.get()，并且看到计数器是零。现在两个线程都对它加一，然后调用 Counter.set()。如果我们的计时不太凑巧，那么这两个线程都看不到对方的更新，即使 counter 是 volatile，或者 get() 和 set() 是 synchronized。现在，即使计数器递增了两次，得到的值也许只是一，而不是二。

要使递增操作正确运行，不仅 get() 和 set() 必须是 synchronized，而且 increment() 也必需是 synchronized！否则，调用 increment() 的线程可能会中断另一个调用 increment() 的线程。如果您不走运，最终结果将会是计数器只增加了一次，不是两次。同步 increment() 防止了这种情况的发生，因为整个递增操作是原子的。

当循环遍历 Vector 的元素时，同样如此。即使同步了 Vector 的方法，但在循环遍历时，Vector 的内容仍然会更改。如果要确保 Vector 的内容在循环遍历时不更改，必须同步整个代码块。

## 不变性和 final 字段
许多 Java 类，包括 String、Integer 和 BigDecimal，都是不可改变的：一旦构造之后，它们的状态就永远不会更改。如果某个类的所有字段都被声明成 final，那么这个类就是不可改变的。（实际上，许多不可改变的类都有非 final 字段，用于高速缓存以前计算的方法结果，如 String.hashCode()，但调用者看不到这些字段。）

不可改变的类使并发编程变得非常简单。因为不能更改它们的字段，所以就不需要担心把状态的更改从一个线程传递到另一个线程。在正确构造了对象之后，可以把它看作是常量。

同样，final 字段对于线程也更友好。因为 final 字段在初始化之后，它们的值就不能更改，所以当在线程之间共享 final 字段时，不需要担心同步访问。

## 什么时候不需要同步

在某些情况中，您不必用同步来将数据从一个线程传递到另一个，因为 JVM 已经隐含地为您执行同步。这些情况包括：

* 由静态初始化器（在静态字段上或 static{} 块中的初始化器）初始化数据时
* 访问 final 字段时
* 在创建线程之前创建对象时
* 线程可以看见它将要处理的对象时

## 死锁
只要您拥有多个进程，而且它们要争用对多个锁的独占访问，那么就有可能发生死锁。如果有一组进程或线程，其中每个都在等待一个只有其它进程或线程才可以执行的操作，那么就称它们被死锁了。 

最常见的死锁形式是当线程 1 持有对象 A 上的锁，而且正在等待与 B 上的锁，而线程 2 持有对象 B 上的锁，却正在等待对象 A 上的锁。这两个线程永远都不会获得第二个锁，或者释放第一个锁。它们只会永远等待下去。

要避免死锁，应该确保在获取多个锁时，在所有的线程中都以相同的顺序获取锁。

## 性能考虑事项
关于同步的性能代价有许多说法 ― 其中有许多是错的。同步，尤其是争用的同步，确实有性能问题，但这些问题并没有象人们普遍怀疑的那么大。

许多人都使用别出心裁但不起作用的技巧以试图避免必须使用同步，但最终都陷入了麻烦。一个典型的示例是双重检查锁定模式（请参阅[参考资料](https://www.ibm.com/developerworks/cn/education/java/j-threads/j-threads.html#resources)，其中有几篇文章讲述了这种模式有什么问题）。这种看似无害的结构据说可以避免公共代码路径上的同步，但却令人费解地失败了，而且所有试图修正它的尝试也失败了。

在编写并发代码时，除非看到性能问题的确凿证据，否则不要过多考虑性能。瓶颈往往出现在我们最不会怀疑的地方。投机性地优化一个也许最终根本不会成为性能问题的代码路径 ― 以程序正确性为代价 ― 是一桩赔本的生意。

## 同步准则
当编写 synchronized 块时，有几个简单的准则可以遵循，这些准则在避免死锁和性能危险的风险方面大有帮助：

* 使代码块保持简短。Synchronized 块应该简短 ― 在保证相关数据操作的完整性的同时，尽量简短。把不随线程变化的预处理和后处理移出 synchronized 块。
* 不要阻塞。 不要在 synchronized 块或方法中调用可能引起阻塞的方法，如 InputStream.read()。
* 在持有锁的时候，不要对其它对象调用方法。这听起来可能有些极端，但它消除了最常见的死锁源头。


