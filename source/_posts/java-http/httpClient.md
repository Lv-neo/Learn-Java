---
title:  httpClient基本概念
tag: http
---
<!-- toc -->
#  httpClient基本概念

# #基本概念
HttpClient最基本的功能就是执行Http方法。
一个Http方法的执行涉及到一个或者多个Http请求/Http响应的交互，通常这个过程都会自动被HttpClient处理，对用户透明。
用户只需要提供Http请求对象，HttpClient就会将http请求发送给目标服务器，并且接收服务器的响应，如果http请求执行不成功，httpclient就会抛出异样。
下面是个很简单的http请求执行的例子：

```java
CloseableHttpClient httpclient = HttpClients.createDefault();
HttpGet httpget = new HttpGet("http://www.yeetrack.com/");
CloseableHttpResponse response = httpclient.execute(httpget);
try {
   <...>
} finally {
   response.close();
}
```

###http请求
所有的Http请求都有一个请求列（request line），包括方法名、请求的URI和Http版本号。
HttpClient支持HTTP/1.1这个版本定义的所有Http方法：GET, HEAD, POST, PUT, DELETE, TRACE和OPTIONS。
对于每一种http方法，HttpClient都定义了一个相应的类：HttpGet, HttpHead, HttpPost, HttpPut, HttpDelete, HttpTrace和HttpOpquertions。
Request-URI即统一资源定位符，用来标明Http请求中的资源。Http request URIS包含协议名、主机名、主机端口（可选）、资源路径、query（可选）和片段信息（可选）。

```java
HttpGet httpget = new HttpGet(
 "http://www.google.com/search?hl=en&q=httpclient&btnG=Google+Search&aq=f&oq=");
```
HttpClient提供URIBuilder工具类来简化URIs的创建和修改过程。

```java
    URI uri = new URIBuilder()
    .setScheme("http")
    .setHost("www.google.com")
    .setPath("/search")
    .setParameter("q", "httpclient")
    .setParameter("btnG", "Google Search")
    .setParameter("aq", "f")
    .setParameter("oq", "")
    .build();
    HttpGet httpget = new HttpGet(uri);
    System.out.println(httpget.getURI());
```
上述代码会在控制台输出：

```
http://www.google.com/search?q=httpclient&btnG=Google+Search&aq=f&oq=
```

###http响应

服务器收到客户端的http请求后，就会对其进行解析，然后把响应发给客户端，这个响应就是HTTP response.HTTP响应第一行是HTTP版本号，然后是响应状态码和响应内容。

```
HttpResponse response = new BasicHttpResponse(HttpVersion.HTTP_1_1, HttpStatus.SC_OK, "OK");

System.out.println(response.getProtocolVersion());
    System.out.println(response.getStatusLine().getStatusCode());
    System.out.println(response.getStatusLine().getReasonPhrase());
    System.out.println(response.getStatusLine().toString());
```
    
上述代码会在控制台输出：

```java
HTTP/1.1
200
OK
HTTP/1.1 200 OK
```

###消息头

一个Http消息可以包含一系列的消息头，用来对http消息进行描述，比如消息长度，消息类型等等。HttpClient提供了API来获取、添加、修改、遍历消息头。

```java
    HttpResponse response = new BasicHttpResponse(HttpVersion.HTTP_1_1, HttpStatus.SC_OK, "OK");
    response.addHeader("Set-Cookie", "c1=a; path=/; domain=yeetrack.com");
    response.addHeader("Set-Cookie", "c2=b; path=\"/\", c3=c; domain=\"yeetrack.com\"");
    Header h1 = response.getFirstHeader("Set-Cookie");
    System.out.println(h1);
    Header h2 = response.getLastHeader("Set-Cookie");
    System.out.println(h2);
    Header[] hs = response.getHeaders("Set-Cookie");
    System.out.println(hs.length);
上述代码会在控制台输出：
    Set-Cookie: c1=a; path=/; domain=yeetrack.com
    Set-Cookie: c2=b; path="/", c3=c; domain="yeetrack.com"
    2
```
    
最有效的获取指定类型的消息头的方法还是使用HeaderIterator接口。

