[toc]

# Http认证

HttpClient既支持HTTP标准规范定义的认证模式，又支持一些广泛使用的非标准认证模式，比如NTLM和SPNEGO。

## 用户凭证

任何用户认证的过程，都需要一系列的凭证来确定用户的身份。最简单的用户凭证可以是用户名和密码这种形式。UsernamePasswordCredentials这个类可以用来表示这种情况，这种凭据包含明文的用户名和密码。

这个类对于HTTP标准规范中定义的认证模式来说已经足够了。
```
UsernamePasswordCredentials creds = new UsernamePasswordCredentials("user", "pwd");
    System.out.println(creds.getUserPrincipal().getName());
    System.out.println(creds.getPassword());

```

上述代码会在控制台输出：

```
user
pwd
```

NTCredentials是微软的windows系统使用的一种凭据，包含username、password，还包括一系列其他的属性，比如用户所在的域名。在Microsoft Windows的网络环境中，同一个用户可以属于不同的域，所以他也就有不同的凭据。

```
NTCredentials creds = new NTCredentials("user", "pwd", "workstation", "domain");
    System.out.println(creds.getUserPrincipal().getName());
    System.out.println(creds.getPassword());
```

上述代码输出：
```
DOMAIN/user
    pwd
```

## 认证方案
AutoScheme接口表示一个抽象的面向挑战/响应的认证方案。一个认证方案要支持下面的功能：

