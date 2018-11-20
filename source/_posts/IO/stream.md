---
title:  java流
tag: io
---
<!-- toc -->
#  java流

---
title: # 流（Stream）的概念
tag: java
---
<!-- toc -->
# # 流（Stream）的概念

Java的I/O系统涉及流的概念。一个读取字节序列的对象被称为输入流，一个可以写入字节序列的对象称为输出流。输出流和输入流是相对于程序本身而言的。程序读取数据称为打开输入流，程序向其他源写入数据称为打开输出流。

程序读入数据，首先打开一个输入流，流以流对象的形式出现，数据文件或网络链接信息包装在流对象内，流对象一旦启动，程序可以从输入流依次读入数据。

当程序需要输出数据时，就打开一个输出流对象，该对象知道把数据写到什么地点（一个文件或通过网络传输到其他机器上的文件），数据是依次写入，通过输出流对象把数据写入目标文件。

在java.io包中有各种I/O流类，这里按照输入输出流处理的不同数据类型对流进行分类，即字符（Character）流和字节（Byte）流。

## 字符流

在Java的I/O系统提供了InputStream和OutputStream两个抽象类实现字节（8位）数据的输入/输出，其中InputStream是输入流的抽象类，提供了read（）方法，每个实现了该类的子类都要实现该方法，如ObjectInputStream类继承InputStream抽象类，重新定义了方法read（）来读取字节数据。本节介绍抽象类InputStream和OutputStream及其相对应的子类。

### 输入流类InputStream

抽象类InputStream表示从不同的输入源输入数据的类，这些数据源的数据类型多样，可以是字节数组、String对象、类的序列化对象，文件、管道或网络连接。对于多样的数据类型有相应的输入流类与其对应。下面介绍这些流类，使读者对这些类的功能和使用方法有基本的了解。

InputStream是个抽象类，提供了抽象read（）方法，下面几个类是继承自InputStream的子类：

```
* ByteArrayInputStream(字节数组输入流)
允许带缓冲区的输入流，显然该类的功能就是允许将内存缓冲区作为输入流使用，它包装了FilterInputStream对象，把该对象的输入文件作为实际数据输入到ByteArray InputStream流对象的缓冲区中。FilterInputStream包含几个子类，分别是LineNumberInputStream、DataInputStream、BufferedInputStream和PushbackInputStream。

* FileInputStream (文件输入流)
从文件中读取数据，其构造函数参数可以是文件对象、字符串或FileDescriptor对象。通过FilterInputStream流类的包装对程序提供读数据的接口。

* PipedInputStream (管道输入流)
该类产生输入管道流，该流又产生写入输出管道流的数据，这样就实现了管道化通信，通常在多线程编程中作为线程间通信的实现方式。

* SequenceInputStream (序列化输入流)
该流把多个输入流对象链接成一个输入流，该类的构造函数参数是两个InputStream对象或一个包含InputStream对象的枚举器对象。

* StringBufferInputStream (字符串缓冲输入流)
该类的功能是把String转换成输入流。应用程序创建一个该类的输入流，把构造函数的参数中的String数据作为程序的输入。构造函数为StringBufferInputStream（String str）。

* ObjectInputStream (对象输入流)
对象输入流读取输入流对象中的各种对象类型数据，用来处理序列化对象的传输。

* FilterInputStream (过滤器输入流)
该类继承了抽象类InputStream，实现了抽象方法read（）。
```

以下的类继承自FilterInputStream（过滤器输入流），同时实现了DataInput接口。

```
* LineNumberInputStream
该类实现对输入流中的行数的计数，对输入流增加了行号，该类的构造函数是InputStream流对象。

* DataInputStream
数据输入流允许程序从底层的输入流中读取基本类型的数据，如int型、float型和Byte型等。该类包含了读取基本类型的所有方法，如readByte（）、readBoolean（）、readChar（）、readDouble（）和readFloat（）等。其构造函数参数为一个InputStream流对象。

* BufferedInputStream
带缓冲的输入流，可以把数据先放入缓冲区，防止每次读取时进行实际的读写操作，减少了数据实际访问的时间开销。数据以字节数组的形式存放在缓冲区中，该类提供了read（）方法，每次从输入流读取一个字节数据。构造函数的参数为InputStream对象。

* PushbackInputStream
该类一般不被程序员使用，是为Java编译器而设计的。
```

### 输出流类OutputStream

抽象类OutputStream是表示输出数据流的抽象类，与抽象输入流对应，提供各种流对象的数据输出。下面介绍的输出流类，可以使读者了解输出流类的功能和使用方式。

OutputStream是个抽象类，提供了抽象write方法，下面几个类是继承自OutputStream的子类，这些类都实现了write（）方法。

