(PS：扫描[首页里面的二维码](README.md)进群，分享我自己在看的技术资料给大家，希望和大家一起学习进步！)

目前还只是买了最新版的[《操作系统导论》](backend/bookRecommend?#《操作系统导论》),还没有完全看完，看完之后会从网上的面经中找一些实际的面试题，然后自己通过翻书查资料，写面试题解答。



#### [1.进程与线程的区别是什么？](#进程与线程的区别是什么？)

#### [2.Java中单例有哪些写法？](#Java中单例有哪些写法？)

####  [3.Java中创建线程有哪些方式?](#Java中创建线程有哪些方式?)

#### [4.如何解决序列化时可以创建出单例对象的问题?](#如何解决序列化时可以创建出单例对象的问题?)

### 进程与线程的区别是什么？

进程是计算机中已运行程序的实体，进程是操作系统资源分配的最小单位，拥有独立的地址空间，具备独立性，动态性，并发性。

#### 独立性

Linux系统会给每个进程分配4G的虚拟地址空间(0到3G是User地址空间，3到4G部分是kernel地址空间)，进程具备私有的地址空间，未经允许，一个用户进程不能访问其他进程的地址空间。

#### 动态性

程序是一个静态的指令集合，而进程是正在操作系统中运行的指令集合，进程有自己的生命周期和各种不同的状态。（五态模型一般指的是新建态（创建一个进程），就绪态（已经获取到资源，准备好了，进入运行队列，一旦获得时间片可以立即执行），阻塞态（运行过程中等待获取其他资源，I/O请求等），终止态（进程被杀死了））。

#### 并发性

多个进程可以在CPU上并发执行。
线程是独立运行和调度的最小单位，线程会共享进程的虚拟空间，一个进程会对应多个线程。在Java中，线程拥有自己私有的程序计数器，虚拟机栈，本地方法栈。

#### PS:虚拟内存

虚拟内存是一种逻辑上扩充物理内存的技术。基本思想是用软、硬件技术把内存与外存这两级存储器当做一级存储器来用。虚拟内存技术的实现利用了自动覆盖和交换技术。简单的说就是将硬盘的一部分作为内存来使用。

#### PS:虚拟地址空间

每个进程有4G的地址空间，在运行程序时，只有一部分数据是真正加载到内存中的，内存管理单元将虚拟地址转换为物理地址，如果内存中不存在这部分数据，那么会使用页面置换方法，将内存页置换出来，然后将外存中的数据加入到内存中，使得程序正常运行。

### Java中创建线程有哪些方式？

最基本的方式就是继承

#### 第一种 继承Thread类，重写Run方法

这种方法就是通过自定义CustomThread类继承Thread类，重写run()方法，然后创建CustomThread的对象，然后调用start()方法，JVM会创建出一个新线程，并且为线程创建方法调用栈和程序计数器，此时线程处于就绪状态，当线程获取CPU时间片后，线程会进入到运行状态，会去调用run()方法。并且创建CustomThread类的对象的线程(这里的例子中是主线程)与调用run()方法的线程之间是并发的，也就是在执行run()方法时，主线程可以去执行其他操作。

```java
class CustomThread extends Thread {
    public static void main(String[] args) {
        System.out.println(Thread.currentThread().getName()+"线程调用了main方法");
        for (int i = 0; i < 10; i++) {
            if (i == 1) {
                CustomThread customThread = new CustomThread();
                customThread.start();
                System.out.println(Thread.currentThread().getName()+"线程--i是"+i);
            }
        }
        System.out.println("main()方法执行完毕！");
    }
    void run() {
        System.out.println(Thread.currentThread().getName()+"线程调用了run()方法");
        for (int j = 0; j < 20; j++) {
            System.out.println(Thread.currentThread().getName()+"线程--j是"+j);
        }
        System.out.println("run()方法执行完毕！");
    }
}
```

输出结果如下：

```
main线程调用了main方法
Thread-0线程调用了run()方法
Thread-0线程--j是0
Thread-0线程--j是1
Thread-0线程--j是2
Thread-0线程--j是3
Thread-0线程--j是4
Thread-0线程--j是5
Thread-0线程--j是6
Thread-0线程--j是7
Thread-0线程--j是8
Thread-0线程--j是9
Thread-0线程--j是10
Thread-0线程--j是11
Thread-0线程--j是12
Thread-0线程--j是13
Thread-0线程--j是14
main线程--i是1
Thread-0线程--j是15
Thread-0线程--j是16
Thread-0线程--j是17
Thread-0线程--j是18
Thread-0线程--j是19
run()方法执行完毕！
main()方法执行完毕！
```

可以看到在创建一个CustomThread对象，调用start()方法后，Thread-0调用了run方法，进行for循环，对j进行打印，与此同时，main线程并没有被阻塞，而是继续执行for循环，对i进行打印。

##### 执行原理

首先我们可以来看看start的源码，首先会判断threadStatus是否为0，如果不为0会抛出异常。然后会将当前对象添加到线程组，最后调用start0方法，因为是native方法，看不到源码，根据上面的执行结果来看，JVM新建了一个线程调用了run方法。

```java
private native void start0();

public synchronized void start() {
   	//判断当前Thread对象是否是新建态，否则抛出异常
    if (threadStatus != 0)
        throw new IllegalThreadStateException();
    //将当前对象添加到线程组
    group.add(this);
    boolean started = false;
    try {
        start0();//这是一个native方法，调用后JVM会新建一个线程来调用run方法
        started = true;
    } finally {
        try {
            if (!started) {
                group.threadStartFailed(this);
            }
        } catch (Throwable ignore) {
            /* do nothing. If start0 threw a Throwable then
              it will be passed up the call stack */
        }
    }
}
```
扩展问题：多次调用Thread对象的start()方法会怎么样？

会抛出IllegalThreadStateException异常。其实在Thread#start()方法里面的的注释中有提到，多次调用start()方法是非法的，所以在上面的start()方法源码中一开始就是对threadStatus进行判断，不为0就会抛出IllegalThreadStateException异常。

![image-20200105144159345](/Users/ruiwendaier/Library/Application Support/typora-user-images/image-20200105144159345.png)

##### 注意事项：

start()方法中判断threadStatus是否为0，是判断当前线程是否新建态，0是代表新建态(上图中的源码注释里面有提到)，而不是就绪态，因为Java中，就绪态和运行态是合并在一起的，（Thread的state为RUNNABLE时(也就是threadStatus为4时)，代表线程为就绪态或运行态）。执行start()方法的线程还不是JVM新建的线程，所以不是就绪态。有一些技术文章把这里弄错了，例如这一篇[《深入浅出线程Thread类的start()方法和run()方法》](https://juejin.im/post/5b09274af265da0de25759d5)

![image-20200105144031591](/Users/ruiwendaier/Library/Application Support/typora-user-images/image-20200105144031591.png)

##### 总结

这种方式的缺点很明显，就是需要继承Thread类，而且实际上我们的需求可能仅仅是希望某些操作被一个其他的线程来执行，所以有了第二种方法。

#### 第二种 实现Runnable接口

这种方式就是创建一个类Target，实现Runnable接口的Run方法，然后将Target类的实例对象作为Thread的构造器入参target，实际的线程对象还是Thread实例，只不过线程Thread与线程执行体（Target类的run方法）分离了，耦合度更低一些。

```java
class ThreadTarget implements Runnable {
    void run() {
        System.out.println(Thread.currentThread().getName()+"线程执行了run方法");
    }
    public static void main(String[] args) {
        System.out.println(Thread.currentThread().getName()+"线程执行了main方法");
        ThreadTarget target = new ThreadTarget();
        Thread thread = new Thread(target);
        thread.start();
    }
}
```

输出结果如下：

![image-20200105163553969](/Users/ruiwendaier/Library/Application Support/typora-user-images/image-20200105163553969.png)

##### 原理

之所以有这种实现方法，是因为Thread类的run方法中会判断成员变量target是否为空，不为空就会调用target类的run方法。

```java
private Runnable target;
public void run() {
    if (target != null) {
    		target.run();
    }
}
```

##### 另外一种写法

这种实现方式也有其他的写法，可以不创建Target类。

##### 匿名内部类

可以不创建Target类，可以使用匿名内部类的方式来实现，因此上面的代码也可以按以下方式写：

```java
Thread thread = new Thread(new Runnable() {
    @Override
    public void run() {
      		System.out.println(Thread.currentThread().getName()+"线程执行了run方法");
    }
});
thread.start();
```
##### Lamda表达式

在Java8之后，使用了@FunctionalInterface注解来修饰Runnable接口，表明Runnable接口是一个函数式接口，有且只有一个抽象方法，可以Lambda方式来创建Runnable对象，比使用匿名类的方式更加简洁一些。

```java
@FunctionalInterface
public interface Runnable {
    public abstract void run();
}
```

因此上面的代码也可以按以下方式写：

```java
Thread thread = new Thread(()->{
      System.out.println(Thread.currentThread().getName()+"线程执行了run方法");
})
thread.start()  
```

##### 总结

这种写法不用继承Thread，但是同样也有缺点，就是线程方法体(也就是run方法)不能设置返回值。

#### 第三种 实现Callable接口

创建一个类CallableTarget，实现Callable接口，实现带有返回值的call()方法，以CallableTarget实例对象作为创建FutureTask对象的参数，FutureTask实现了RunnableFuture接口，而RunnableFuture接口继承于Runnable, Future接口，所以FutureTask对象可以作为创建Thread对象的入参，创建Thread对象，然后调用start方法。

```java
public class CallableTarget implements Callable<Integer> {

    public Integer call() throws InterruptedException {
        System.out.println(Thread.currentThread().getName()+"线程执行了call方法");
        Thread.sleep(5000);
        return 1;
    }

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        System.out.println(Thread.currentThread().getName()+"线程执行了main方法");
        CallableTarget callableTarget = new CallableTarget();
        FutureTask<Integer> task = new FutureTask<Integer>(callableTarget);
        Thread thread = new Thread(task);
        thread.start();
        Integer result = task.get();//当前线程会阻塞，一直等到结果返回。
        System.out.println("执行完毕，打印result="+result);
        System.out.println("执行完毕");
    }
}
```

Callable接口的源码

```java
@FunctionalInterface
public interface Callable<V> {
    V call() throws Exception;
}
```

RunnableFuture接口的源码

```java
public interface RunnableFuture<V> extends Runnable, Future<V> {
    void run();
}
```



### Java中单例有哪些写法？

正确并且可以做到延迟加载的写法其实就是三种：

使用volatile修饰变量并且双重校验的写法。

使用静态内部类来实现（类A有一个静态内部类B，类B有一个静态变量instance，类A的getInstance()方法会返回类B的静态变量instance，因为只有调用getInstance()方法时才会加载静态内部类B，这种写法缺点是不能传参。）

使用枚举来实现（）

#### 第1种 不加锁（裸奔写法）

多线程执行时，可能会在instance完成初始化之前，其他线性线程判断instance为null，从而也执行第二步的代码，导致初始化覆盖。

```java
public class UnsafeLazyInitialization {
	private static Instance instance;
	public static Instance getInstance() {
    if (instance == null) //1
      instance = new Instance(); //2
    }
    return instance;
}
```

#### 第2种-对方法加sychronize锁(俗称的懒汉模式)

初始化完成以后，每次调用getInstance()方法都需要获取同步锁，导致不必要的开销。

```java
public class Singleton {
    private static Singleton instance;
    public synchronized static Singleton getInstance() {
        if (instance == null)
            instance = new Instance();
        return instance;
    }
}
```
#### 第3种-使用静态变量(俗称的饿汉模式)

```
public class Singleton {  
    private static Singleton instance = new Singleton();  
    public static Singleton getInstance() {  
        return instance;  
    }  
}  
```
这种方法是缺点在于不能做到延时加载，在第一次调用getInstance()方法之前，如果Singleton类被使用到，那么就会对instance变量初始化。

#### 第4种-使用双重检查锁定

代码如下：

```java
public class Singleton {               
    private static Singleton instance;              
    public static Singleton getInstance() {              
        if (instance == null) {                        
            synchronized (Singleton.class) { 
                if (instance == null) {                 
                    instance = new Singleton();        
                }
            }                                   
        }                                      
        return instance;                        
    }                                                 
}                     
```

instance = new Singleton();          

这句代码在执行时会分解为三个步骤：

1.为对象分配内存空间。

2.执行初始化的代码。

3.将分配好的内存地址设置给instance引用。

但是编译器会对指令进行重排序，只能保证单线程执行时结果不会变化，也就是可能第3步会在第2步之前执行，某个线程A刚好执行完第3步，正在执行第2步时，此时如果有其他线程B进入if (instance == null)判断，会发现instance不为null，然后将instance返回，但是实际上instance还没有完成初始化，线程B会访问到一个未初始化完成的instance对象。

#### 第5种 基于 volatile 的双重检查锁定的解决方案

代码如下：

```java
public class Singleton {               
    private volatile static Singleton instance;              
    public static Singleton getInstance() {              
        if (instance == null) {                        
            synchronized (Singleton.class) { 
                if (instance == null)//双重检查存在的一样在于可能会有多个线程进入第一个判断，然后竞争同步锁，线程A得到了同步锁，创建了一个Singleton实例，赋值给instance，然后释放同步锁，此时线程B获得同步锁，又会创建一个Singleton实例，造成初始化覆盖。
                    instance = new Singleton();          
            }                                   
        }                                      
        return instance;                        
    }                                                 
} 
```

volatile可以保证变量的内存可见性及防止指令重排。

volatile修饰的变量在编译后，会多出一个lock前缀指令，lock前缀指令相当于一个内存屏障（内存栅栏），有三个作用：

* 确保指令重排序时，内存屏障前的指令不会排到后面去，内存屏障后的指令不会排到前面去。
* 强制对变量在线程工作内存中的修改操作立即写入到物理内存。
* 如果是写操作，会导致其他CPU中对这个变量的缓存失效，强制其他CPU中的线程在获取变量时从物理内存中获取更新后的值。

所以使用volatile修饰后不会出现第3种写法中由于指令重排序导致的问题。

#### 第6种 - 使用静态内部类来实现

```java
 private static class Signleton {
        private static Signleton instance = new Signleton();
    }

    public static Signleton getInstance() {
        return Signleton.instance ;  // 这里将导致 Signleton 类被初始化 
    }
```

因为JVM底层通过加锁实现，保证一个类只会被加载一次，多个线程在对类进行初始化时，只有一个线程会获得锁，然后对类进行初始化，其他线程会阻塞等待。所以可以使用上面的代码来保证instance只会被初始化一次，这种写法的问题在于创建单例时不能传参。

#### 7.使用枚举来实现单例

```java
public enum Singleton {
    //每个元素就是一个单例
    INSTANCE;
    //自定义的一些方法
    public void method(){}
}
```
这种写法比较简洁，但是不太便于阅读和理解，所以实际开发中应用得比较少，而且由于枚举类是不能通过反射来创建实例的(反射方法newInstance中判断是枚举类型，会抛出IllegalArgumentException异常)，所以可以防止反射。而且由于枚举类型的反序列化是通过java.lang.Enum的valueOf方法来实现的，不能自定义序列化方法，可以防止通过序列化来创建多个单例。

### 如何解决序列化时可以创建出单例对象的问题?

如果将单例对象序列化成字节序列后，然后再反序列成对象，那么就可以创建出一个新的单例对象，从而导致单例不唯一，避免发生这种情况的解决方案是在单例类中实现readResolve()方法。

```java
public class Singleton implements java.io.Serializable {     

   private Object readResolve() {     
         return INSTANCE;     
    }    
} 
```
通过实现readResolve方法，ObjectInputStream实例对象在调用readObject()方法进行反序列化时，就会判断相应的类是否实现了readResolve()方法，如果实现了，就会调用readResolve()方法返回一个对象作为反序列化的结果，而不是去创建一个新的对象。