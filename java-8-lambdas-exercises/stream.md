介绍Stream类中的一组方法，每个方法都对应集合上的一种操作。
## 0. 示例
​

## 1. 从外部迭代到内部迭代
​

java程序员在使用集合类是，一个通用的模式是在集合上进行i迭代，然后处理返回的每一个元素，比如要计算每从伦敦来的艺术家的人数，可以使用for循环
for循环存在哪些问题？ 

1. for循环的模糊了代码的本意，必须要读完全部for内容才能理解
1. 进行并行化改造时比较麻烦

​

对于集合的for循环本质上其实是语法糖,其本质是上调用了迭代器，产生了一个新的 iterator对象，进而控制了整个迭代过程，这就是**外部迭代，迭代过程通过显示调用iterator对象的hasNext和next方法完成迭代。**
```java
package com.ricemarch;

import java.util.ArrayList;
import java.util.List;

public class StreamExmaple {

    public static void main(String[] args) {

        List<String> strings = new ArrayList<>();
        for (String string : strings) {
            System.out.println(string);
        }
    }
}


// build  to class

//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by FernFlower decompiler)
//

package com.ricemarch;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class StreamExmaple {
    public StreamExmaple() {
    }

    public static void main(String[] args) {
        List<String> strings = new ArrayList();
        Iterator var2 = strings.iterator();

        while(var2.hasNext()) {
            String string = (String)var2.next();
            System.out.println(string);
        }

    }
}


```
外部迭代从本质上是一种串行化操作，总体来看，使用for循环将行为和方法混为一谈。
​

另一种方法就是内部迭代，
```java
`long count  =allArtists.stream()
    .filter(artist -> artist.isFrom("London"))
    .count();
```
## 2. 实现机制
```java
allArtists.stream().filter(artist -> artist.isFrom("London"))
```
filter只刻画出了stream，但是并没有产生新的集合，像filter这样的只描述stream，最终不产生新集合的方法叫做惰性求值方法。  而像count这样最终会从stream产生值的方法叫做及早求值方法。
​

判断一个操作是惰性求值还是及早求值很简单，只需要看他的返回值，如果返回值是stream，那么是惰性求值，如果返回值是另一个值或为空，那么就是及早求值。
使用这些操作的理想方法是形成一个惰性求值的链，最后用一个及早求值的操作返回想要的结果，这正是他的合理之处。计数的示例也是这样运行的，但这只是最简单的情况：只含两步操作。
整个过程和建造者模式有共通指出。建造者模式使用一系列操作设置属性和配置，最后调用一个build方法， 这时，对象才被真正创建。
​

为什么要区分惰性求值和及早求值？ 只有在对需要什么样的结果和操作有了更多了解之后，才能更有效率地进行计算。例如，如果要找出大于10的第一个数字，那么并不需要和所有的元素去做比较，只要找出第一个匹配的元素就够了，这也意味着可以在集合类上级联多种操作，但迭代只需一次。
​

## 3. 常用的流操作
### 3.1 collect(toList())
collect(toList())方法 由stream里的值生产一个列表，是一个及早求值操作。
```java
List<String> collected = Stream.of("a", "b", "c").collect(Collectors.toList());
assert Arrays.asList("a", "b", "c").equals(collected);
```
### 3.2 map
如果有一个函数可以将一种类型的值转换为另外一种类型，map操作就可以使用该函数，将一个流中的值转换为一个新的流。
```java
List<String> collected2 = new ArrayList<>();
for (String s : asList("a", "b", "hello")) {
    String upperCaseString = s.toUpperCase(Locale.ROOT); 
    collected2.add(upperCaseString);
}
collected2 = Stream.of("a", "b", "hello") 
    .map(string -> string.toUpperCase(Locale.ROOT)) 
    .collect(Collectors.toList());
assert asList("A", "B", "HELLO").equals(collected2);
```
lambda表达式必须是function接口的一个实例
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2637209/1637497783841-540e55cc-5a4a-4ff7-a1eb-14a3dcd85a87.png#clientId=ucd631f6b-41f6-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=429&id=u90753f56&margin=%5Bobject%20Object%5D&name=image.png&originHeight=857&originWidth=1028&originalType=binary&ratio=1&rotation=0&showTitle=false&size=75047&status=done&style=none&taskId=u5212a5f0-5f12-44e1-86fb-e3ce3088225&title=&width=514)
## 3.3 filter
```java
  collected2 = Stream.of("a", "b", "hello")
                .filter(v -> isDigit(v.charAt(0)))
                .collect(Collectors.toList());
