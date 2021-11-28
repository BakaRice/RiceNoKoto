在思考问题时，使用不可变值和函数，函数对一个值进行处理，映射成另一个值
​

## 1. λ?
```java
// 匿名内部类
button.addActionListener(new ActionListener(){
	public void actionPerformed(ActionEvent event){
    	System.out.println("button clicked");
    }
});
//lambda表达式
button.addActionListener(event -> System.out.println("button clicked"));
```
设计匿名类的目的，就是为了方便java程序员将代码作为数据传递，不过，匿名内部类还是不够简便。为了调用一行重要的逻辑代码，不得不加上多行冗余的样板代码。
在方法传入参数中，我们其实并不想传入类似对象的参数，我们更希望传入**行为，**在java8中，我们可以将内部匿名类的形式改编为lambda表达式的形式。
​

## 2.如何辨别lambda表达式？
lambda表达式的几种变体

| lambda表达式类型 | 描述 |
| --- | --- |
| 表达式不包含参数 | 使用`()`表示没有参数 |
| 表达式包含且只包含一个参数 | 可省略参数的括号 |
| 表示包含多个参数的方法 |  |
| 主体是一段代码块 | 使用大括号括起来 |

lambda表达式的类型依赖于上下文环境，是由编译器推断出来的，
```java
public class LambdaExample {
    public static void main(String[] args) {
        Runnable noArguments = () -> System.out.println("hello world!");
        ActionListener oneArguments = e -> System.out.println("button clicked!");
        Runnable multiStatement = () -> {
            System.out.println("hello");
            System.out.println(" World");
        };
        BinaryOperator<Long> add = (x, y) -> x + y;
        BinaryOperator<Long> addExplicit = (Long x, Long y) -> x + y;
    }
}
```
## 3. 引用值，而不是变量
匿名内部类中使用final局部变量
```java
        //匿名内部类中使用final局部变量
		final String name = getUserName();
        Button button = new Button();
        button.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("hi" + name);
            }
        });

		//lambda表达式中引用既成事实上的final变量
        String name2 = getUserName();
        //name2 = "";  //如果这么做,编译器将会报错
        button.addActionListener(e -> System.out.println("hi" + name2));
```
​

java 8中虽然放松了这一限制，可以引用非final变量，但是该变量在既定事实上必须也是final的，虽然无需声明为final变量，但在lambda表达式中，也无法用作非终态变量。如果坚持用作非终态变量，编译器就会报错。
既定事实的final变量是指只能给该变量赋值一次，换句话说，lambda表达式引用的是值，而不是变量  
## 4. 函数接口
函数接口是只有一个抽象方法的接口，用作lambda表达式的类型。
```java
package com.ricemarch;

/**
对应的只有一个抽象方法的接口
*/
public interface IntPred {
    boolean test(Integer value);
}
```
```java
package com.ricemarch;

public class LambdaExercise {
    
    public static void main(String[] args) {
        //对应的lambda表达式对接口进行的实现
        IntPred intPred = x -> x > 5;
        boolean test = intPred.test(10);
        System.out.println(test);
    }
}

```
jdk提供了一组核心函数接口会频繁出现。

| 接口 | 参数 | 返回类型 | 示例 |
| --- | --- | --- | --- |
| Predicate<T> | T | boolean | 这张唱片已经发行了吗 |
| Consumer<T> | T | void | 输出一个值 |
| Function<T> | T | R | 获取Artist对象的名字 |
| Supplier<T> | None | T | 工厂方法 |
| UnaryOperator<T> | T | T | 逻辑非（！） |
| BinaryOperator<T> | (T,T) | T | 求两个数的乘积（*） |

## 5. 类型判断 
某些情况下，用户需要手动指明类型，无论哪种形式进行类型的指明，宗旨是为了代码便于阅读。
一开始类型信息是有用的，但随后的可以只在真正需要时才加上类型学习。
​

```java
//使用菱形操作符，根据变量类型做推断
        Map<String, Integer> oldWorldCounts = new HashMap<String, Integer>();
        Map<String, Integer> oldWorldCounts2 = new HashMap<>();
```
## 
```java
package com.ricemarch;

import java.util.Random;
import java.util.function.BinaryOperator;
import java.util.function.Predicate;

public class LambdaInference {
    public static void main(String[] args) {
        Predicate<Integer> atleast5 = x -> x > 5;
        int i = new Random().nextInt();
        boolean test = atleast5.test(i);
        System.out.println(i + " " + test);

        BinaryOperator<Long> addLongs = (x, y) -> x + y;
        Long apply = addLongs.apply(1L, 1L);
        System.out.println(apply);
    }
}

```
## 6. 要点回顾

