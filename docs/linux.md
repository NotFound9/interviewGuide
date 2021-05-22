### kill pid和kill -9 pid的区别是什么？

kill pid 

代表通知应用程序自行关闭。系统会发生一个SIGTERM命令给进程对应的应用程序，让应用程序释放自己的资源后，自行关闭。大部分应用程序可能接受后会释放资源，自行停止，也有一些程序不会理会。

kill -9 pid

代表强制关闭进程。系统会发送一个SIGKILL命令给进程。

一般建议先执行kill pid，然后过一两秒后等程序做一些释放资源的操作，然后再使用kill -9命令强制删除。

https://www.cnblogs.com/aspirant/p/11543456.html

### 僵尸进程和孤儿进程是什么？
僵尸进程就是子进程调用exit退出或者是运行时发生致命错误，结束运行时，一般会把进程的退出状态通知给操作系统，操作系统发送SIGCHLD信号告诉父进程“子进程退出了”，父进程一般会使用wait系统调用以获得子进程的退出状态，这样内核就可以在内存中释放子进程了，但是如果父进程没有进行wait系统调用，子进程就会驻留在内存，成为僵尸进程。

孤儿进程就是父进程退出，但是它的子进程还在进行，这些子进程就会变成孤儿进程，被init进程(进程号为1)所收养，由它来管理和收集子进程的状态。由于孤儿进程有init进程循环的wait()调用回收资源，所以不会产生什么危害。

##### Linux指令使用

统计access.log中ip访问次数前十的

```
cat access.log | awk '{ print $1}' | sort -n | uniq -c | sort - r |head 10 
```

统计当前目录下（包含子目录） java 的文件的代码总行数。    

```
wc -l `find . -name "*.java"` | awk '{ sum=sum+$1 } END { print sum }'
```

### Linux进程间通信的方式？

《Linux 的进程间通信》 https://zhuanlan.zhihu.com/p/58489873

浅析进程间通信的几种方式（含实例源码） https://zhuanlan.zhihu.com/p/94856678

https://mp.weixin.qq.com/s/WgZaS5w5IXa3IBGRsPKtbQ