```
* ByteOutputStream(字节数组输入流类)
在向输出流写入数据前先将数据缓冲处理，其缓冲区大小通过构造函数的参数设置。

* FileOutputStream(文件输出流类)
通过该输出流把数据写入文件，构造函数的参数可以是字符串、文件对象、文件或FileDescriptor对象。

* ObjectOutputStream(对象输出流类)
对象输出流把各种对象类型数据写入输出流文件中，用来处理序列化对象的传输。

* PipedOutputStream(管道输出流类)
与管道输入流（PipedInputStream）对应，任何管道输入流都通过输出流写出。两者搭配使用实现管道通信。

* FilterOutputStream(过滤器输出流类)
该类继承了抽象类OutputStream，实现了抽象方法write（）。
```
下面3个类继承自FilterOutputStream类并实现了DataOut接口。

```
* DataOutputStream(数据输出流类)
数据输出流同数据输入流（DataInputStream）对应，实现把基本类型数据写入输出流。该类提供了把数据写入输出流的所有方法，如writeBoolean（Boolean v）、writeByte（int v）、writeBytes（String s）、writeChar（int v）和wirteChars（String s）等。

* BufferedOutputStream(缓冲输出流类)
该类实现输出数据时首先进行数据缓冲，该类提供了flush（）方法实现清空数据缓冲区。该类的构造函数参数为输出流对象或输出流对象和输出缓冲区大小，即：

* PrintStream(打印输出流类)
该类的目的是实现Java基本数据类型的格式化输出。

```

## 字节流

Java在设计其I/O系统时，把输入/输出的数据类型分为两类，一类是字符流，如上节介绍的InputStream和OutputStream类及其子类都是字符（16 bit）流。另一类是字节流。本节介绍字节（8 bit）流，字节流也分为读流数据类和写流数据类，即Reader类和Writer类及其子类。

### Writer类
Writer类是字符（Character）流输出类的父类，它是抽象类，所有继承自该类的子类都必须实现抽象方法write（），具体的实现类中write（）方法的使用可以参考相应的JavaDoc文档。这里为了区别InputStream和OutputStream使用了Reader和Writer，为了使读者习惯于使用Reader和Writer，并且中文中没有合适的词汇表达相应的流的概念，所以不再具体翻译为中文，读者使用时只要知道Reader类负责读流数据，而Writer类负责向流中写数据即可。下面列出继承自Writer类的子类。

```
* BufferedWriter(带缓冲的Writer)
该类将文本写入字符流，将字节转换为字符同时缓冲读取每个字符，提供单个字符、数据和字符串的写入。该类提供两种构造函数指定缓冲区大小，一种是指定大小，另一种是采用默认值。一般情况下采用默认值就足够使用。在使用Writer类向文件写入数据时最好使用BufferedWriter包装开销大的write操作，如FileWriter类。这样可以缓冲字节或字符流，而不是把字符转换成字节后立即写入到文件（这样造成不断地读写数据，显然效率低）。

* CharArrayWriter(字符组的Writer)
该类作为Writer的字符缓冲区。该缓冲区随着向流中写入数据而自动增长。该类的构造函数提供两种形式，一种是默认的形式，另一种是有整型参数的形式。第二种构造函数构造指定初始容量的CharArrayWriter。

* FilterWriter(带过滤器的Writer)
该类把字符写入文件，文件位置在构造函数中指定，其构造函数接受默认的字符编码和默认的字节缓冲区大小。该类用于写入字符流，如果要写入的是原始字节流，则参考FiltOutputStream流来实现。

* OutputStreamWriter
该类提供了字符流向字节流的转换功能，并向流中写入字符。每次调用该类的write（）方法都会导致向输出流写入一个或多个字节。为了提高字节到字符的转换效率，可以使用缓冲机制。如可以把OutputStreamReader类包装在BufferedReader中以提高字符读取的效率。

* PrintWriter(打印Writer)
该类提供了字符流向字节流的转换功能，并向流中写入字符。每次调用该类的write（）方法都会导致向输出流写入一个或多个字节。为了提高字节到字符的转换效率，可以使用缓冲机制。如可以把OutputStreamReader类包装在BufferedReader中以提高字符读取的效率。

* PipedWriter(管道Writer)
管道Writer类创建管道通信的输出流，通过该输出流把数据写入文件，和管道Reader相对应建立起管道通信。

* StringWriter(字符串Writer)
显然该类是一个字符流，利用其字符串缓冲区中的输出字符构造字符串。该类的构造函数有两种，一种是创建默认初始字符串缓冲区大小的新字符串Writer，另一种是创建具有指定初始字符串缓冲区大小的新字符串Writer。
```

