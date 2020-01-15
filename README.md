《面试指北》Github地址：https://github.com/NotFound9/interviewGuide

《面试指北》最佳阅读地址：http://notfound9.github.io/interviewGuide/

 作者博客地址：https://juejin.im/user/5b370a42e51d4558ce5eb969

## 为什么要做这个开源项目？

我就是个普通的程序员，只是喜欢在空闲时看一些技术书籍，但是发现看完后，即便每一章都写了读书笔记，看到一些相关的面试题时，自己还是一脸茫然，所以我认为学习一项技术分为三个阶段：

1.看过入门教程，会用API。

2.看过相关的技术书籍，了解一部分原理。

3.能够对面试题进行分析，做出正确的解答，这样才能对技术有较为深入的理解，在工作中遇到复杂问题时，才能解决。

所以我发起了这个项目，
* 一方面是督促自己学习。
* 一方面是将这些面试题整理后，写完解答后分享给大家，希望可以帮助到大家，也欢迎大家一起来完善这个项目，为开源做贡献。为了方便交流，也建了一个技术交流群，欢迎大家扫码加入！会分享一些我自己在看的一些技术资料给大家！同时也希望大家给这个开源项目点一个Star，谢谢大家了!

<img src="static/chatGroupCode.jpeg" width="30%" padding-left= "20%" />

## 目录

