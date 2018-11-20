[toc]

# Java线程

## 线程的实现
Java中线程的实现继承Thread类或者实现Runnable接口

### Thread 类

Thread 类是一个具体的类，即不是抽象类，该类封装了线程的行为。要创建一个线程，程序员必须创建一个从 Thread 类导出的新类。程序员必须覆盖 Thread 的 run() 函数来完成有用的工作。用户并不直接调用此函数；而是必须调用 Thread 的 start() 函数，该函数再调用 run()。下面的代码说明了它的用法：

```
import java.util.*;
class TimePrinter extends Thread {
    int pauseTime;
    String name;
    public TimePrinter(int x, String n) {
        pauseTime = x;
        name = n;
    }
    public void run() {
        while(true) {
            try {
                System.out.println(name + ":" + new 
                    Date(System.currentTimeMillis()));
                Thread.sleep(pauseTime);
            } catch(Exception e) {
                System.out.println(e);
            }
        }
    }
    static public void main(String args[]) {
        TimePrinter tp1 = new TimePrinter(1000, "Fast Guy");
        tp1.start();
        TimePrinter tp2 = new TimePrinter(3000, "Slow Guy");
        tp2.start();
    
    }
}

```

在本例中，我们可以看到一个简单的程序，它按两个不同的时间间隔（1 秒和 3 秒）在屏幕上显示当前时间。这是通过创建两个新线程来完成的，包括 main() 共三个线程。但是，因为有时要作为线程运行的类可能已经是某个类层次的一部分，所以就不能再按这种机制创建线程。虽然在同一个类中可以实现任意数量的接口，但 Java 编程语言只允许一个类有一个父类。同时，某些程序员避免从 Thread 类导出，因为它强加了类层次。对于这种情况，就要runnable 接口。

### Runnable接口

此接口只有一个函数，run()，此函数必须由实现了此接口的类实现。但是，就运行这个类而论，其语义与前一个示例稍有不同。我们可以用 runnable 接口改写前一个示例。（不同的部分用黑体表示。）


```
import java.util.*;
class TimePrinter 
        implements Runnable {
    int pauseTime;
    String name;
    public TimePrinter(int x, String n) {
        pauseTime = x;
        name = n;
    }
    public void run() {
        while(true) {
            try {
                System.out.println(name + ":" + new 
                    Date(System.currentTimeMillis()));
                Thread.sleep(pauseTime);
            } catch(Exception e) {
                System.out.println(e);
            }
        }
    }
    static public void main(String args[]) {
        Thread t1 = new Thread (new TimePrinter(1000, "Fast Guy"));
        t1.start();
        Thread t2 = new Thread (new TimePrinter(3000, "Slow Guy"));
        t2.start();
    
    }
}

```

请注意，当使用 runnable 接口时，您不能直接创建所需类的对象并运行它；必须从 Thread 类的一个实例内部运行它。许多程序员更喜欢 runnable 接口，因为从 Thread 类继承会强加类层次。

## 线程的状态

[请阅读什么是线程](thread.md)

## 线程的优先级

线程的优先级表示一个线程被CPU执行的机会多少。注意，这里用“机会多少”而不是用“先后顺序”来表达。在Java中虽然定义了设置线程优先级高低的方法，但是优先级低并不意味着在不同优先级的线程中就不会被执行，优先级低只说明该线程被执行的概率小，同理优先级高的线程获得CPU周期的概率就大。

通过Thread类的setPriority（）方法设置线程的优先级，该方法的参数为int型。其实Java提供了3个优先级别，都为Thread类的常量，从高到低依次为Thread.MAX_PRIORITY、Thread.NORM_PRIORITY、Thread.MIN_PRIORITY。这里再次重申，优先级低并不意味着线程得不到执行，而是线程被执行的概率小。这也说明设置线程的优先级不会造成死锁的发生。

## 线程的同步

在多线程中经常遇到的一个问题就是资源共享问题。假设两个线程同时访问一个数据区，一个读数据，一个写数据，在一个线程读数据前另一个线程修改了数据，则读数据线程读到的不是原始数据而是被修改过的数据，显然这样是不允许的。而在多线程编程中经常会遇到访问共享资源的问题，这些资源可以是数据、文件、一块内存区或是外围设备的访问等。所以必须解决在多线程编程中实现资源共享的问题，在Java中称为线程的同步问题。在多数的编程语言中解决共享资源冲突的方法是采用顺序机制（Serialize），通过为共享资源加锁的方法实现资源的顺序访问。

### synchronized 关键字

在设计多线程模式中，解决线程冲突问题都是采用synchronized关键字来实现的。这意味着在给定时刻只允许一个线程访问共享资源。通常是在代码前加上一条锁语句实现的，这就保证了在一段时间内只有一个线程运行这段代码。如果另一个线程需要访问这段共享资源，必须等待当前的线程释放锁。可见锁语句产生了一种互斥的效果，所以常常称锁为“互斥量”（mutex）。

* 同步控制方法：

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


* 同步控制块：
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