### Reader类
Reader类是读取字符（Character）流的父类，它是抽象类，所有继承自该类的子类都必须实现抽象方法read（）和close（），具体的实现类中read（）方法的使用可以参考相应的JavaDoc文档。下面列出继承自Reader类的子类。

```
* BufferedReader(带缓冲Reader)
该类完成从字符输入流中读取文本，且缓冲读到的字符。用户可以指定缓冲区的大小，或者使用默认的缓冲区大小。为了实现高效的读取文本建议read（）操作开销高的Reader，如FileReader采用BufferedReader包装，将缓冲FileReader指定文件的输入。如果不使用缓冲机制，则每次调用read（）或readLine（）都会导致从文件中读取字节而后直接转换成字符返回退出方法，显然这样的效率很低。

* CharArrayReader(字符数组Reader)
该类继承了Reader抽象类，实现用做字符输入流的字符缓冲区读取字符。

* FileReader(文件Reader)
该类继承自InputStreamReader类，读取字符流，其构造函数默认采用了合适的字符编码和字节缓冲区大小。该类通过指定一个File对象、一个文件名或指定FileDescriptor的条件下创建一个新FileReader对象。

* FilterReader(过滤器Reader)
该类是个抽象类，用于读取已过滤的字符流。

* InputStreamReader(带行号Reader)
该类提供了字节流向字符流的转换功能，并读取字符流。每次调用该类的read（）方法都会从输入流中读取一个或多个字节。为了提高字节到字符的转换效率，可以使用缓冲机制从输入流中读取更多的字节后再进行转换，如可以把InputStreamReader类包装在BufferedReader中以提高字符读取的效率。

* LineNumberReader
跟踪行号的缓冲字符输入流。该类提供了两个方法void setLineNumber（int）和int getLineNumber（），分别用于设置和获取当前行号。

* PipedReader(管道Reader)
字符输入流，通过管道的方式从PipedWriter流读字符流。

* PushbackReader(推回Reader)
该类读取字符流，允许字符退回到流中的字符流。

* StringReader(字符串Reader)
从源数据流为字符串流的源读取字符串。
```

## File类

File类最初看起来像是代表文件，Java为该类起名确实有迷惑读者的地方，其实File类可以表示特定文件名（带绝对路径），也可以是某个目录下多一组文件，该类提供了方法可以用来访问多个文件。File类提供了丰富的方法来处理和文件或目录相关的操作，如创建和删除文件、创建和删除文件夹以及通过和其他类配合使用实现文件的复制和移动等。本节将介绍File类提供的这些功能。

### 创建文件夹（目录）

File类提供了丰富的接口函数供用户调用。创建目录是文件操作中经常遇到的情形，目录提供了文件存放的位置，用户可以根据需要在磁盘空间上建立目录。

```
File mypath = new File(filepath);
if (!mypath.exists()) {
	mypath.mkdir();
}
```

### 创建文件
在Java的File类中创建新文件只需要调用该类的一个
方法createNewFile（），但是在实际操作中需要注意一些事项，如判断文件是否存在，以及如何向新建文件中写入数据等。

```
File myFile = new File(fileName);
if(!myFile.exists()) {
	myFile.createNewFile();
}
```

### 复制文件
文件的复制涉及文件流的概念，在下面将更详细地介绍文件流操作。为了实现文件操作，本节使用了FileInputStream和FileOutputStream两个流类，通过文件输入流读取源文件，通过文件输入流把读入缓冲区的字节数据写入新文件。如果该新文件已经存在，则覆盖掉该文件；如果不存在，则新建一个文件。
```
int bytesum = byteread = 0;
File oldfile = new File(oldFile);
if (oldfile.exists() ) {
	InputStream ins =new FileInputStream(oldFile);
	FileOutputStream outs = new FileOutputStream(newFile);
	byte[] buffer = new byte[500];
	while( (byteread = ins.read(buffer) ) != -1 ) {
	bytesum +=byteread;
	System.out.println(bytesum);
	out.write(buffer, 0, byteread);
	}
	ins.close();
}
```

### 删除文件
在Java的File类中删除文件只需要调用该类的一个方法delete（），该方法可以删除指定的文件。
```
File deletedFile = new File(derecator);
deletedFile.delete();
```

### 删除文件夹
在Java的File类中删除文件夹，需要首先删除掉文件夹中的文件，再删除空文件夹。删除空文件夹的方法与删除文件的方法相同，所以关键是如何实现删除文件夹下的所有文件。上面已经知道如何删除一个文件，可以想象欲删除一个目录下的所有文件只要获得该文件的目录和文件名，使用一个循环调用来依次删除文件夹中的文件即可。



