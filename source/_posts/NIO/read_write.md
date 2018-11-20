# NIO 中的读和写

## 概述
读和写是 I/O 的基本过程。从一个通道中读取很简单：只需创建一个缓冲区，然后让通道将数据读到这个缓冲区中。写入也相当简单：创建一个缓冲区，用数据填充它，然后让通道用这些数据来执行写入操作。

在本节中，我们将学习有关在 Java 程序中读取和写入数据的一些知识。我们将回顾 NIO 的主要组件(缓冲区、通道和一些相关的方法)，看看它们是如何交互以进行读写的。在接下来的几节中，我们将更详细地分析这其中的每个组件以及其交互。

## 从文件中读取
在我们第一个练习中，我们将从一个文件中读取一些数据。如果使用原来的 I/O，那么我们只需创建一个 FileInputStream 并从它那里读取。而在 NIO 中，情况稍有不同：我们首先从 FileInputStream 获取一个 Channel 对象，然后使用这个通道来读取数据。

在 NIO 系统中，任何时候执行一个读操作，您都是从通道中读取，但是您不是 直接 从通道读取。因为所有数据最终都驻留在缓冲区中，所以您是从通道读到缓冲区中。

因此读取文件涉及三个步骤：
(1) 从 FileInputStream 获取 Channel，
(2) 创建 Buffer，
(3) 将数据从 Channel读到 Buffer 中。

现在，让我们看一下这个过程。

## 三个容易的步骤
第一步是获取通道。我们从 FileInputStream 获取通道：

```
FileInputStream fin = new FileInputStream( "readandshow.txt" );
FileChannel fc = fin.getChannel();
```

下一步是创建缓冲区：
```
ByteBuffer buffer = ByteBuffer.allocate( 1024 );
```

最后，需要将数据从通道读到缓冲区中，如下所示：
```
fc.read( buffer );
```

您会注意到，我们不需要告诉通道要读 多少数据 到缓冲区中。每一个缓冲区都有复杂的内部统计机制，它会跟踪已经读了多少数据以及还有多少空间可以容纳更多的数据。我们将在 缓冲区内部细节 中介绍更多关于缓冲区统计机制的内容。

## 写入文件

在 NIO 中写入文件类似于从文件中读取。首先从 FileOutputStream 获取一个通道：
```
FileOutputStream fout = new FileOutputStream( "writesomebytes.txt" );
FileChannel fc = fout.getChannel();
```

下一步是创建一个缓冲区并在其中放入一些数据 - 在这里，数据将从一个名为 message 的数组中取出，这个数组包含字符串 "Some bytes" 的 ASCII 字节(本教程后面将会解释 buffer.flip() 和 buffer.put() 调用)。

```
ByteBuffer buffer = ByteBuffer.allocate( 1024 );

for (int i=0; i<message.length; ++i) {
     buffer.put( message[i] );
}
buffer.flip();
```

最后一步是写入缓冲区中：
```
fc.write( buffer );
```

> 注意在这里同样不需要告诉通道要写入多数据。缓冲区的内部统计机制会跟踪它包含多少数据以及还有多少数据要写入。

## 读写结合

下面我们将看一下在结合读和写时会有什么情况。我们以一个名为 CopyFile.java 的简单程序作为这个练习的基础，它将一个文件的所有内容拷贝到另一个文件中。CopyFile.java 执行三个基本操作：首先创建一个 Buffer，然后从源文件中将数据读到这个缓冲区中，然后将缓冲区写入目标文件。这个程序不断重复 ― 读、写、读、写 ― 直到源文件结束。

CopyFile 程序让您看到我们如何检查操作的状态，以及如何使用 clear() 和 flip() 方法重设缓冲区，并准备缓冲区以便将新读取的数据写到另一个通道中。

## 运行 CopyFile 例子

因为缓冲区会跟踪它自己的数据，所以 CopyFile 程序的内部循环 (inner loop) 非常简单，如下所示：
```
fcin.read( buffer );
fcout.write( buffer );
```

第一行将数据从输入通道 fcin 中读入缓冲区，第二行将这些数据写到输出通道 fcout 。

## 检查状态
下一步是检查拷贝何时完成。当没有更多的数据时，拷贝就算完成，并且可以在 read() 方法返回 -1 是判断这一点，如下所示：
```
int r = fcin.read( buffer );

if (r==-1) {
     break;
}
```

## 重设缓冲区
最后，在从输入通道读入缓冲区之前，我们调用 clear() 方法。同样，在将缓冲区写入输出通道之前，我们调用 flip() 方法，如下所示：

```
buffer.clear();
int r = fcin.read( buffer );

if (r==-1) {
     break;
}

buffer.flip();
fcout.write( buffer );
```

clear() 方法重设缓冲区，使它可以接受读入的数据。 flip() 方法让缓冲区可以将新读入的数据写入另一个通道。


