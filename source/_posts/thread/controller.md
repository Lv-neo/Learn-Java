---
title:  线程的控制
tag: thread
---
<!-- toc -->
#  线程的控制

## 创建线程
在 Java 程序中创建线程有几种方法。每个 Java 程序至少包含一个线程：主线程。其它线程都是通过 Thread 构造器或实例化继承类 Thread 的类来创建的。

Java 线程可以通过直接实例化 Thread 对象或实例化继承 Thread 的对象来创建其它线程。在[java线程](java.md)中的示例（其中，我们在十秒钟之内计算尽量多的素数）中，我们通过实例化 CalculatePrimes 类型的对象（它继承了 Thread），创建了一个线程。

当我们讨论 Java 程序中的线程时，也许会提到两个相关实体：完成工作的实际线程或代表线程的 Thread 对象。正在运行的线程通常是由操作系统创建的；Thread 对象是由 Java VM 创建的，作为控制相关线程的一种方式。

## 创建线程和启动线程并不相同
在一个线程对新线程的 Thread 对象调用 start() 方法之前，这个新线程并没有真正开始执行。Thread 对象在其线程真正启动之前就已经存在了，而且其线程退出之后仍然存在。这可以让您控制或获取关于已创建的线程的信息，即使线程还没有启动或已经完成了。

通常在构造器中通过 start() 启动线程并不是好主意。这样做，会把部分构造的对象暴露给新的线程。如果对象拥有一个线程，那么它应该提供一个启动该线程的 start() 或 init() 方法，而不是从构造器中启动它。 

## 挂起和恢复线程
在Java2之前，用户会看到suspend（）和resume（）方法用来阻塞和唤醒线程，但是在Java2中这两个方法不再使用了。首先分析一下使用suspend（）方法会发生什么问题。suspend（）方法的作用是挂起拥有锁的线程，但是与wait（）方法不同，它不会释放锁。如果一个线程调用suspend（）方法，把另一个线程挂起，此时被挂起的线程在等待恢复，而挂起它的线程在等待获得锁（该锁就是被挂起的线程对象），此时就会发生死锁。

## 结束线程
程会以以下三种方式之一结束：

* 线程到达其 run() 方法的末尾。
* 线程抛出一个未捕获到的 Exception 或 Error。
* 另一个线程调用一个弃用的 stop() 方法。弃用是指这些方法仍然存在，但是您不应该在新代码中使用它们，并且应该尽量从现有代码中除去它们。

当 Java 程序中的所有线程都完成时，程序就退出了。

如果想要安全地结束线程又不使用stop（）方法，则只有通过某种替代方法了。这里提供一种通过线程间协作终止线程的间接方法：在线程内部设计一个变量和一个可以设置该变量的方法，而该变量的取值作为结束线程的标志。

## 加入线程
Thread API 包含了等待另一个线程完成的方法：join() 方法。当调用 Thread.join() 时，调用线程将阻塞，直到目标线程完成为止。

Thread.join() 通常由使用线程的程序使用，以将大问题划分成许多小问题，每个小问题分配一个线程。本章结尾处的示例创建了十个线程，启动它们，然后使用 Thread.join() 等待它们全部完成。

## 调度
除了何时使用 Thread.join() 和 Object.wait() 外，线程调度和执行的计时是不确定的。如果两个线程同时运行，而且都不等待，您必须假设在任何两个指令之间，其它线程都可以运行并修改程序变量。如果线程要访问其它线程可以看见的变量，如从静态字段（全局变量）直接或间接引用的数据，则必须使用同步以确保数据一致性。

在以下的简单示例中，我们将创建并启动两个线程，每个线程都打印两行到 System.out：
```
public class TwoThreads {

    public static class Thread1 extends Thread {
        public void run() {
            System.out.println("A");
            System.out.println("B");
        }
    }

    public static class Thread2 extends Thread {
        public void run() {
            System.out.println("1");
            System.out.println("2");
        }
    }

    public static void main(String[] args) {
        new Thread1().start();
        new Thread2().start();
    }
}
```

我们并不知道这些行按什么顺序执行，只知道“1”在“2”之前打印，以及“A”在“B”之前打印。输出可能是以下结果中的任何一种：

```
		1 2 A B
		1 A 2 B
		1 A B 2
		A 1 2 B
		A 1 B 2
		A B 1 2
```

不仅不同机器之间的结果可能不同，而且在同一机器上多次运行同一程序也可能生成不同结果。永远不要假设一个线程会在另一个线程之前执行某些操作，除非您已经使用了同步以强制一个特定的执行顺序。

## 休眠

Thread API 包含了一个 sleep(int miliseconds) 方法，它将使当前线程进入等待状态，直到过了一段指定时间，或者直到另一个线程对当前线程的 Thread 对象调用了 Thread.interrupt()，从而中断了线程。当过了指定时间后，线程又将变成可运行的，并且回到调度程序的可运行线程队列中。

如果线程是由对 Thread.interrupt() 的调用而中断的，那么休眠的线程会抛出 InterruptedException，这样线程就知道它是由中断唤醒的，就不必查看计时器是否过期。

Thread.yield() 方法就象 Thread.sleep() 一样，但它并不引起休眠，而只是暂停当前线程片刻，这样其它线程就可以运行了。在大多数实现中，当较高优先级的线程调用 Thread.yield() 时，较低优先级的线程就不会运行。

CalculatePrimes 示例使用了一个后台线程计算素数，然后休眠十秒钟。当计时器过期后，它就会设置一个标志，表示已经过了十秒。

