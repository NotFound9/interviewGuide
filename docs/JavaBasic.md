(PS：扫描[首页里面的二维码](README.md)进群，分享我自己在看的技术资料给大家，希望和大家一起学习进步！)

下面是主要是自己看了《疯狂Java讲义》后，学习到一些之前没掌握的技术点，写的解答，之后会继续更新和完善。

####  [1.Java中的多态是什么？](#Java中的多态是什么？)

#### [2.Java中变量，代码块，构造器之间执行顺序是怎么样的？](#java中变量，代码块，构造器之间执行顺序是怎么样的？)
#### [3.final关键字有哪些作用？](#final关键字有哪些作用？)

#### [4.Integer类会进行缓存吗？](#Integer类会进行缓存吗？)

#### [5.抽象类有哪些特点？](#抽象类有哪些特点？)

#### [6.String，StringBuffer和StringBuilder之间的区别是什么？](#String，StringBuffer和StringBuilder之间的区别是什么？)

#### [7.编译型编程语言，解释型编程语言，伪编译型语言的区别是什么？](#编译型编程语言，解释型编程语言，伪编译型语言的区别是什么？)

#### [8.Java中的访问控制符有哪些？](#Java中的访问控制符有哪些？)

#### [9.Java的构造器有哪些特点？](#Java的构造器有哪些特点？)

####  [10.Java中的内部类是怎么样的？](#Java中的内部类是怎么样的？)

### Java中的多态是什么？

**多态**指的是相同类型的变量在调用通一个方法时呈现出多种**不同的行为特征**。而造成这一现象的原因在于Java中的变量有两个类型：

* 编译时类型，由声明变量时的类型决定。

* 运行时类型，由实际赋值给变量的对象的类型决定，

  当一个变量的两个类型不一致，就会出现多态。

```java
//BaseClass是SubClass的父类
BaseClass a = new BaseClass();
BaseClass b = new SubClass();
a.baseMethod()//变量a调用baseMethod()方法，实际上会调用BaseClass的baseMethod()方法,会打印111
b.baseMethod()//变量b调用baseMethod方法，实际上会调用SubClass的重写baseMethod()方法，会打印222
Class BaseClass {
  void baseMethod() {
    System.out.println("111");
  }
}
Class SubClass {
  void baseMethod() {
    System.out.println("222");
  }
}
输出结果：
111
222
```
例如这个例子中，

##### 对于变量a而言

a的**编译类型是BaseClass**，**实际类型也是BaseClass**，所以调用baseMethod()会执行BaseClass#baseMethod()方法，打印出111。

#####  对于变量b而言

b的的**编译类型是BaseClass**，但是实际赋值时，给变量b赋值的是SubClass对象，所以b的**实际类型是SubClass**。而SubClass重写了父类BaseClass#baseMethod()方法，所以调用baseMethod()方法会调用SubClass#baseMethod()，从而打印出222。

a和b的编译类型相同，却展现出了不同的行为特征，这就是多态。

（PS：如果直接对b调用只有SubClass有的方法，编译时会报错，但是可以通过反射进行调用。）

### Java中变量，代码块，构造器之间执行顺序是怎么样的？

Java程序中类中个元素的初始化顺序
初始化的原则是：

* 先初始化**静态**部分，再初始化**动态**部分，

* 先初始化**父类**部分，后初始化**子类**部分，

* 先初始化**变量**，再初始化**代码块**和**构造器**。

所以依照这个规则可以得出总体顺序是：

1.父类的静态成员变量（如果是第一次加载类）

2.父类的静态代码块（如果是第一次加载类）

3.子类的静态成员变量（如果是第一次加载类）

4.子类的静态代码块（如果是第一次加载类）

5.父类的普通成员变量

6.父类的动态代码块

7.父类的构造器方法

8.子类的普通成员变量

9.子类的动态代码块

10.子类的构造器方法

下面写了一个Demo进行验证:
```java
public class Base {
    static Instance staticInstance = new Instance("1---Base类的静态成员变量staticInstance");
    static  {
        System.out.println("2---Base类的静态代码块执行了");
    }
    Instance instance = new Instance("5---Base类的普通成员变量instance");
    {
        System.out.println("6---Base类的动态代码块执行了");
    }
    Base() {
        System.out.println("7---Base类的构造器方法执行了");
    }
}

public class Child extends Base {
    static Instance staticInstance = new Instance("3---Child类的静态成员变量staticInstance");
    static  {
        System.out.println("4---Child类的静态代码块执行了");
    }
    Instance instance = new Instance("8---Child类的普通成员变量instance");
    {
        System.out.println("9----Child类的动态代码块执行了");
    }
    Child() {
        System.out.println("10---Child类的构造器方法执行了");
    }
    public static void main(String[] args) {
        Child child = new Child();
    }
}
```

输出结果如下：