```
    HttpResponse response = new BasicHttpResponse(HttpVersion.HTTP_1_1, HttpStatus.SC_OK, "OK");
    response.addHeader("Set-Cookie", "c1=a; path=/; domain=yeetrack.com");
    response.addHeader("Set-Cookie", "c2=b; path=\"/\", c3=c; domain=\"
yeetrack.com
\""); HeaderIterator it = response.headerIterator("Set-Cookie"); while (it.hasNext()) { System.out.println(it.next()); } 
```

上述代码会在控制台输出：

```
    Set-Cookie: c1=a; path=/; domain=yeetrack.com
    Set-Cookie: c2=b; path="/", c3=c; domain="yeetrack.com"
```    
HeaderIterator也提供非常便捷的方式，将Http消息解析成单独的消息头元素。

```
    HttpResponse response = new BasicHttpResponse(HttpVersion.HTTP_1_1, HttpStatus.SC_OK, "OK");
    response.addHeader("Set-Cookie", "c1=a; path=/; domain=yeetrack.com");
    response.addHeader("Set-Cookie", "c2=b; path=\"/\", c3=c; domain=\"yeetrack.com\"");

    HeaderElementIterator it = new BasicHeaderElementIterator(response.headerIterator("Set-Cookie"));

    while (it.hasNext()) {
        HeaderElement elem = it.nextElement(); 
        System.out.println(elem.getName() + " = " + elem.getValue());
        NameValuePair[] params = elem.getParameters();
        for (int i = 0; i < params.length; i++) {
            System.out.println(" " + params[i]);
        }
    }
```    
    	
上述代码会在控制台输出：

```java
    c1 = a
    path=/
    domain=yeetrack.com
    c2 = b
    path=/
    c3 = c
    domain=yeetrack.com
```

###http实体
* Http消息可以携带http实体，这个http实体既可以是http请求，也可以是http响应的。
* Http实体，可以在某些http请求或者响应中发现，但不是必须的。
* Http规范中定义了两种包含请求的方法：POST和PUT。
* HTTP响应一般会包含一个内容实体。
* 当然这条规则也有异常情况，如Head方法的响应，204没有内容，304没有修改或者205内容资源重置。

HttpClient根据来源的不同，划分了三种不同的Http实体内容。

*	streamed: Http内容是通过流来接受或者generated on the fly。特别是，streamed这一类包含从http响应中获取的实体内容。一般说来，streamed实体是不可重复的。
*	self-contained: The content is in memory or obtained by means that are independent from a connection or other entity。self-contained类型的实体内容通常是可重复的。这种类型的实体通常用于关闭http请求。
*	wrapping: 这种类型的内容是从另外的http实体中获取的。

当从Http响应中读取内容时，上面的三种区分对于连接管理器来说是非常重要的。

请求类的实体通常由应用程序创建，由HttpClient发送给服务器，在请求类的实体中，streamed和self-contained两种类型的区别就不重要了。

在这种情况下，一般认为不可重复的实体是streamed类型，可重复的实体时self-contained。

####可重复的实体
一个实体是可重复的，也就是说它的包含的内容可以被多次读取。
这种多次读取只有self contained(自包含)的实体能做到(比如ByteArrayEntity或者StringEntity)。

####使用Http实体
由于一个Http实体既可以表示二进制内容，又可以表示文本内容，所以Http实体要支持字符编码（为了支持后者，即文本内容）。

当需要执行一个完整内容的Http请求或者Http请求已经成功，服务器要发送响应到客户端时，Http实体就会被创建。

如果要从Http实体中读取内容，我们可以利用HttpEntity类的getContent方法来获取实体的输入流(java.io.InputStream),
或者利用HttpEntitiy类的writeTo（OutpuStream）方法来获取输出流，这个方法会吧所有的内容写入到给定的流中。

当实体类已经被接受后，我们可以利用HttpEntity类的getContentType()和getContentLength()方法来读取Content-Type和Content-Length两个头消息（如果有的话）。

由于Content-Type包含mime-types的字符编码，比如text/plain或者text/html,HttpEntity类的getContentEncoding()方法就是读取这个编码的。

如果头信息不存在，getContentLength（）会返回-1,getContentType()会返回NULL。如果Content-Type信息存在，就会返回一个Header类。

当为发送消息创建Http实体时，需要同时附加meta信息。

