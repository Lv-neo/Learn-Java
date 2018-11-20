[toc]

# 共享对数据的访问

## 共享变量

要使多个线程在一个程序中有用，它们必须有某种方法可以互相通信或共享它们的结果。
让线程共享其结果的最简单方法是使用共享变量。它们还应该使用同步来确保值从一个线程正确传播到另一个线程，以及防止当一个线程正在更新一些相关数据项时，另一个线程看到不一致的中间结果。

以下示例使用了一个共享布尔变量，用于表示指定的时间段已经过去了。这说明了在线程间共享数据最简单的形式是：轮询共享变量以查看另一个线程是否已经完成执行某项任务。

```
##本示例使用两个线程，一个用于计时，一个用于执行实际工作。主线程使用非常简单的算法计算素数。
在它启动之前，它创建并启动一个计时器线程，这个线程会休眠十秒钟，然后设置一个主线程要检查的标志。十秒钟之后，主线程将停止。请注意，共享标志被声明成 volatile。


/**
 * CalculatePrimes -- calculate as many primes as we can in ten seconds 
 */ 

public class CalculatePrimes extends Thread {

    public static final int MAX_PRIMES = 1000000;
    public static final int TEN_SECONDS = 10000;

    public volatile boolean finished = false;

    public void run() {
        int[] primes = new int[MAX_PRIMES];
        int count = 0;

        for (int i=2; count<MAX_PRIMES; i++) {

            // Check to see if the timer has expired
            if (finished) {
                break;
            }

            boolean prime = true;
            for (int j=0; j<count; j++) {
                if (i % primes[j] == 0) {
                    prime = false;
                    break;
                }
            }

            if (prime) {
                primes[count++] = i;
                System.out.println("Found prime: " + i);
            }
        }
    }

    public static void main(String[] args) {
        CalculatePrimes calculator = new CalculatePrimes();
        calculator.start();
        try {
            Thread.sleep(TEN_SECONDS);
        }
        catch (InterruptedException e) {
            // fall through
        }

        calculator.finished = true;
    }
}
```

## 存在于同一个内存空间中的所有线程

正如前面讨论过的，线程与进程有许多共同点，不同的是线程与同一进程中的其它线程共享相同的进程上下文，包括内存。这非常便利，但也有重大责任。只要访问共享变量（静态或实例字段），线程就可以方便地互相交换数据，但线程还必须确保它们以受控的方式访问共享变量，以免它们互相干扰对方的更改。

任何线程可以访问所有其作用域内的变量，就象主线程可以访问该变量一样。素数示例使用了一个公用实例字段，叫做 finished，用于表示已经过了指定的时间。当计时器过期时，一个线程会写这个字段；另一个线程会定期读取这个字段，以检查它是否应该停止。注：这个字段被声明成 volatile，这对于这个程序的正确运行非常重要。

## 受控访问的同步

为了确保可以在线程之间以受控方式共享数据，Java 语言提供了两个关键字：synchronized 和 volatile。

Synchronized 有两个重要含义：它确保了一次只有一个线程可以执行代码的受保护部分（互斥，mutual exclusion 或者说 mutex），而且它确保了一个线程更改的数据对于其它线程是可见的（更改的可见性）。

如果没有同步，数据很容易就处于不一致状态。例如，如果一个线程正在更新两个相关值（比如，粒子的位置和速率），而另一个线程正在读取这两个值，有可能在第一个线程只写了一个值，还没有写另一个值的时候，调度第二个线程运行，这样它就会看到一个旧值和一个新值。同步让我们可以定义必须原子地运行的代码块，这样对于其他线程而言，它们要么都执行，要么都不执行。

同步的原子执行或互斥方面类似于其它操作环境中的临界段的概念。

## 确保共享数据更改的可见性
同步可以让我们确保线程看到一致的内存视图。

处理器可以使用高速缓存加速对内存的访问（或者编译器可以将值存储到寄存器中以便进行更快的访问）。在一些多处理器体系结构上，如果在一个处理器的高速缓存中修改了内存位置，没有必要让其它处理器看到这一修改，直到刷新了写入器的高速缓存并且使读取器的高速缓存无效。

这表示在这样的系统上，对于同一变量，在两个不同处理器上执行的两个线程可能会看到两个不同的值！这听起来很吓人，但它却很常见。它只是表示在访问其它线程使用或修改的数据时，必须遵循某些规则。

Volatile 比同步更简单，只适合于控制对基本变量（整数、布尔变量等）的单个实例的访问。当一个变量被声明成 volatile，任何对该变量的写操作都会绕过高速缓存，直接写入主内存，而任何对该变量的读取也都绕过高速缓存，直接取自主内存。这表示所有线程在任何时候看到的 volatile 变量值都相同。

如果没有正确的同步，线程可能会看到旧的变量值，或者引起其它形式的数据损坏。

## 用锁保护的原子代码块
Volatile 对于确保每个线程看到最新的变量值非常有用，但有时我们需要保护比较大的代码片段，如涉及更新多个变量的片段。
同步使用监控器（monitor）或锁的概念，以协调对特定代码块的访问。

每个 Java 对象都有一个相关的锁。同一时间只能有一个线程持有 Java 锁。当线程进入 synchronized 代码块时，线程会阻塞并等待，直到锁可用，当它可用时，就会获得这个锁，然后执行代码块。当控制退出受保护的代码块时，即到达了代码块末尾或者抛出了没有在 synchronized 块中捕获的异常时，它就会释放该锁。