```
1---Base类的静态成员变量staticInstance进行了初始化
2---Base类的静态代码块执行了
3---Child类的静态成员变量staticInstance进行了初始化
4---Child类的静态代码块执行了
5---Base类的普通成员变量instance进行了初始化
6---Base类的动态代码块执行了
7---Base类的构造器方法执行了
8---Child类的普通成员变量instance进行了初始化
9----Child类的动态代码块执行了
10---Child类的构造器方法执行了
```

说明确实是按照上面的执行顺序执行的。

### final关键字有哪些作用？

##### 修饰类

final修饰类时，类不能被继承，并且类中的所有方法都被隐式地使用final修饰。

##### 修饰方法

final修饰方法时，有两个作用：

* 方法不能被子类重写。
* 可以让方法转换为内嵌调用，提升效率。（早期的Java版本是这样，最近的版本已经没有这些优化了，因为如果方法过大时，内嵌调用无法带来性能提升。）

* 修饰变量

  final修饰的变量一旦初始化，就不能被修改。当final修饰实例变量时，可以在在定义变量时赋初值，也可以在动态代码块，或构造器中赋初值。（只能赋值一次）。
  
  如果final变量在声明时就指定了初始值，并且在编译时可以确定下来，那么在编译时，final变量本质上会变成一个宏变量，所有用到该变量的地方都直接替换成该变量的值。

### Integer类会进行缓存吗？

```java
Intger a =  new Integer(127);
Intger b = Interger.valueOf(127);
Intger c = Interger.valueOf(127);
Intger d = Interger.valueOf(128);
Intger e = Interger.valueOf(128);
System.out.println(a == b); //输出false
System.out.println(b == c); //输出true
System.out.println(d == e); //输出false
```

上面这种例子的原因是如果

* 通过new Interger()创建Interger对象，每次返回全新的Integer对象

* 通过Interger.valueOf()创建Interger对象，如果值在-128到127之间，会返回缓存的对象(初始化时)。

  ##### 实现原理

  Integer类中有一个静态内部类IntegerCach，在加载Integer类时会同时加载IntegerCache类，IntegerCache类的静态代码块中会创建值为-128到127的Integer对象，缓存到cache数组中，之后调用Integer#valueOf方法时，判断使用有缓存的Integer对象，有则返回，无则调用new Integer()创建。

  

  PS：（127是默认的边界值，也可以通过设置JVM参数java.lang.Integer.IntegerCache.high来进行自定义。）

```java
public static Integer valueOf(int i) {
    if (i >= IntegerCache.low && i <= IntegerCache.high)
    		//cache是一个Integer数组，缓存了-128到127的Integer对象
        return IntegerCache.cache[i + (-IntegerCache.low)];
		return new Integer(i);
}

//IntegerCache是Integer类中的静态内部类，Integer类在加载时会同时加载IntegerCache类，IntegerCache类的静态代码块中会
private static class IntegerCache {
        static final int low = -128;
        static final int high;
        static final Integer cache[];

        static {
            // 127是默认的边界值，也可以通过设置JVM参数java.lang.Integer.IntegerCache.high来进行自定义。
            int h = 127;
            String integerCacheHighPropValue =            sun.misc.VM.getSavedProperty("java.lang.Integer.IntegerCache.high");
            if (integerCacheHighPropValue != null) {
                try {
                    int i = parseInt(integerCacheHighPropValue);
                    i = Math.max(i, 127);
                    // cache数组的长度不能超过Integer.MAX_VALUE
                    h = Math.min(i, Integer.MAX_VALUE - (-low) -1);
                } catch( NumberFormatException nfe) {
                    // If the property cannot be parsed into an int, ignore it.
                }
            }
            high = h;

            cache = new Integer[(high - low) + 1];
            int j = low;
            for(int k = 0; k < cache.length; k++)
                cache[k] = new Integer(j++);
          
            // high值必须大于等于127，不然会抛出异常
            assert IntegerCache.high >= 127;
        }

        private IntegerCache() {}
    }
```

### 抽象类有哪些特点？

从多个具体的类中抽象出来的父类叫做抽象类，抽象类就像是一个模板。抽象类使用abstract关键字修饰，抽象类可以拥有抽象方法（使用abstract修饰的方法，由子类来提供方法的实现）。抽象类的特点如下：

1.可以包含抽象方法

抽象方法与普通方法的区别在于，抽象类不提供抽象方法的实现，由继承抽象类的子类实现抽象方法。

2.不能实例化

也正因为包含抽象方法，抽象类不能被实例化。抽象类的构造器不能用于创建实例，是仅提供给子类调用的。除此以外，抽象类跟普通类一样，可以拥有成员变量，普通方法，构造器，初始化块，内部类，枚举等。

3.抽象类可以被继承

继承抽象类的子类如果实现了所有抽象方法，那么可以作为普通类使用，否则也只能作为抽象类。

