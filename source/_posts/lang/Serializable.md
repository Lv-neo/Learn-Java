# 理解Serializable

###什么是序列化和反序列化
Serialization（序列化）是一种将对象以一连串的字节描述的过程；反序列化deserialization是一种将这些字节重建成一个对象的过程。

###什么情况下需要序列化 
* 当你想把的内存中的对象保存到一个文件中或者数据库中时候；
* 当你想用套接字在网络上传送对象的时候；
* 当你想通过RMI传输对象的时候；

###如何实现序列化
将需要序列化的类实现Serializable接口就可以了，Serializable接口中没有任何方法，可以理解为一个标记，即表明这个类可以序列化。

###序列化和反序列化例子
如果我们想要序列化一个对象，首先要创建某些OutputStream(如FileOutputStream、ByteArrayOutputStream等)，然后将这些OutputStream封装在一个ObjectOutputStream中。这时候，只需要调用writeObject()方法就可以将对象序列化，并将其发送给OutputStream（记住：对象的序列化是基于字节的，不能使用Reader和Writer等基于字符的层次结构）。而反序列的过程（即将一个序列还原成为一个对象），需要将一个InputStream(如FileInputstream、ByteArrayInputStream等)封装在ObjectInputStream内，然后调用readObject()即可。

```java
package com.sheepmu;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
 
public class MyTest implements Serializable
{
    private static final long serialVersionUID = 1L;
    private String name="SheepMu";
    private int age=24;
    public static void main(String[] args)
    {//以下代码实现序列化
        try
        {
            ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("my.out"));//输出流保存的文件名为 my.out ；ObjectOutputStream能把Object输出成Byte流
            MyTest myTest=new MyTest();
            oos.writeObject(myTest); 
            oos.flush();  //缓冲流 
            oos.close(); //关闭流
        } catch (FileNotFoundException e) 
        {        
            e.printStackTrace();
        } catch (IOException e) 
        {
            e.printStackTrace();
        } 
        fan();//调用下面的  反序列化  代码
    }
    public static void fan()//反序列的过程
    {    
         ObjectInputStream oin = null;//局部变量必须要初始化
        try
        {
            oin = new ObjectInputStream(new FileInputStream("my.out"));
        } catch (FileNotFoundException e1)
        {        
            e1.printStackTrace();
        } catch (IOException e1)
        {
            e1.printStackTrace();
        }      
        MyTest mts = null;
        try {
            mts = (MyTest ) oin.readObject();//由Object对象向下转型为MyTest对象
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }     
         System.out.println("name="+mts.name);    
         System.out.println("age="+mts.age);    
    }
}
```

会在此项目的工作空间生成一个 my.out文件。序列化后的内容稍后补齐，先看反序列化后输出如下：
name=SheepMu
age=24

###序列化ID
序列化 ID 在 Eclipse 下提供了两种生成策略，一个是固定的 1L，一个是随机生成一个不重复的 long 类型数据（实际上是使用 JDK 工具生成），在这里有一个建议，如果没有特殊需求，就是用默认的 1L 就可以，这样可以确保代码一致时反序列化成功。这也可能是造成序列化和反序列化失败的原因，因为不同的序列化id之间不能进行序列化和反序列化。

###序列化前和序列化后的对象的关系

是 "=="还是equal？ or 是浅复制还是深复制？ 
答案：深复制，反序列化还原后的对象地址与原来的的地址不同
序列化前后对象的地址不同了，但是内容是一样的，而且对象中包含的引用也相同。换句话说，通过序列化操作,我们可以实现对任何可Serializable对象的”深度复制（deep copy）"——这意味着我们复制的是整个对象网，而不仅仅是基本对象及其引用。对于同一流的对象，他们的地址是相同，说明他们是同一个对象，但是与其他流的对象地址却不相同。也就说，只要将对象序列化到单一流中，就可以恢复出与我们写出时一样的对象网，而且只要在同一流中，对象都是同一个。

###静态变量能否序列化

若把上面的代码中的 age变量前加上 static ,输出任然是

name=SheepMu
age=24

但是看下面的例子：

```java
package com.sheepmu;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
public class MyTest implements Serializable
{
    private static final long serialVersionUID = 1L;
    private String name="SheepMu";
    private static int age=24;
    public static void main(String[] args)
    {//以下代码实现序列化
        try
        {
            ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("my.out"));//输出流保存的文件名为 my.out ；ObjectOutputStream能把Object输出成Byte流
            MyTest myTest=new MyTest();
            oos.writeObject(myTest); 
            oos.flush();  //缓冲流 
            oos.close(); //关闭流
        } catch (FileNotFoundException e) 
        {        
            e.printStackTrace();
        } catch (IOException e) 
        {
            e.printStackTrace();
        } 
        fan();//调用下面的  反序列化  代码
    }
    public static void fan()
    {
        new MyTest().name="SheepMu_1";//!!!!!!!!!!!!!!!!重点看这两行 更改部分
          age=1;<span style="font-family: verdana, 'ms song', 宋体, Arial, 微软雅黑, Helvetica, sans-serif; ">//!!!!!!!!!!!!!!!!!!!重点看这两行 更改部分</span>
         ObjectInputStream oin = null;//局部变量必须要初始化
        try
        {
            oin = new ObjectInputStream(new FileInputStream("my.out"));
        } catch (FileNotFoundException e1)
        {        
            e1.printStackTrace();
        } catch (IOException e1)
        {
            e1.printStackTrace();
        }      
        MyTest mts = null;
        try {
            mts = (MyTest ) oin.readObject();//由Object对象向下转型为MyTest对象
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }     
         System.out.println("name="+mts.name);    
         System.out.println("age="+mts.age);    
    }
}
```

输出结果为：
name=SheepMu
age=1

为何把最上面代码的age变量添上static 后还是反序列化出了24呢？而新的从新对变量赋值的代码，不是static的得到了序列化本身的值，而static的则得到的是从新附的值。原因： 序列化会忽略静态变量，即序列化不保存静态变量的状态。静态成员属于类级别的，所以不能序列化。即 序列化的是对象的状态不是类的状态。这里的不能序列化的意思，是序列化信息中不包含这个静态成员域。最上面添加了static后之所以还是输出24是因为该值是JVM加载该类时分配的值。注：transient后的变量也不能序列化，但是情况稍复杂，稍后开篇说。

###总结
* 当一个父类实现序列化，子类自动实现序列化，不需要显式实现Serializable接口；

* 当一个对象的实例变量引用其他对象，序列化该对象时也把引用对象进行序列化；

* static,transient后的变量不能被序列化；