这样，每次只有一个线程可以执行受给定监控器保护的代码块。从其它线程的角度看，该代码块可以看作是原子的，它要么全部执行，要么根本不执行。

## Java 锁定
Java 锁定合并了一种互斥形式。每次只有一个线程可以持有锁。锁用于保护代码块或整个方法，必须记住是锁的身份保护了代码块，而不是代码块本身，这一点很重要。一个锁可以保护许多代码块或方法。

反之，仅仅因为代码块由锁保护并不表示两个线程不能同时执行该代码块。它只表示如果两个线程正在等待相同的锁，则它们不能同时执行该代码。

在以下示例中，两个线程可以同时不受限制地执行 setLastAccess() 中的 synchronized 块，因为每个线程有一个不同的 thingie 值。因此，synchronized 代码块受到两个正在执行的线程中不同锁的保护。

```
public class SyncExample {
  public static class Thingie {

    private Date lastAccess;

    public synchronized void setLastAccess(Date date) {
      this.lastAccess = date;
    }
  }

  public static class MyThread extends Thread { 
    private Thingie thingie;

    public MyThread(Thingie thingie) {
      this.thingie = thingie;
    }

    public void run() {
      thingie.setLastAccess(new Date());
    }
  }

  public static void main() { 
    Thingie thingie1 = new Thingie(), 
      thingie2 = new Thingie();

    new MyThread(thingie1).start();
    new MyThread(thingie2).start();
  }
}
```

## 同步的方法
创建 synchronized 块的最简单方法是将方法声明成 synchronized。这表示在进入方法主体之前，调用者必须获得锁：
```
public class Point {
  public synchronized void setXY(int x, int y) {
    this.x = x;
    this.y = y;
  }
}
```
对于普通的 synchronized方法，这个锁是一个对象，将针对它调用方法。对于静态 synchronized 方法，这个锁是与 Class 对象相关的监控器，在该对象中声明了方法。

仅仅因为 setXY() 被声明成 synchronized 并不表示两个不同的线程不能同时执行 setXY()，只要它们调用不同的 Point 实例的 setXY() 就可同时执行。对于一个 Point 实例，一次只能有一个线程执行 setXY()，或 Point的任何其它 synchronized 方法。

## 同步的块
synchronized 块的语法比 synchronized 方法稍微复杂一点，因为还需要显式地指定锁要保护哪个块。Point的以下版本等价于前一页中显示的版本：
```
public class Point {
  public void setXY(int x, int y) {
    synchronized (this) {
      this.x = x;
      this.y = y;
    }
  }
}
```
使用 this 引用作为锁很常见，但这并不是必需的。这表示该代码块将与这个类中的 synchronized 方法使用同一个锁。

由于同步防止了多个线程同时执行一个代码块，因此性能上就有问题，即使是在单处理器系统上。最好在尽可能最小的需要保护的代码块上使用同步。

访问局部（基于堆栈的）变量从来不需要受到保护，因为它们只能被自己所属的线程访问。

## 大多数类并没有同步
因为同步会带来小小的性能损失，大多数通用类，如 java.util 中的 Collection 类，不在内部使用同步。这表示在没有附加同步的情况下，不能在多个线程中使用诸如 HashMap 这样的类。

通过每次访问共享集合中的方法时使用同步，可以在多线程应用程序中使用 Collection 类。对于任何给定的集合，每次必须用同一个锁进行同步。通常可以选择集合对象本身作为锁。

下面的示例类 SimpleCache 显示了如何使用 HashMap 以线程安全的方式提供高速缓存。但是，通常适当的同步并不只是意味着同步每个方法。

Collections 类提供了一组便利的用于 List、Map 和 Set 接口的封装器。您可以用 Collections.synchronizedMap 封装 Map，它将确保所有对该映射的访问都被正确同步。

如果类的文档没有说明它是线程安全的，那么您必须假设它不是。

## 示例：简单的线程安全的高速缓存
如以下代码样本所示，SimpleCache.java 使用 HashMap 为对象装入器提供了一个简单的高速缓存。load() 方法知道怎样按对象的键装入对象。在一次装入对象之后，该对象就被存储到高速缓存中，这样以后的访问就会从高速缓存中检索它，而不是每次都全部地装入它。对共享高速缓存的每个访问都受到 synchronized 块保护。由于它被正确同步，所以多个线程可以同时调用 getObject 和 clearCache 方法，而没有数据损坏的风险。

```
public class SimpleCache {
  private final Map cache = new HashMap();

  public Object load(String objectName) { 
    // load the object somehow
  }

  public void clearCache() { 
    synchronized (cache) { 
      cache.clear();
    }
  }

  public Object getObject(String objectName) {
    synchronized (cache) { 
      Object o = cache.get(objectName);
      if (o == null) {
        o = load(objectName);
        cache.put(objectName, o);
      }
    }

    return o;
  }
}
```

## 小结
由于线程执行的计时是不确定的，我们需要小心，以控制线程对共享数据的访问。否则，多个并发线程会互相干扰对方的更改，从而损坏数据，或者其它线程也许不能及时看到对共享数据的更改。

通过使用同步来保护对共享变量的访问，我们可以确保线程以可预料的方式与程序变量进行交互。

每个 Java 对象都可以充当锁，synchronized 块可以确保一次只有一个线程执行由给定锁保护的 synchronized代码。