- lambda表达式是一种匿名方法，将行为像数据一样进行传递
- lambda表达式的常见结果：BinaryOperator<Long> addLongs = (x, y) -> x + y;
- 函数接口指仅具有单个抽象方法的接口，用来表示lambda表达式的类型
## 7.练习

1. 请看 Function 函数接口并回答下列问题。



```java
public interface Function<T, R> { 
    R apply(T t);
}
```


a. 请画出该函数接口的图示。
![微信截图_20211121192235.png](https://cdn.nlark.com/yuque/0/2021/png/2637209/1637493761889-d6f24bcb-d916-4796-97a4-fcb33542f7a5.png#clientId=u5b0ff7d1-c977-4&crop=0&crop=0&crop=1&crop=1&from=ui&id=u1a73573f&margin=%5Bobject%20Object%5D&name=%E5%BE%AE%E4%BF%A1%E6%88%AA%E5%9B%BE_20211121192235.png&originHeight=108&originWidth=481&originalType=binary&ratio=1&rotation=0&showTitle=false&size=10390&status=done&style=none&taskId=u37214f3b-800c-4f6e-9151-aa64832d912&title=)
b. 若要编写一个计算器程序，你会使用该接口表示什么样的 Lambda 表达式?


```java
Function<Double,Double> calc = t -> t * 2.0;
```


c. 下列哪些 `Lambda` 表达式有效实现了 Function<Long,Long> ?


```java
x->x+1; //OK
(x,y)->x+1; //NG
x->x==1;//NG
```


2. `ThreadLocal Lambda`表达式。`Java`有一个`ThreadLocal`类，作为容器保存了当前线程里局部变量的值。`Java 8`为该类新加了一个工厂方法，接受一个`Lambda`表达式，并产生 一个新的 `ThreadLocal` 对象，而不用使用继承，语法上更加简洁。
a. 在 `Javadoc` 或集成开发环境(IDE)里找出该方法。



```java
/**
 * Represents a supplier of results.
 *
 * <p>There is no requirement that a new or distinct result be returned each
 * time the supplier is invoked.
 *
 * <p>This is a <a href="package-summary.html">functional interface</a>
 * whose functional method is {@link #get()}.
 *
 * @param <T> the type of results supplied by this supplier
 *
 * @since 1.8
 */
@FunctionalInterface
public interface Supplier<T> {
    /**
     * Gets a result.
     *
     * @return a result
     */
    T get();
}
```


b. DateFormatter 类是非线程安全的。使用构造函数创建一个线程安全的 `SimpleDateFormat`对象，并输出日期，如“01-Jan-1970”。


```java
    Supplier<ThreadLocal> threadLocal = () -> ThreadLocal.withInitial(() -> new SimpleDateFormat("dd-MMM-yyyy"));
    SimpleDateFormat df = (SimpleDateFormat)threadLocal.get().get();
    System.out.println(df.format(new Date()));
```


3. 类型推断规则。下面是将 Lambda 表达式作为参数传递给函数的一些例子。javac 能正确推断出 Lambda 表达式中参数的类型吗?换句话说，程序能编译吗?
a. Runnable helloWorld = () -> System.out.println("hello world");//OK
b. 使用 Lambda 表达式实现 ActionListener 接口://OK



```java
JButton button = new JButton();
     button.addActionListener(event ->
System.out.println(event.getActionCommand()));
```


c. 以如下方式重载 check 方法后，还能正确推断出 check(x -> x > 5) 的类型吗?
**不能正确推导，有歧义，因为输入的值都是Integer，返回都是boolean**


> No - the lambda expression could be inferred as IntPred or Predicate so the overload is ambiguous.



```java
interface IntPred {
boolean test(Integer value);
}
boolean check(Predicate<Integer> predicate);
boolean check(IntPred predicate);
```


写成如下形式就可以推导类型：


```java
public interface IntPred {
    boolean test(Double value);
    public boolean check(IntPred intPred, Double i){
        return intPred.test(i);
    }
    public boolean check(Predicate<Integer> predicate,Integer i){
        return predicate.test(i);
    }
    //执行
    System.out.println(check(x -> x > 5, 6.0));
    System.out.println(check(x -> x > 10, 6));
}
```