```
和map很像，filter接受一个函数作为参数，该函数用lambda表达式表示。该函数和if条件判断语句的功能一样，如果字符串首字母为数字，则返回true。
若要重构遗留代码，for循环中的if条件语句就是一个很强的信号，可用filter方法替换
​

## 3.4 flatMap
flatMap方法可用Stream替换值，然后将多个stream连接成一个stream
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2637209/1637630685049-f972a9f4-3786-4e82-8cc9-48f355e9ebcc.png#clientId=u7eb9a74d-e899-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=150&id=u66d873cd&margin=%5Bobject%20Object%5D&name=image.png&originHeight=299&originWidth=841&originalType=binary&ratio=1&rotation=0&showTitle=false&size=55683&status=done&style=none&taskId=u3757bf22-5881-4b30-84a5-44dbb491b32&title=&width=420.5)
前面已介绍过map操作，它可用一个新的值代替Stream中的值。但有时，用户希望让map操作有点变化，生成一个新的Stream对象取而代之。用户通常不希望结果是一连串的流，此时flatMap最能派上用场
​

```java
List<Integer> together = Stream.of(asList(1, 2), asList(3, 4)).flatMap(Collection::stream).collect(Collectors.toList());

assert asList(1, 2, 3, 4).equals(together);
```
调用stream方法，将每个列表转换成Stream对象，其余部分由flatMap方法处理。flatMap方法的相关函数接口和map方法的一样，都是Function接口，只是方法的返回值限定为Stream类型罢了。
​

## 3.5 max和min
Stream上常用的操作之一是求最大值和最小值
```java
List<Track> tracks = asList(new Track("Bakai", 524), new Track("Violets for Your Furs", 378), new Track("Time Was", 451));
Track shortestTrack = tracks.stream().min(Comparator.comparing(track -> track.getLength())).get();
```
查找Stream中的最大或最小元素，首先要考虑的是用什么作为排序的指标。以查找专辑中的最短曲目为例，排序的指标就是曲目的长度。
为了让Stream对象按照曲目长度进行排序，需要传给它一个Comparator对象。Java 8提供了一个新的静态方法comparing，使用它可以方便地实现一个比较器。放在以前，我们需要比较两个对象的某项属性的值，现在只需要提供一个存取方法就够了。本例中使用getLength方法。
花点时间研究一下comparing方法是值得的。实际上这个方法接受一个函数并返回另一个函数。我知道，这听起来像句废话，但是却很有用。这个方法本该早已加入Java标准库，但由于匿名内部类可读性差且书写冗长，一直未能实现。现在有了Lambda表达式，代码变得简洁易懂。
此外，还可以调用空Stream的max方法，返回Optional对象。Optional对象有点陌生，它代表一个可能存在也可能不存在的值。如果Stream为空，那么该值不存在，如果不为空，则该值存在。先不必细究，4.10节将详细讲述Optional对象，现在唯一需要记住的是，通过调用get方法可以取出Optional对象中的值。
​

## 3.6 通用模式 > reduce模式
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2637209/1637769183512-333499c5-70f9-4d48-a961-954772bcc4c8.png#clientId=ufc7236fb-fb40-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=99&id=u7b7e6bef&margin=%5Bobject%20Object%5D&name=image.png&originHeight=197&originWidth=974&originalType=binary&ratio=1&rotation=0&showTitle=false&size=20422&status=done&style=none&taskId=u880c8b1c-60e5-4f9d-a269-d8a27d7c5c6&title=&width=487)
首先赋给accumulator一个初始值：initialValue，然后在循环体中，通过调用combine函数，拿accumulator和集合中的每一个元素做运算，再将运算结果赋给accumulator，最后accumulator的值就是想要的结果。
这个模式中的两个可变项是initialValue初始值和combine函数
​

下面我们来看一下stream中的reduce操作的过程。
reduce操作可以实现从一组值中生成一个值。在上述例子中用到的count、min和max方法，因为常用而被纳入标准库中。事实上，这些方法都是reduce操作。图3-8展示了如何通过reduce操作对Stream中的数字求和。以0作起点——一个空Stream的求和结果，每一步都将Stream中的元素累加至accumulator，遍历至Stream中的最后一个元素时，accumulator的值就是所有元素的和。
![image.png](https://cdn.nlark.com/yuque/0/2021/png/2637209/1637769298130-7e947959-26f2-4264-9a19-ac406f4b51aa.png#clientId=ufc7236fb-fb40-4&crop=0&crop=0&crop=1&crop=1&from=paste&height=132&id=ucacd5bf5&margin=%5Bobject%20Object%5D&name=image.png&originHeight=264&originWidth=530&originalType=binary&ratio=1&rotation=0&showTitle=true&size=35963&status=done&style=none&taskId=u364e3764-adae-4a31-b339-7076fb09164&title=%E4%BD%BF%E7%94%A8reduce%E6%93%8D%E4%BD%9C%E5%AE%9E%E7%8E%B0%E7%B4%AF%E5%8A%A0&width=265 "使用reduce操作实现累加")
```java
//使用reduce求和
Integer reduce = Stream.of(1, 2, 3).reduce(0, (acc, element) -> acc + element);
//can be replace with the Integer::sum
assert 6 == reduce;
```
Lambda表达式的返回值是最新的acc，是上一轮acc的值和当前元素相加的结果。reducer的类型是BinaryOperator。
## 3.8 整合操作
现在或许是个思考的好机会，你真的需要对外暴露一个List或Set对象吗？可能一个Stream工厂才是更好的选择。**通过Stream暴露集合的最大优点在于，它很好地封装了内部实现的数据结构。仅暴露一个Stream接口，用户在实际操作中无论如何使用，都不会影响内部的List或Set**。
同时这也鼓励用户在编程中使用更现代的Java 8风格。不必一蹴而就，可以对已有代码渐进性地重构，保留原有的取值函数，添加返回Stream对象的函数，时间长了，就可以删掉所有返回List或Set的取值函数。清理了所有遗留代码之后，这种重构方式让人感觉棒极了！
​

## 3.9 高阶函数 与 正确使用lambda表达式
高阶函数是指接受另外一个函数作为参数，或返回一个函数的函数。高阶函数不难辨认：看函数签名就够了。如果函数的参数列表里包含函数接口，或该函数返回一个函数接口，那么该函数就是高阶函数。
无论何时，将Lambda表达式传给Stream上的高阶函数，都应该尽量避免副作用。唯一的例外是forEach方法，它是一个终结方法
​

## 3.10 要点回顾

- 内部迭代将更多控制权交给了集合类
- 和iterator类似，stream是一种内部迭代方式
- 将lambda表达式和stream上的方法结合起来，可以完成很多常见的集合操作。 

​

## 3.11 练习

1. 常用流操作，实现如下函数：
   1. 编写一个求和函数，计算流中所有数之和，例如：int addUp(Stream<Integer> numbers)
```java
 int addUp(Stream<Integer> numbers) {
        return numbers.reduce(0, Integer::sum);
}
```

   2. 编写一个函数，接受艺术家列表作为参数，返回一个字符串列表，其中包含艺术家的姓名和国籍、
```java
public static List<String> getNameAndNation(List<Artist> artists) {
        return artists.stream()
                .flatMap(artist -> Stream.of(artist.getName(), artist.getNationality()))
                .collect(Collectors.toList());
}
```

   3. 编写一个函数，接受专辑列表作为参数，返回一个由最多包含3首歌曲的专辑组成的列表
```java
public static List<Album> getAlbumsWithAtMostThreeTracks(List<Album> input) {
        return input.stream()
                .filter(album -> album.getTrackList().size() <= 3)
                .collect(toList());
    }