```
    StringEntity myEntity = new StringEntity("important message", ContentType.create("text/plain", "UTF-8"));
    System.out.println(myEntity.getContentType());
    System.out.println(myEntity.getContentLength());
    System.out.println(EntityUtils.toString(myEntity));
    System.out.println(EntityUtils.toByteArray(myEntity).length);
```    
    
上述代码会在控制台输出：
```   
    Content-Type: text/plain; charset=utf-8
    17
    important message
    17
```
####确保底层的资源连接被释放
为了确保系统资源被正确地释放，我们要么管理Http实体的内容流、要么关闭Http响应。

```
CloseableHttpClient httpclient =  HttpClients.createDefault();
    HttpGet httpget = new HttpGet("http://www.yeetrack.com/");
    CloseableHttpResponse response = httpclient.execute(httpget);
    try {
        HttpEntity entity = response.getEntity();
        if (entity != null) {
            InputStream instream = entity.getContent();
            try {
                // do something useful
            } finally {
                instream.close();
            }
        }
    } finally {
        response.close();
    }
```

关闭Http实体内容流和关闭Http响应的区别在于，前者通过消耗掉Http实体内容来保持相关的http连接，然后后者会立即关闭、丢弃http连接。

请注意HttpEntity的writeTo(OutputStream)方法，当Http实体被写入到OutputStream后，也要确保释放系统资源。如果这个方法内调用了HttpEntity的getContent()方法，那么它会有一个java.io.InpputStream的实例，我们需要在finally中关闭这个流。

但是也有这样的情况，我们只需要获取Http响应内容的一小部分，而获取整个内容并、实现连接的可重复性代价太大，这时我们可以通过关闭响应的方式来关闭内容输入、输出流。

```
 CloseableHttpClient httpclient = HttpClients.createDefault();
    HttpGet httpget = new HttpGet("http://www.yeetrack.com/");
    CloseableHttpResponse response = httpclient.execute(httpget);
    try {
        HttpEntity entity = response.getEntity();
        if (entity != null) {
            InputStream instream = entity.getContent();
            int byteOne = instream.read();
            int byteTwo = instream.read();
            // Do not need the rest
    }
    } finally {
        response.close();
    }

```

上面的代码执行后，连接变得不可用，所有的资源都将被释放。
####消耗HTTP实体内容
HttpClient推荐使用HttpEntity的getConent()方法或者HttpEntity的writeTo(OutputStream)方法来消耗掉Http实体内容。

HttpClient也提供了EntityUtils这个类，这个类提供一些静态方法可以更容易地读取Http实体的内容和信息，和以java.io.InputStream流读取内容的方式相比，EntityUtils提供的方法可以以字符串或者字节数组的形式读取Http实体。
但是，强烈不推荐使用EntityUtils这个类，除非目标服务器发出的响应是可信任的，并且http响应实体的长度不会过大。

```
CloseableHttpClient httpclient = HttpClients.createDefault();
    HttpGet httpget = new HttpGet("http://www.yeetrack.com/");
    CloseableHttpResponse response = httpclient.execute(httpget);
    try {
        HttpEntity entity = response.getEntity();
        if (entity != null) {
            long len = entity.getContentLength();
            if (len != -1 && len < 2048) {
                System.out.println(EntityUtils.toString(entity));
            } else {
                // Stream content out
            }
        }
    } finally {
        response.close();
    }
```


有些情况下，我们希望可以重复读取Http实体的内容。这就需要把Http实体内容缓存在内存或者磁盘上。最简单的方法就是把Http Entity转化成BufferedHttpEntity，这样就把原Http实体的内容缓冲到了内存中。后面我们就可以重复读取BufferedHttpEntity中的内容。

```
CloseableHttpResponse response = <...>
    HttpEntity entity = response.getEntity();
    if (entity != null) {
        entity = new BufferedHttpEntity(entity);
    }

```

####创建HTTP实体内容

HttpClient提供了一个类，这些类可以通过http连接高效地输出Http实体内容。（原文是HttpClient provides several classes that can be used to efficiently stream out content though HTTP connections.感觉thought应该是throught）HttpClient提供的这几个类涵盖的常见的数据类型，如String，byte数组，输入流，和文件类型：StringEntity,ByteArrayEntity,InputStreamEntity,FileEntity。