### String，StringBuffer和StringBuilder之间的区别是什么？

##### 1.可变性

String是一个不可变类，任何对String改变都是会产生一个新的String对象，所以String类是使用final来进行修饰的。而StringBuffer和StringBuilder是可变类，对应的字符串的改变不会产生新的对象。

##### 2.执行效率

当频繁对字符串进行修改时，使用String会生成一些临时对象，多一些附加操作，执行效率降低。

```
stringA = StringA + "2";
//实际上等价于
{
  StringBuffer buffer = new StringBuffer(stringA)
  buffer.append("2");
  return buffer.toString();
}
```

在对stringA进行修改时，实际上是先根据字符串创建一个StringBuffer对象，然后调用append()方法对字符串修改，再调用toString()返回一个字符串。

##### 3.线程安全

StringBuffer的读写方法都使用了synchronized修饰，同一时间只有一个线程进行操作，所以是线程安全的，而StringBuilder不是线程安全的。
### 编译型编程语言，解释型编程语言，伪编译型语言的区别是什么？

* 编译型编程语言

  指的是用专门的编译器，对于针对特定平台将某种高级语言编写的源代码一次性编译成可在该平台硬件执行的机器码，并打包成该平台所能识别的可执行性程序的格式。优点是执行效率比较高，缺点是无法跨平台运行。需要移植到其他平台上运行，需要采用特定平台的编译器重新编译。C,C++,Objective-C,Swift,Kotlin都属于此类。

* 解释型编程语言

  使用特定的解释器对源代码进行逐行解释并立即执行的的语言。缺点是因为每次执行都需进行编译，运行效率低，而且不能脱离解释器独立运行，优点是可以跨平台运行，只要在特定平台上提供特定的解释器就行了。JavaScript，Ruby，Python都属于此类。

* 伪编译型语言

  编译时只编译成中间代码，将中间代码和解释器一起打包成可执行文件。然后执行时使用解释器将中间代码解析成二进制代码。Visual Basic属于此类。

Java
  Java是通过javac编译器将源代码编译成跟平台无关的字节码（也就是.class文件），然后由不同平台上的 JVM（Java虚拟机）对字节码解释执行，在一些Java虚拟机的实现中，还会将字节码转换为特定系统的机器码，提高执行效率。Java语言不属于上面的任何一类，因为目前的高级语言较为复杂，已经不能简单地以编译型编程语言，解释型编程语言，伪编译型语言进行划分了。

### Java中的访问控制符有哪些？

在Java中使用访问控制符修饰成员变量，方法，构造方法时

| 访问范围 | private | default | protected | public |
| -------- | ------- | ------- | --------- | ------ |
| 本类中   | 允许    | 允许    | 允许      | 允许   |
| 同一包中 |         | 允许    | 允许      | 允许   |
| 子类中   |         |         | 允许      | 允许   |
| 其他包中 |         |         |           | 允许   |

private 允许在类中访问。

default 允许在类中，同一包中访问。

protected 允许在类中，同一包中，子类中访问。

public 只允许在类中，同一包中，子类中，其他地方中访问。

### Java的构造器有哪些特点？

```java
public class Test {
    String str;
    public Test(String str) {
        this.str = str;
  }
}
```
1.如果没有自定义构造器，系统会提供一个默认的无参数构造器。如果提供了自定义的构造器，系统就不会提供默认的无参数构造器。(也就是不能直接调用new Test()来创建一个对象了，除非自己自己自定义一个无参数构造器)。

2.在上面的代码中，其实在构造器Test(String str)调用之前，系统已经分配好空间，创建一个对象，然后执行构造器Test(String str)方法对对象进行初始化，然后返回。

3.构造器一般使用public修饰符修饰，也可以使用protected，private来限制访问。

4.构造器重载，指的是一个类可以有多个构造器，多个构造器的参数列表不同。

### Java中的内部类是怎么样的？

内部类分为静态内部类和非静态内部类。静态内部类是与外部类相关的，而非静态内部类外部类的实例对象相关的。

##### 静态内部类

静态内部类一般使用public static修饰，也可以使用private static使用，那样只能在外部内内部使用。在外部类以外的地方使用静态类时，需要带上外部类的包名，例如创建一个静态内部类对象：

```java
OutClass.InnerClass object = new OutClass.InnerClass();
```

##### 非静态内部类

非静态内部类是跟外部类的实例对象对象绑定在一起的。外部类一般是由两种访问修饰符default（只能包内访问），public（所有位置可以访问）。而非静态内部类又private，default，protected，public四种访问修饰符。因为必须跟外部类的实例对象对象绑定在一起，所有非静态内部类不能有静态方法，静态成员变量，静态初始化块，在外面创建一个非静态内部类对象：

```java
OutClass out = new OutClass();
OutClass.InnerClass object = out.new InnerClass();
```