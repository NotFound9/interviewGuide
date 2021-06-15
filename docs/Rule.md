##### 1.使用BigDecimal替代Float和Double

主要Float和Double是使用类似于科学计数法那样"有效数字+指数"来表示的，所以在二进制存储时，是会丢失精度，没法做到精准的。所以浮点数之间不能使用==等值判断，浮点数包装类型之间不能使用equals

```java
float a = 1.0f - 0.9f; 
float b = 0.9f - 0.8f; //通过debug调试发现这两次减运算减下来，a和b的值存在一些差异，不是一模一样的，丢失了精度
Boolean result = a == b;//结果是false

Float x = 1.0F - 0.9F; 
Float y = 0.9F - 0.8F; 
Boolean result = x.equals(y);//结果是false
```

解决方案：

1. 任何货币金额，均以最小货币单位且整型类型来进行存储。例如在数据库里面存10000，代表是100.00元。

2.  使用Bigdecimal来存这些值，并且进行加减。

```java
BigDecimal a1 = new BigDecimal("1.0");
BigDecimal b1 = new BigDecimal("0.9");
BigDecimal c1 = new BigDecimal("0.8");

BigDecimal a2 = a1.subtract(b1);
BigDecimal b2 = b1.subtract(c1);

System.out.println(a2.equals(b2));//打印结果是true
```

   

2.布尔类型的变量，都不要加is前缀，否则部分框架解析会引起序列化错误。

一般假设我们定义一个Boolean变量为isHot，按照Bean规范生成的get方法应该是isIsHot，但是我们使用IDEA来自动生成get方法时，生成的是isHot()方法，

> JavaBeans规范中对这些均有相应的规定，基本数据类型的属性，其getter和setter方法是getXXX()和setXXX，但是对于基本数据中布尔类型的数据，又有一套规定，其getter和setter方法是isXXX()和setXXX。但是包装类型都是以get开头。

```java
private boolean isHot;
public boolean isHot() {
  	return isHot;
}
public void setHot(boolean hot) {
  	isHot = hot;
}
```

这样子在实例对象转json时，序列化框架看到isHot()方法会去找hot实例变量，这样就会找不到变量值。

在与前端交互时，同意需要注意，避免Boolean类型参数是is前缀开头的，因为Spring MVC在接受参数时，看到前端json传过来的值是isHot，而set方法中没有setIsHot()方法，只有setHot()方法

https://www.cnblogs.com/goloving/p/13086151.html

https://blog.csdn.net/qq_31145141/article/details/71597608

##### 正确的加锁方式

通过这种方式来加锁，保证抛出异常时可以正常解锁，同时lock()方法不能在try代码块中调用，防止线程还没有加上锁时抛出异常，然后进行解锁，抛出IllegalMonitorStateException异常（对未加锁对象调用释放锁tryRelease()方法就会抛这个异常）。

```java
Lock lock = new XxxLock(); // ...
lock.lock();
try {
	doSomething();
	doOthers(); 
} finally {
	lock.unlock(); 
}
```

##### COUNT(*)与count(列名)

1.【强制】不要使用count(列名)或count(常量)来替代count(*)，count(*)是SQL92定义的标 准统计行数的语法，跟数据库无关，跟 NULL 和非 NULL 无关。
 说明:count(*)会统计值为 NULL 的行，而 count(列名)会将NULL值排除掉，不会统计此列为 NULL 值的行。

2.count(distinct col) 计算该列除 NULL 之外的不重复行数