```
 File file = new File("somefile.txt");
    FileEntity entity = new FileEntity(file, ContentType.create("text/plain", "UTF-8"));

    HttpPost httppost = new HttpPost("http://www.yeetrack.com/action.do");
    httppost.setEntity(entity);
```

请注意由于InputStreamEntity只能从下层的数据流中读取一次，所以它是不能重复的。推荐，通过继承HttpEntity这个自包含的类来自定义HttpEntity类，而不是直接使用InputStreamEntity这个类。FileEntity就是一个很好的起点（FileEntity就是继承的HttpEntity）。

#### HTML表单

很多应用程序需要模拟提交Html表单的过程，举个例子，登陆一个网站或者将输入内容提交给服务器。HttpClient提供了UrlEncodedFormEntity这个类来帮助实现这一过程。

```
    List<NameValuePair> formparams = new ArrayList<NameValuePair>();
    formparams.add(new BasicNameValuePair("param1", "value1"));
    formparams.add(new BasicNameValuePair("param2", "value2"));
    UrlEncodedFormEntity entity = new UrlEncodedFormEntity(formparams, Consts.UTF_8);
    HttpPost httppost = new HttpPost("http://www.yeetrack.com/handler.do");
    httppost.setEntity(entity);
```
UrlEncodedFormEntity实例会使用所谓的Url编码的方式对我们的参数进行编码，产生的结果如下：

```
    param1=value1&param2=value2
```

####内容分块
一般来说，推荐让HttpClient自己根据Http消息传递的特征来选择最合适的传输编码。当然，如果非要手动控制也是可以的，可以通过设置HttpEntity的setChunked()为true。请注意：HttpClient仅会将这个参数看成是一个建议。如果Http的版本（如http 1.0)不支持内容分块，那么这个参数就会被忽略。

```
    StringEntity entity = new StringEntity("important message",
    ContentType.create("plain/text", Consts.UTF_8));
    entity.setChunked(true);
    HttpPost httppost = new HttpPost("http://www.yeetrack.com/acrtion.do");
    httppost.setEntity(entity);
```

####RESPONSE HANDLERS

最简单也是最方便的处理http响应的方法就是使用ResponseHandler接口，这个接口中有handleResponse(HttpResponse response)方法。使用这个方法，用户完全不用关心http连接管理器。当使用ResponseHandler时，HttpClient会自动地将Http连接释放给Http管理器，即使http请求失败了或者抛出了异常。

```
 CloseableHttpClient httpclient = HttpClients.createDefault();
    HttpGet httpget = new HttpGet("http://www.yeetrack.com/json");

    ResponseHandler<MyJsonObject> rh = new ResponseHandler<MyJsonObject>() {

        @Override
        public JsonObject handleResponse(
            final HttpResponse response) throws IOException {
            StatusLine statusLine = response.getStatusLine();
            HttpEntity entity = response.getEntity();
            if (statusLine.getStatusCode() >= 300) {
                throw new HttpResponseException(
                        statusLine.getStatusCode(),
                        statusLine.getReasonPhrase());
            }
            if (entity == null) {
                throw new ClientProtocolException("Response contains no content");
            }
            Gson gson = new GsonBuilder().create();
            ContentType contentType = ContentType.getOrDefault(entity);
            Charset charset = contentType.getCharset();
            Reader reader = new InputStreamReader(entity.getContent(), charset);
            return gson.fromJson(reader, MyJsonObject.class);
        }
    };
    //设置responseHandler，当执行http方法时，就会返回MyJsonObject对象。
    MyJsonObject myjson = client.execute(httpget, rh);

```

###HttpClient接口
对于Http请求执行过程来说，HttpClient的接口有着必不可少的作用。
HttpClient接口没有对Http请求的过程做特别的限制和详细的规定，连接管理、状态管理、授权信息和重定向处理这些功能都单独实现。
这样用户就可以更简单地拓展接口的功能（比如缓存响应内容）。
一般说来，HttpClient实际上就是一系列特殊的handler或者说策略接口的实现，这些handler（测试接口）负责着处理Http协议的某一方面，比如重定向、认证处理、有关连接持久性和keep alive持续时间的决策。这样就允许用户使用自定义的参数来代替默认配置，实现个性化的功能。