## 守护程序线程
我们提到过当 Java 程序的所有线程都完成时，该程序就退出，但这并不完全正确。隐藏的系统线程，如垃圾收集线程和由 JVM 创建的其它线程会怎么样？我们没有办法停止这些线程。如果那些线程正在运行，那么 Java 程序怎么退出呢？

这些系统线程称作守护程序线程。Java 程序实际上是在它的所有非守护程序线程完成后退出的。

任何线程都可以变成守护程序线程。可以通过调用Thread.setDaemon() 方法来指明某个线程是守护程序线程。您也许想要使用守护程序线程作为在程序中创建的后台线程，如计时器线程或其它延迟的事件线程，只有当其它非守护程序线程正在运行时，这些线程才有用。

## 等待和通知
等待和通知实现了线程之间的协调机制，使得线程之间可以建立“和谐”的协作关系。Java提供了线程对象的wait（）、notifty（）或notifyAll（）方法来实现这种协作，wait（）方法使线程挂起一段时间，而notifty（）或notifyAll（）方法使线程从wait（）方法调用的状态中恢复到就绪状态。

wait（）和sleep（）方法相似，都是让线程暂时挂起，都可以接受一个时间参数来确定线程挂起时间。但是wait（）方法有如下特殊之处：

* 线程一旦调用wait（）方法，线程中同步方法的锁被释放，其他线程可以调用该线程中相应的同步方法。
* 使用wait（）方法的线程可以使用notifty（）或notifyAll（）方法获得执行的权利，即获得抢占CPU周期的权利。

wait（）可以使线程在等待外部输入条件时，让线程暂时休眠，等待notify（）或notifyAll（）方法来唤醒线程以检查是否有外部条件的输入。可见wait（）方法为线程之间的同步提供了方法。

```
public class ThreadWait {

    private String mydata;

    private boolean flag = false;

    public synchronized String getMydata() {
        while (flag == false) {
            try {
                //调用wait方法，释放对象锁，等待下一次获得对象锁
                wait();
            } catch (InterruptedException e) {

            }
            //设置标志变了flag为false后，通知所有等待该对象锁的线程
            flag = false;
            notifyAll();
        }
        return mydata;
    }

    public synchronized void setMydata(String str) {
        while (flag == true) {
            try {
                //flag的值不满足方法继续执行条件，调用wait()方法释放对象锁，等待下一次获取
                wait();
            } catch (InterruptedException e) {

            }
            mydata = str;
            //设置标志变量的flag为true后，通知所有等待该对象锁的线程
            flag = true;
            notifyAll();
        }
    }

}

```

在唤醒线程时推荐优先使用notifyAll（），而不是notify（），因为notify（）仅唤醒一个线程。如果用户知道只有一个线程处于等待状态，这是可行的。但是当多个线程处于等待状态，用户就无法预期被唤醒的是哪个线程，而这由JVM决定，用户无法控制。

假设有两个线程处于等待状态，其中一个等待某个输入条件，后来完成输入条件的那段代码调用了notify（），但它只能唤醒一个线程。由于两个线程都在等待，所以等待输入条件的线程不见得被唤醒。因此使用notify（）唤醒线程需要一定的条件：

* 用户确定只有一个线程处于等待状态。
* 多个线程处于等待状态且等待同样的条件，这样总有一个线程被唤醒，但是仍无法确定是哪个线程被唤醒。

notifyAll（）唤醒所有等待状态的线程。只要有一段代码调用该函数就可以确保所有等待中的线程都将被唤醒。所以在使用唤醒机制时最好使用notifyAll（），它唤醒所有等待中的线程，但是需要注意被唤醒的这些线程并不是都获得了对象锁，而是需要抢占对象锁。这种抢占顺序是无法预料的。


## 示例：用多个线程分解大任务
在这个示例中，TenThreads 显示了一个创建了十个线程的程序，每个线程都执行一部分工作。该程序等待所有线程全部完成，然后收集结果。

```
/**
 * Creates ten threads to search for the maximum value of a large matrix.
 * Each thread searches one portion of the matrix.
 */
public class TenThreads {

    private static class WorkerThread extends Thread {
        int max = Integer.MIN_VALUE;
        int[] ourArray;

        public WorkerThread(int[] ourArray) {
            this.ourArray = ourArray;
        }

        // Find the maximum value in our particular piece of the array
        public void run() {
            for (int i = 0; i < ourArray.length; i++) 
                max = Math.max(max, ourArray[i]);                
        }

        public int getMax() {
            return max;
        }
    }

    public static void main(String[] args) {
        WorkerThread[] threads = new WorkerThread[10];
        int[][] bigMatrix = getBigHairyMatrix();
        int max = Integer.MIN_VALUE;
        
        // Give each thread a slice of the matrix to work with
        for (int i=0; i < 10; i++) {
            threads[i] = new WorkerThread(bigMatrix[i]);
            threads[i].start();
        }

        // Wait for each thread to finish
        try {
            for (int i=0; i < 10; i++) {
                threads[i].join();
                max = Math.max(max, threads[i].getMax());
            }
        }
        catch (InterruptedException e) {
            // fall through
        }

        System.out.println("Maximum value was " + max);
    }
}
```

## 小结
就象程序一样，线程有生命周期：它们启动、执行，然后完成。一个程序或进程也许包含多个线程，而这些线程看来互相单独地执行。

线程是通过实例化 Thread 对象或实例化继承 Thread 的对象来创建的，但在对新的 Thread 对象调用 start()方法之前，这个线程并没有开始执行。当线程运行到其 run() 方法的末尾或抛出未经处理的异常时，它们就结束了。

sleep() 方法可以用于等待一段特定时间；而 join() 方法可能用于等到另一个线程完成。