- [首页](README.md)
* Java
  - [基础](docs/JavaBasic.md)
    - [1.Java中的多态是什么？](docs/JavaBasic.md#Java中的多态是什么？)
    - [2.Java中变量，代码块，构造器之间执行顺序是怎么样的？](docs/JavaBasic.md#java中变量，代码块，构造器之间执行顺序是怎么样的？)
    - [3.final关键字有哪些作用？](docs/JavaBasic.md#final关键字有哪些作用？)
    - [4.Integer类会进行缓存吗？](docs/JavaBasic.md#Integer类会进行缓存吗？)
    - [5.抽象类有哪些特点？](docs/JavaBasic.md#抽象类有哪些特点？)
    - [6.String，StringBuffer和StringBuilder之间的区别是什么？](docs/JavaBasic.md#String，StringBuffer和StringBuilder之间的区别是什么？)
    - [7.编译型编程语言，解释型编程语言，伪编译型语言的区别是什么？](docs/JavaBasic.md#编译型编程语言，解释型编程语言，伪编译型语言的区别是什么？)
    - [8.Java中的访问控制符有哪些？](docs/JavaBasic.md#Java中的访问控制符有哪些？)
    - [9.Java的构造器有哪些特点？](docs/JavaBasic.md#Java的构造器有哪些特点？)
    - [10.Java中的内部类是怎么样的？](docs/JavaBasic.md#Java中的内部类是怎么样的？)
  * 容器
    - [ArrayList和LinkedList](docs/ArrayList.md)
      -  [1.ArrayList与LinkedList的区别是什么？](docs/ArrayList.md#ArrayList与LinkedList的区别是什么？)
      - [2.怎么使ArrayList，LinkedList变成线程安全的呢？](docs/ArrayList.md#怎么使ArrayList，LinkedList变成线程安全的呢？)
      - [3.ArrayList遍历时删除元素有哪些方法？](docs/ArrayList.md#ArrayList遍历时删除元素有哪些方法？)
      - [4.ConcurrentModificationException是什么？](docs/ArrayList.md#ConcurrentModificationException是什么？)
      - [5.java容器类的层次是怎么样的？](docs/ArrayList.md#java容器类的层次是怎么样的？)
    - [HashMap和ConcurrentHashMap](docs/HashMap.md)
      - [1.HashMap添加一个键值对的过程是怎么样的？](docs/HashMap.md.md#HashMap添加一个键值对的过程是怎么样的？)
      - [2.ConcurrentHashMap添加一个键值对的过程是怎么样的？](docs/HashMap.md.md#ConcurrentHashMap添加一个键值对的过程是怎么样的？)
      - [3.HashMap与HashTable，ConcurrentHashMap的区别是什么？](docs/HashMap.md.md#HashMap与HashTable，ConcurrentHashMap的区别是什么？)
      - [4.HashMap扩容后是否需要rehash？](docs/HashMap.md.md#HashMap扩容后是否需要rehash？)
      - [5.HashMap扩容是怎样扩容的，为什么都是2的N次幂的大小？](docs/HashMap.md.md#HashMap扩容是怎样扩容的，为什么都是2的N次幂的大小？)
      - [6.ConcurrentHashMap是怎么记录元素个数size的？](docs/HashMap.md.md#ConcurrentHashMap是怎么记录元素个数size的？)
      - [7.为什么ConcurrentHashMap，HashTable不支持key，value为null?](docs/HashMap.md.md#为什么ConcurrentHashMap，HashTable不支持key，value为null?)
      - [8.HashSet和HashMap的区别？](docs/HashMap.md.md#HashSet和HashMap的区别？ )
      - [9.HashMap遍历时删除元素的有哪些实现方法？](docs/HashMap.md.md#HashMap遍历时删除元素的有哪些实现方法？)
  - [多线程](docs/JavaMultiThread.md)
    - [1.进程与线程的区别是什么？](docs/JavaMultiThread.md#进程与线程的区别是什么？)
    - [2.Java中单例有哪些写法？](docs/JavaMultiThread.md#Java中单例有哪些写法？)
    - [3.Java中创建线程有哪些方式?](docs/JavaMultiThread.md#Java中创建线程有哪些方式?)
    - [4.如何解决序列化时可以创建出单例对象的问题?](docs/JavaMultiThread.md#如何解决序列化时可以创建出单例对象的问题?)
  - [JVM(待完善)](docs/JavaJVM.md)
    - [1.垃圾回收有哪些特点？](docs/JavaBasic.md#垃圾回收有哪些特点？)
    - [2.在垃圾回收机制中，对象在内存中的状态有哪几种？](docs/JavaBasic.md#在垃圾回收机制中，对象在内存中的状态有哪几种？)
    - [3.对象的强引用，软引用，弱引用和虚引用的区别是什么？](docs/JavaBasic.md#对象的强引用，软引用，弱引用和虚引用的区别是什么？)
* Redis
  - [基础](docs/RedisBasic.md)
    - [1.Redis是什么？](docs/RedisBasic.md#Redis是什么？)
    - [2.Redis过期key是怎么样清理的？](docs/RedisBasic.md#Redis过期key是怎么样清理的？)
    - [3.Redis为什么是单线程的？](docs/RedisBasic.md#Redis为什么是单线程的？)
    - [4.Redis的性能为什么这么高？](docs/RedisBasic.md#Redis的性能为什么这么高？)
    - [5.Linux中IO模型一共有哪些？](docs/RedisBasic.md#Linux中IO模型一共有哪些？)
    - [6.同步与异步的区别是什么？](docs/RedisBasic.md#同步与异步的区别是什么？)
    - [7.阻塞与非阻塞的区别是什么？](docs/RedisBasic.md#阻塞与非阻塞的区别是什么？)
    - [8.如何解决Redis缓存穿透问题？](docs/RedisBasic.md#如何解决Redis缓存穿透问题？)
    - [9.如何解决Redis缓存雪崩问题？](docs/RedisBasic.md#如何解决Redis缓存雪崩问题？)
  - [数据结构](docs/RedisDataStruct.md)
    - [1.Redis常见的数据结构有哪些？](docs/RedisDataStruct.md#Redis常见的数据结构有哪些？)
    - [2.谈一谈你对Redis中简单动态字符串的理解？](docs/RedisDataStruct.md#谈一谈你对Redis中简单动态字符串的理解？)
    - [3.谈一谈你对Redis中hash对象的理解？](docs/RedisDataStruct.md#谈一谈你对Redis中hash对象的理解？)
    - [4.谈一谈你对Redis中List的理解？](docs/RedisDataStruct.md#谈一谈你对Redis中List的理解？)
    - [5.谈一谈你对Redis中Set的理解？](docs/RedisDataStruct.md#谈一谈你对Redis中Set的理解？)
    - [6.谈一谈你对Redis中有序集合ZSet的理解？](docs/RedisDataStruct.md#谈一谈你对Redis中有序集合ZSet的理解？)
    - [7.布隆过滤器是什么？](docs/RedisDataStruct.md#布隆过滤器是什么？)
  - [持久化(AOF和RDB)](docs/RedisStore.md)
    - [1.Redis的持久化是怎么实现的？](docs/RedisStore.md#Redis的持久化是怎么实现的？)
    - [2.AOF和RDB的区别是什么？](docs/RedisStore.md#AOF和RDB的区别是什么？)
    - [3.怎么防止AOF文件越来越大？](docs/RedisStore.md#怎么防止AOF文件越来越大？)
    - [4.Redis持久化策略该如何进行选择？](docs/RedisStore.md#Redis持久化策略该如何进行选择？)
  - [高可用(主从切换和哨兵机制)](docs/RedisUserful.md)
    - [1.Redis主从同步是怎么实现的？](docs/RedisUserful.md#Redis主从同步是怎么实现的？)
    - [2.Redis中哨兵是什么？](docs/RedisUserful.md#Redis中哨兵是什么？)
    - [3.客户端是怎么接入哨兵系统的？](docs/RedisUserful.md#客户端是怎么接入哨兵系统的？)
    - [4.Redis哨兵系统是怎么实现自动故障转移的？](docs/RedisUserful.md#Redis哨兵系统是怎么实现自动故障转移的？)
- [好书推荐](docs/bookRecommend.md)
* 读书笔记
  - [Redis设计与实现读书笔记 上](docs/RedisBook1.md)
  - [Redis设计与实现读书笔记 下](docs/RedisBook2.md)
  - [MySQL必知必会读书笔记](docs/MySQLBook1.md)

### 如何为这个开源项目做贡献？

如果你想一起参与这个项目，可以提Pull Request，可以扫上面的入群二维码进群，如果入群二维码失效了，也可以扫我的微信，我们一起聊聊！

### 关于我

我平时比较喜欢看书，写技术文章，也比较喜欢讨论技术。这是我的[掘金主页](https://juejin.im/user/5b370a42e51d4558ce5eb969)，希望大家可以关注一下，谢谢了！大家如果有事需要联系我，或者想进技术群，一起讨论技术，也可以扫码加我的微信，谢谢了！

<img src="static/WechatIMG12.jpg" width="30%" padding-right= "20%" />

### 关于转载

如果你需要转载本仓库的一些文章到自己的博客的话，记得注明原文地址就可以了。