```
    ConnectionKeepAliveStrategy keepAliveStrat = new DefaultConnectionKeepAliveStrategy() {

        @Override
        public long getKeepAliveDuration(
            HttpResponse response,
            HttpContext context) {
                long keepAlive = super.getKeepAliveDuration(response, context);
                if (keepAlive == -1) {
                    //如果服务器没有设置keep-alive这个参数，我们就把它设置成5秒
                    keepAlive = 5000;
                }
                return keepAlive;
        }

    };
    //定制我们自己的httpclient
    CloseableHttpClient httpclient = HttpClients.custom()
            .setKeepAliveStrategy(keepAliveStrat)
            .build();
```
####HTTPCLIENT的线程安全性
HttpClient已经实现了线程安全。所以希望用户在实例化HttpClient时，也要支持为多个请求使用。

1.2.2.HTTPCLIENT的内存分配
当一个CloseableHttpClient的实例不再被使用，并且它的作用范围即将失效，和它相关的连接必须被关闭，关闭方法可以调用CloseableHttpClient的close()方法。

```
    CloseableHttpClient httpclient = HttpClients.createDefault();
    try {
        <...>
    } finally {
        //关闭连接
        httpclient.close();
    }
```
###Http执行上下文
最初，Http被设计成一种无状态的、面向请求-响应的协议。
然而，在实际使用中，我们希望能够在一些逻辑相关的请求-响应中，保持状态信息。为了使应用程序可以保持Http的持续状态，

HttpClient允许http连接在特定的Http上下文中执行。

如果在持续的http请求中使用了同样的上下文，那么这些请求就可以被分配到一个逻辑会话中。

HTTP上下文就和一个java.util.Map<String, Object>功能类似。

它实际上就是一个任意命名的值的集合。应用程序可以在Http请求执行前填充上下文的值，也可以在请求执行完毕后检查上下文。

HttpContext可以包含任意类型的对象，因此如果在多线程中共享上下文会不安全。推荐每个线程都只包含自己的http上下文。

在Http请求执行的过程中，HttpClient会自动添加下面的属性到Http上下文中：

*	HttpConnection的实例，表示客户端与服务器之间的连接
*	HttpHost的实例，表示要连接的木包服务器
*	HttpRoute的实例，表示全部的连接路由
*	HttpRequest的实例，表示Http请求。在执行上下文中，最终的HttpRequest对象会代表http消息的状态。Http/1.0和Http/1.1都默认使用相对的uri。但是如果使用了非隧道模式的代理服务器，就会使用绝对路径的uri。
*	HttpResponse的实例，表示Http响应
*	java.lang.Boolean对象，表示是否请求被成功的发送给目标服务器
*	RequestConfig对象，表示http request的配置信息
*	java.util.List<Uri>对象，表示Http响应中的所有重定向地址

我们可以使用HttpClientContext这个适配器来简化和上下文交互的过程。

```java
 HttpContext context = <...>
    HttpClientContext clientContext = HttpClientContext.adapt(context);
    HttpHost target = clientContext.getTargetHost();
    HttpRequest request = clientContext.getRequest();
    HttpResponse response = clientContext.getResponse();
    RequestConfig config = clientContext.getRequestConfig();
```

同一个逻辑会话中的多个Http请求，应该适用相同的Http上下文来执行，这样就可以自动地在Htpp请求中传递会话上下文和状态信息。

在下面的例子中，我们在开头设置的参数，会被保存在上下文中，并且会应用到后续的http请求中（源英文中有个拼写错误）

```
    CloseableHttpClient httpclient = HttpClients.createDefault();
    RequestConfig requestConfig = RequestConfig.custom()
            .setSocketTimeout(1000)
            .setConnectTimeout(1000)
            .build();

    HttpGet httpget1 = new HttpGet("http://www.yeetrack.com/1");
    httpget1.setConfig(requestConfig);
    CloseableHttpResponse response1 = httpclient.execute(httpget1, context);
    try {
        HttpEntity entity1 = response1.getEntity();
    } finally {
        response1.close();
    }
    //httpget2被执行时，也会使用httpget1的上下文
    HttpGet httpget2 = new HttpGet("http://www.yeetrack.com/2");
    CloseableHttpResponse response2 = httpclient.execute(httpget2, context);
    try {
        HttpEntity entity2 = response2.getEntity();
    } finally {
        response2.close();
    }
```
###异常处理
HttpClient会被抛出两种类型的异常

