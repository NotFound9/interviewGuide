(PS：扫描[首页里面的二维码](README.md)进群，分享我自己在看的技术资料给大家，希望和大家一起学习进步！)

#### [1.HTTPS建立连接的过程是怎么样的？](#HTTPS建立连接的过程是怎么样的？)
### Spring AOP

实现AOP有三种方式：静态代理，使用JDK的Proxy类实现动态代理，使用CGLIB实现动态代理。



#### 静态代理

就是在代码里面创建一个代理类，实现目标类的接口，目标对象是代理类的成员变量，外界需要执行方法时，调用代理类的方法，代理类的方法内部先执行额外的操作，日志记录等，然后再调用目标类的方法。

```java
public interface IUserDao {
    void save();
}
public class UserDao implements IUserDao {
    public void save() {
        System.out.println("已经保存数据...");
    }
}
//代理类
public class UserDaoProxy implements IUserDao {
    private IUserDao target;

    public UserDaoProxy(IUserDao iuserDao) {
        this.target = iuserDao;
    }
    
    public void save() {
        System.out.println("开启事物...");
        target.save();
        System.out.println("关闭事物...");
    }

}
```

### JDK动态代理

通过调用Proxy.newProxyInstance()方法可以为目标类创建一个代理类，然后调用代理类的方法时会调用InvocationHandler的invoke()方法，然后我们可以在invoke方法里面做一些日志记录之类的额外操作，然后再调用真正的实现方法，也就是目标类的方法。

目标类必须有对应的接口类，我们拦截的方法必须是接口中定义的方法。

```
public class Test implements TestInterface {
    public void test(Integer a) {
        System.out.printf("111111");
    }
}
public interface TestInterface {
    void test(Integer a);
}

public static class CustomInvocationHandler implements InvocationHandler {

    Object target;

    public CustomInvocationHandler(Object target) {
        this.target = target;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("before");
        Object result = method.invoke(target, args);
        System.out.println("after");
        return null;
    }
}
```

```
Test    test          = new Test();
TestInterface proxyInstance = (TestInterface) Proxy.newProxyInstance(test.getClass().getClassLoader(), test.getClass().getInterfaces(), new CustomInvocationHandler(test));
        proxyInstance.test(11);
```

实现原理：就是在调用Proxy.newProxyInstance()时会根据类加载器和目标类Class对象动态创建一个代理类出来，动态代理类的所有方法的实现都是向下面这样，方法内部都是调用invocationhandler的invoke方法

```
 public final void test(){
     throws 
    {
      try
      {
      /* h就是handler，m3是Method对象，在静态代码块里面有一行这样的代码
      m3 = Class.forName("com.proxy.main.Test").getMethod("test", new Class[0]);
      */
        this.h.invoke(this, m3, null);
        return;
      }
      catch (RuntimeException localRuntimeException)
      {
        throw localRuntimeException;
      }
      catch (Throwable localThrowable)
      {
      }
      throw new UndeclaredThrowableException(localThrowable);
    }
```

### CGLIB动态代理

创建一个类，继承MethodInterceptor类，重写intercept方法，接受方法调用。创建一个Enhancer实例，设置代理类的父类为目标类，设置回调。

```java
public static void main(final String[] args) {
    System.setProperty(DebuggingClassWriter.DEBUG_LOCATION_PROPERTY, "/Users/ruiwendaier/Downloads/testaop");
    Enhancer enhancer = new Enhancer();
    enhancer.setSuperclass(Test.class);
    enhancer.setCallback(new MyMethodInterceptor());
    Test test1 = (Test)enhancer.create();
    test1.test();

}
public static class MyMethodInterceptor implements MethodInterceptor {
    @Override
    public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
        System.out.println("Before: "  + method.getName());
        Object object = methodProxy.invokeSuper(o, objects);
        System.out.println("After: " + method.getName());
        return object;
    }
}
public static class Test implements TestInterface {
    public void test() {
        System.out.printf("111111");
    }
}
```

生成的代理类中，对于父类中每一个能够继承重写的方法，动态代理类都会生成两个相应的方法。一个是方法内是直接调用父类(也就是目标类的方法)，一个是生成的对应的动态代理的方法，里面会先调用代理类设置的intercept回调方法，然后再调用父类的方法。在调用时，会直接先调用重写的方法。

```java
//代理生成的方法  直接调用的父类(目标类的方法)
  final String CGLIB$test$0(){
    return super.test();
  }
 
  //方法重写 测试样例中就是调用的这里的test方法
  public final String test()
  {
	//判断目标类是否有设置回调：enhancer.setCallback(this);
    MethodInterceptor tmp4_1 = this.CGLIB$CALLBACK_0;
    if (tmp4_1 == null){
      tmp4_1;
      CGLIB$BIND_CALLBACKS(this);
    }
    MethodInterceptor tmp17_14 = this.CGLIB$CALLBACK_0;
	//设置了方法的回调则调用拦截器方法intercept
    if (tmp17_14 != null)
      return (String)tmp17_14.intercept(this, CGLIB$test$0$Method, CGLIB$emptyArgs, CGLIB$test$0$Proxy);
    return super.test();
  }

```





### 区别

Java动态代理只能够对接口进行代理（动态创建了一个类，实现了接口中的方法），不能对普通的类进行代理（因为所有生成的代理类的父类为Proxy，Java类继承机制不允许多重继承）；CGLIB能够代理普通类；
Java动态代理使用Java原生的反射API进行操作，在生成类上比较高效；CGLIB使用ASM框架直接对字节码进行操作，在类的执行过程中比较高效

参考链接：

https://blog.csdn.net/gyshun/article/details/81000997