```

2. 迭代。修改如下代码，将外部迭代转换为内部迭代
```java
int totalMembers = 0;
        for (Artist artist : artists) {
            Stream<Artist> members = artist.getMembers();
            totalMembers += members.count();
}
```
改写后：
```java
  int reduce = artists.stream()
      .map(x -> x.getMembers().count())
      .reduce(0L, Long::sum).intValue();
```

3. 求值，根据stream方法的签名，判断其是惰性求值还是及早求值。
   1. boolean anyMatch(Predicate<? super T> predicate); 及早求值Eager
   1. Stream<T> limit(long maxSize); 惰性求值 Lazy
4. 高阶函数。下面的Stream函数是高阶函数吗？为什么？
   1. boolean anyMatch(Predicate<? super T> predicate); yes,接收参数为另一个函数takes a function as an argument
   1. Stream<T> limit(long maxSize); no
5. 纯函数，下面的lambda表达式是否有无副作用，或者说他们是否改变了程序状态？无副作用
```java
x -> x+1
// 示例代码如下所示
 AtomicInteger count = new AtomicInteger(0);
List<String> origins = album.musicians().forEach(musician -> count.incAndGet();)
```

   1. 上述代码中传入forEach方法的lambda表达式。 count musician
6. 计算一个字符串中小写字母的个数（提示，参阅string对象的chars方法）
```java
public static long countLowerCaseLettersCount(String str) {
        char[] chars = str.toCharArray();
        List<Character> characterList = new ArrayList();
        char[] var3 = chars;
        int var4 = chars.length;

        for(int var5 = 0; var5 < var4; ++var5) {
            char aChar = var3[var5];
            characterList.add(aChar);
        }

        return characterList.stream().filter((x) -> {
            return x >= 'a' && x <= 'z';
        }).count();
    }

    public static long countLowerCaseLettersCount2(String str) {
        return str.chars().filter(Character::isLowerCase).count();
    }
```

7. 在一个字符串列表中，找出包含最多小写字母的字符串，对于空列表，返回Optional<String>对象。
```java
public static Optional<String> mostLowercaseString(List<String> strings) {
        return strings.stream()
                .max(Comparator.comparingInt(LambdaExercise2::countLowercaseLetters));
    }
```