* 一种是java.io.IOException，当遇到I/O异常时抛出（socket超时，或者socket被重置）;
* 另一种是HttpException,表示Http失败，如Http协议使用不正确。通常认为，I/O错误时不致命、可修复的，而Http协议错误是致命了，不能自动修复的错误。

####HTTP传输安全
Http协议不能满足所有类型的应用场景，我们需要知道这点。

Http是个简单的面向协议的请求/响应的协议，当初它被设计用来支持静态或者动态生成的内容检索，之前从来没有人想过让它支持事务性操作。

例如，Http服务器成功接收、处理请求后，生成响应消息，并且把状态码发送给客户端，这个过程是Http协议应该保证的。

但是，如果客户端由于读取超时、取消请求或者系统崩溃导致接收响应失败，服务器不会回滚这一事务。

如果客户端重新发送这个请求，服务器就会重复的解析、执行这个事务。

在一些情况下，这会导致应用程序的数据损坏和应用程序的状态不一致。

即使Http当初设计是不支持事务操作，但是它仍旧可以作为传输协议为某些关键程序提供服务。为了保证Http传输层的安全性，系统必须保证应用层上的http方法的幂等性（To ensure HTTP transport layer safety the system must ensure the idempotency of HTTP methods on the application layer）。

####方法的幂等性
HTTP/1.1规范中是这样定义幂等方法的
Methods can also have the property of “idempotence” in that (aside from error or expiration issues) the side-effects of N > 0 identical requests is the same as for a single request。

用其他话来说，应用程序需要正确地处理同一方法多次执行造成的影响。

添加一个具有唯一性的id就能避免重复执行同一个逻辑请求，问题解决。

请知晓，这个问题不只是HttpClient才会有，基于浏览器的应用程序也会遇到Http方法不幂等的问题。

HttpClient默认把非实体方法get、head方法看做幂等方法，把实体方法post、put方法看做非幂等方法。

####异常自动修复
默认情况下，HttpClient会尝试自动修复I/O异常。这种自动修复仅限于修复几个公认安全的异常。

* HttpClient不会尝试修复任何逻辑或者http协议错误（即从HttpException衍生出来的异常）。
* HttpClient会自动再次发送幂等的方法（如果首次执行失败。
* HttpClient会自动再次发送遇到transport异常的方法，前提是Http请求仍旧保持着连接（例如http请求没有全部发送给目标服务器，HttpClient会再次尝试发送）。
####请求重试HANDLER
如果要自定义异常处理机制，我们需要实现HttpRequestRetryHandler接口。

```
    HttpRequestRetryHandler myRetryHandler = new HttpRequestRetryHandler() {

        public boolean retryRequest(
                IOException exception,
                int executionCount,
                HttpContext context) {
            if (executionCount >= 5) {
                // 如果已经重试了5次，就放弃
                return false;
            }
            if (exception instanceof InterruptedIOException) {
                // 超时
                return false;
            }
            if (exception instanceof UnknownHostException) {
                // 目标服务器不可达
                return false;
            }
            if (exception instanceof ConnectTimeoutException) {
                // 连接被拒绝
                return false;
            }
            if (exception instanceof SSLException) {
                // ssl握手异常
                return false;
            }
            HttpClientContext clientContext = HttpClientContext.adapt(context);
            HttpRequest request = clientContext.getRequest();
            boolean idempotent = !(request instanceof HttpEntityEnclosingRequest);
            if (idempotent) {
                // 如果请求是幂等的，就再次尝试
                return true;
            }
            return false;
        }

    };  
    CloseableHttpClient httpclient = HttpClients.custom()
            .setRetryHandler(myRetryHandler)
            .build();
```

###终止请求
有时候由于目标服务器负载过高或者客户端目前有太多请求积压，http请求不能在指定时间内执行完毕。

这时候终止这个请求，释放阻塞I/O的进程，就显得很必要。

