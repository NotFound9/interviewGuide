(PS：扫描[首页里面的二维码](README.md)进群，分享我自己在看的技术资料给大家，希望和大家一起学习进步！)

#### [1.nginx负载均衡算法有哪些？](#nginx负载均衡算法有哪些？)
#### [2. 一致性hash是什么？](# 一致性hash是什么？)

### nginx负载均衡算法有哪些？
##### 1、轮询（默认）

每个请求按时间顺序逐一分配到不同的后端服务，如果后端某台服务器死机，自动剔除故障系统，使用户访问不受影响。

例如：
```
upstream bakend {  
    server 192.168.0.1;    
    server 192.168.0.2;  
}
```
##### 2、weight（根据权值分配）

weight的值越大分配到的访问概率越高，主要用于后端每台服务器性能不均衡的情况下。或者仅仅为在主从的情况下设置不同的权值，达到合理有效的地利用主机资源。

指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况。
例如：
```
upstream bakend {  
    server 192.168.0.1 weight=10;  
    server 192.168.0.2 weight=10;  
}
```
##### 3、ip_hash（根据ip地址分配）

每个请求按访问IP的哈希结果分配，使来自同一个IP的访客固定访问一台后端服务器，并且可以有效解决动态网页存在的session共享问题。

每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题。
例如：
```
upstream bakend {  
    ip_hash;  
    server 192.168.0.1:88;  
    server 192.168.0.2:80;  
} 
```
##### 4、fair（优先分配给响应时间段的服务器）

比 weight、ip_hash更加智能的负载均衡算法，fair算法可以根据页面大小和加载时间长短智能地进行负载均衡，也就是根据后端服务器的响应时间来分配请求，响应时间短的优先分配。Nginx本身不支持fair，如果需要这种调度算法，则必须安装upstream_fair模块。

按后端服务器的响应时间来分配请求，响应时间短的优先分配。
例如：
```
upstream backend {  
    server 192.168.0.1:88;  
    server 192.168.0.2:80;  
    fair;  
}
```
##### 5、url_hash（根据url分配）

按访问的URL的哈希结果来分配请求，使每个URL定向到一台后端服务器，可以进一步提高后端缓存服务器的效率。Nginx本身不支持url_hash，如果需要这种调度算法，则必须安装Nginx的hash软件包。

按访问url的hash结果来分配请求，使每个url定向到同一个后端服务器，后端服务器为缓存时比较有效。

注意：在upstream中加入hash语句，server语句中不能写入weight等其他的参数，hash_method是使用的hash算法。

例如：
```
upstream backend {  
    server 192.168.0.1:88;  
    server 192.168.0.2:80;  
    hash $request_uri;  
    hash_method crc32;  
}
```

### 一致性hash是什么？

nginx 普通的hash算法支持配置http变量值（例如url或者请求参数）作为hash值计算的key，通过hash计算得出的hash值和总权重的余数作为挑选server的依据。缺点是

1.可能对于给后端服务器分配请求时分配得不均匀，有的upstream server负载很低，有的upstream server负载较高。

2.增加或者减少upstream server后，所有的请求可能分配的upstream server会发生变化，跟之前不同。

所以有了一致性hash，一致性hash就是创建出n个虚拟节点，n个虚拟节点构成一个环，从n个虚拟节点中，挑选出一些节点当成真实的upstream server节点。构成一个每次将计算得到的hash%n，得到请求分配的虚拟节点的位置c，从位置c顺时针移动，获得离c最近的真实upstream server节点。

这样请求分配时就会比较均匀，而且upstream server的数量变化只会影响计算出key值hash与其”最近”的预分配的虚拟节点。

![这里写图片描述](../static/SouthEast.png)

```bash
upstream somestream {
    consistent_hash $request_uri;
    server 10.50.1.3:11211;
    server 10.50.1.4:11211;
    server 10.50.1.5:11211;
}
```