* 客户端请求服务器受保护的资源，服务器会发送过来一个chanllenge(挑战），认证方案（Authentication scheme）需要解析、处理这个挑战
*	为processed challenge提供一些属性值：认证方案的类型，和此方案需要的一些参数，这种方案适用的范围
*	使用给定的授权信息生成授权字符串;生成http请求，用来响应服务器发送来过的授权challenge

请注意：一个认证方案可能是有状态的，因为它可能涉及到一系列的挑战/响应。
HttpClient实现了下面几种AutoScheme:

* 	Basic: Basic认证方案是在RFC2617号文档中定义的。这种授权方案用明文来传输凭证信息，所以它是不安全的。虽然Basic认证方案本身是不安全的，但是它一旦和TLS/SSL加密技术结合起来使用，就完全足够了。
* Digest: Digest（摘要）认证方案是在RFC2617号文档中定义的。Digest认证方案比Basic方案安全多了，对于那些受不了Basic+TLS/SSL传输开销的系统，digest方案是个不错的选择。
* NTLM: NTLM认证方案是个专有的认证方案，由微软开发，并且针对windows平台做了优化。NTLM被认为比Digest更安全。
* SPNEGO: SPNEGO(Simple and Protected GSSAPI Negotiation Mechanism)是GSSAPI的一个“伪机制”，它用来协商真正的认证机制。SPNEGO最明显的用途是在微软的HTTP协商认证机制拓展上。可协商的子机制包括NTLM、Kerberos。目前，HttpCLient只支持Kerberos机制。（原文：The negotiable sub-mechanisms include NTLM and Kerberos supported by Active Directory. At present HttpClient only supports the Kerberos sub-mechanism.）

## 凭证 provider

凭证providers旨在维护一套用户的凭证，当需要某种特定的凭证时，providers就应该能产生这种凭证。认证的具体内容包括主机名、端口号、realm name和认证方案名。当使用凭据provider的时候，我们可以很模糊的指定主机名、端口号、realm和认证方案，不用写的很精确。因为，凭据provider会根据我们指定的内容，筛选出一个最匹配的方案。
只要我们自定义的凭据provider实现了CredentialsProvider这个接口，就可以在HttpClient中使用。默认的凭据provider叫做BasicCredentialsProvider，它使用java.util.HashMap对CredentialsProvider进行了简单的实现。

```
CredentialsProvider credsProvider = new BasicCredentialsProvider();
    credsProvider.setCredentials(
        new AuthScope("somehost", AuthScope.ANY_PORT), 
        new UsernamePasswordCredentials("u1", "p1"));
    credsProvider.setCredentials(
        new AuthScope("somehost", 8080), 
        new UsernamePasswordCredentials("u2", "p2"));
    credsProvider.setCredentials(
        new AuthScope("otherhost", 8080, AuthScope.ANY_REALM, "ntlm"), 
        new UsernamePasswordCredentials("u3", "p3"));

    System.out.println(credsProvider.getCredentials(
        new AuthScope("somehost", 80, "realm", "basic")));
    System.out.println(credsProvider.getCredentials(
        new AuthScope("somehost", 8080, "realm", "basic")));
    System.out.println(credsProvider.getCredentials(
        new AuthScope("otherhost", 8080, "realm", "basic")));
    System.out.println(credsProvider.getCredentials(
        new AuthScope("otherhost", 8080, null, "ntlm")));
##上面代码输出：
    [principal: u1]
    [principal: u2]
    null
    [principal: u3]

```

## HTTP授权和执行上下文

HttpClient依赖AuthState类去跟踪认证过程中的状态的详细信息。在Http请求过程中，HttpClient创建两个AuthState实例：一个用于目标服务器认证，一个用于代理服务器认证。如果服务器或者代理服务器需要用户的授权信息，AuthScope、AutoScheme和认证信息就会被填充到两个AuthScope实例中。通过对AutoState的检测，我们可以确定请求的授权类型，确定是否有匹配的AuthScheme，确定凭据provider根据指定的授权类型是否成功生成了用户的授权信息。
在Http请求执行过程中，HttpClient会向执行上下文中添加下面的授权对象：

* 	Lookup对象，表示使用的认证方案。这个对象的值可以在本地上下文中进行设置，来覆盖默认值。
*	CredentialsProvider对象，表示认证方案provider，这个对象的值可以在本地上下文中进行设置，来覆盖默认值。
*	AuthState对象，表示目标服务器的认证状态，这个对象的值可以在本地上下文中进行设置，来覆盖默认值。
*	AuthCache对象，表示认证数据的缓存，这个对象的值可以在本地上下文中进行设置，来覆盖默认值。

我们可以在请求执行前，自定义本地HttpContext对象来设置需要的http认证上下文;也可以在请求执行后，再检测HttpContext的状态，来查看授权是否成功。

```
CloseableHttpClient httpclient = <...>

    CredentialsProvider credsProvider = <...>
    Lookup<AuthSchemeProvider> authRegistry = <...>
    AuthCache authCache = <...>

    HttpClientContext context = HttpClientContext.create();
    context.setCredentialsProvider(credsProvider);
    context.setAuthSchemeRegistry(authRegistry);
    context.setAuthCache(authCache);
    HttpGet httpget = new HttpGet("http://www.yeetrack.com/");
    CloseableHttpResponse response1 = httpclient.execute(httpget, context);
    <...>

    AuthState proxyAuthState = context.getProxyAuthState();
    System.out.println("Proxy auth state: " + proxyAuthState.getState());
    System.out.println("Proxy auth scheme: " + proxyAuthState.getAuthScheme());
    System.out.println("Proxy auth credentials: " + proxyAuthState.getCredentials());
    AuthState targetAuthState = context.getTargetAuthState();
    System.out.println("Target auth state: " + targetAuthState.getState());
    System.out.println("Target auth scheme: " + targetAuthState.getAuthScheme());
    System.out.println("Target auth credentials: " + targetAuthState.getCredentials());
```

## 缓存认证数据

从版本4.1开始，HttpClient就会自动缓存验证通过的认证信息。但是为了使用这个缓存的认证信息，我们必须在同一个上下文中执行逻辑相关的请求。一旦超出该上下文的作用范围，缓存的认证信息就会失效。

## 抢先认证

HttpClient默认不支持抢先认证，因为一旦抢先认证被误用或者错用，会导致一系列的安全问题，比如会把用户的认证信息以明文的方式发送给未授权的第三方服务器。因此，需要用户自己根据自己应用的具体环境来评估抢先认证带来的好处和带来的风险。
即使如此，HttpClient还是允许我们通过配置来启用抢先认证，方法是提前填充认证信息缓存到上下文中，这样，以这个上下文执行的方法，就会使用抢先认证。

```
    CloseableHttpClient httpclient = <...>

    HttpHost targetHost = new HttpHost("localhost", 80, "http");
    CredentialsProvider credsProvider = new BasicCredentialsProvider();
    credsProvider.setCredentials(
            new AuthScope(targetHost.getHostName(), targetHost.getPort()),
            new UsernamePasswordCredentials("username", "password"));

    // 创建 AuthCache 对象
    AuthCache authCache = new BasicAuthCache();
    //创建 BasicScheme，并把它添加到 auth cache中
    BasicScheme basicAuth = new BasicScheme();
    authCache.put(targetHost, basicAuth);

    // 把AutoCache添加到上下文中
    HttpClientContext context = HttpClientContext.create();
    context.setCredentialsProvider(credsProvider);

    HttpGet httpget = new HttpGet("/");
    for (int i = 0; i < 3; i++) {
        CloseableHttpResponse response = httpclient.execute(
                targetHost, httpget, context);
        try {
            HttpEntity entity = response.getEntity();

        } finally {
            response.close();
        }
    }

```

## NTLM认证

从版本4.1开始，HttpClient就全面支持NTLMv1、NTLMv2和NTLM2认证。当人我们可以仍旧使用外部的NTLM引擎（比如Samba开发的JCIFS库）作为与Windows互操作性程序的一部分。

### NTLM连接持久性

相比Basic和Digest认证，NTLM认证要明显需要更多的计算开销，性能影响也比较大。这也可能是微软把NTLM协议设计成有状态连接的主要原因之一。也就是说，NTLM连接一旦建立，用户的身份就会在其整个生命周期和它相关联。NTLM连接的状态性使得连接持久性更加复杂，The stateful nature of NTLM connections makes connection persistence more complex, as for the obvious reason persistent NTLM connections may not be re-used by users with a different user identity. HttpClient中标准的连接管理器就可以管理有状态的连接。但是，同一会话中逻辑相关的请求，必须使用相同的执行上下文，这样才能使用用户的身份信息。否则，HttpClient就会结束旧的连接，为了获取被NTLM协议保护的资源，而为每个HTTP请求，创建一个新的Http连接。更新关于Http状态连接的信息，点击此处。

由于NTLM连接是有状态的，一般推荐使用比较轻量级的方法来处罚NTLM认证（如GET、Head方法），然后使用这个已经建立的连接在执行相对重量级的方法，尤其是需要附件请求实体的请求（如POST、PUT请求）。

```
CloseableHttpClient httpclient = <...>

    CredentialsProvider credsProvider = new BasicCredentialsProvider();
    credsProvider.setCredentials(AuthScope.ANY,
            new NTCredentials("user", "pwd", "myworkstation", "microsoft.com"));

    HttpHost target = new HttpHost("www.microsoft.com", 80, "http");

    //使用相同的上下文来执行逻辑相关的请求
    HttpClientContext context = HttpClientContext.create();
    context.setCredentialsProvider(credsProvider);

    //使用轻量级的请求来触发NTLM认证
    HttpGet httpget = new HttpGet("/ntlm-protected/info");
    CloseableHttpResponse response1 = httpclient.execute(target, httpget, context);
    try {
        HttpEntity entity1 = response1.getEntity();
    } finally {
        response1.close();
    }

    //使用相同的上下文，执行重量级的方法
    HttpPost httppost = new HttpPost("/ntlm-protected/form");
    httppost.setEntity(new StringEntity("lots and lots of data"));
    CloseableHttpResponse response2 = httpclient.execute(target, httppost, context);
    try {
        HttpEntity entity2 = response2.getEntity();
    } finally {
        response2.close();
    }
```

转载自 http://free0007.iteye.com/blog/2012311