通过HttpClient执行的Http请求，在任何状态下都能通过调用HttpUriRequest的abort()方法来终止。

这个方法是线程安全的，并且能在任何线程中调用。

当Http请求被终止了，本线程（即使现在正在阻塞I/O）也会通过抛出一个InterruptedIOException异常，来释放资源。

###Http协议拦截器
HTTP协议拦截器是一种实现一个特定的方面的HTTP协议的代码程序。

通常情况下，协议拦截器会将一个或多个头消息加入到接受或者发送的消息中。

协议拦截器也可以操作消息的内容实体—消息内容的压缩/解压缩就是个很好的例子。

通常，这是通过使用“装饰”开发模式，一个包装实体类用于装饰原来的实体来实现。

一个拦截器可以合并，形成一个逻辑单元。

协议拦截器可以通过共享信息协作——比如处理状态——通过HTTP执行上下文。

协议拦截器可以使用Http上下文存储一个或者多个连续请求的处理状态。

通常，只要拦截器不依赖于一个特定状态的http上下文，那么拦截执行的顺序就无所谓。如果协议拦截器有相互依赖关系，必须以特定的顺序执行，那么它们应该按照特定的顺序加入到协议处理器中。

协议处理器必须是线程安全的。类似于servlets，协议拦截器不应该使用变量实体，除非访问这些变量是同步的（线程安全的）。

下面是个例子，讲述了本地的上下文时如何在连续请求中记录处理状态的：

```
    CloseableHttpClient httpclient = HttpClients.custom()
            .addInterceptorLast(new HttpRequestInterceptor() {

                public void process(
                        final HttpRequest request,
                        final HttpContext context) throws HttpException, IOException {
                        //AtomicInteger是个线程安全的整型类
                    AtomicInteger count = (AtomicInteger) context.getAttribute("count");
                    request.addHeader("Count", Integer.toString(count.getAndIncrement()));
                }

            })
            .build();

    AtomicInteger count = new AtomicInteger(1);
    HttpClientContext localContext = HttpClientContext.create();
    localContext.setAttribute("count", count);

    HttpGet httpget = new HttpGet("http://www.yeetrack.com/");
    for (int i = 0; i < 10; i++) {
        CloseableHttpResponse response = httpclient.execute(httpget, localContext);
        try {
            HttpEntity entity = response.getEntity();
        } finally {
            response.close();
        }
    }
```    
上面代码在发送http请求时，会自动添加Count这个header，可以使用wireshark抓包查看。

###重定向处理
HttpClient会自动处理所有类型的重定向，除了那些Http规范明确禁止的重定向。
See Other (status code 303) redirects on POST and PUT requests are converted to GET requests as required by the HTTP specification. 我们可以使用自定义的重定向策略来放松Http规范对Post方法重定向的限制。

```
    //LaxRedirectStrategy可以自动重定向所有的HEAD，GET，POST请求，解除了http规范对post请求重定向的限制。 
    LaxRedirectStrategy redirectStrategy = new LaxRedirectStrategy();
    CloseableHttpClient httpclient = HttpClients.custom()
            .setRedirectStrategy(redirectStrategy)
            .build();
```
  
HttpClient在请求执行过程中，经常需要重写请求的消息。 HTTP/1.0和HTTP/1.1都默认使用相对的uri路径。

同样，原始的请求可能会被一次或者多次的重定向。

最终结对路径的解释可以使用最初的请求和上下文。URIUtils类的resolve方法可以用于将拦截的绝对路径构建成最终的请求。

这个方法包含了最后一个分片标识符或者原始请求。

```
    CloseableHttpClient httpclient = HttpClients.createDefault();
    HttpClientContext context = HttpClientContext.create();
    HttpGet httpget = new HttpGet("http://www.yeetrack.com:8080/");
    CloseableHttpResponse response = httpclient.execute(httpget, context);
    try {
        HttpHost target = context.getTargetHost();
        List<URI> redirectLocations = context.getRedirectLocations();
        URI location = URIUtils.resolve(httpget.getURI(), target, redirectLocations);
        System.out.println("Final HTTP location: " + location.toASCIIString());
        // 一般会取得一个绝对路径的uri
    } finally {
        response.close();
    }
```

###转载
转载自http://free0007.iteye.com/blog/2012244

