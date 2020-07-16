### 常见的排序算法

![img](../static/640-2913012.png)

![img](../static/640-2921069.jpeg)



## 冒泡排序

就是进行n次遍历，每次比较两个元素，判断大小，进行交换，将大的元素换到右边，最终可以遍历可以将最大的元素交换到末尾，最终让整个序列有序。

#### 优化

使用冒泡排序的过程中，如果有一趟冒泡过程中元素之间没有发生交换，那么就说明已经排序好了，可以直接退出不再继续执行后续的冒泡操作了。

```java
int[] sorted(int[] array) {
  if (array == null || array.length ==0 || array.length ==1) {return array;}
  
  for(int i = array.length-1;i>=1;i--) {//i代表遍历的最大范围
    int sortedFlag = 0;
    for(int j = 1;j<=i;j++) {
      if(array[j]<array[j-1]) {//进行交换
        int temp = array[j];
        array[j] = array[j-1];
        array[j-1]=temp;
        sortedFlag=1;
      }
    }
     // 该趟排序中没有发生，表示已经有序
        if (0 == sortedFlag) {
            break;
        }
  }
  return array;
}
```

## 插入排序

就是每次从未排好序的序列中，每次取出一个元素，插入到已排好序的序列中去。

```java
int[] sorted2(int[] array) {
  if(array == null || array.length==0 || array.length==1) {return array;}
  for(int i=1;i<array.length;i++) {
    	for(int j = i;j>0;j--) {
        if(array[j]<array[j-1]) {
          int temp = array[j];
          array[j] = array[j-1];
          array[j-1] = temp;
        }
      }
  }
  return array;
}
```

## 选择排序

就每次从为排好序的序列中选择一个最小值出来，然后放到已排序的序列末尾。

```java
int[] sorted3(int[] array) {
      if(array == null || array.length==0 || array.length==1) {return array;}
      for(int i= 0;i<array.length-1;i++) {
        int min = i;
        for(int j = i+1;j<array.length;j++) {
          if(array[j]<array[min]){
            min = j;
          }
        }
        int temp = array[i];
        array[i] = array[min];
        array[min] = temp;
      }
      return array;
}
```

## 归并排序

就是递归地先将数组进行分组，一直分，一直分，一直到组只剩下1个元素，然后进行合并

```java
int[] sorted4(int[] array, int start,int end) {
        if(start>=end) {
            return array;
        }
        int middle = start + (end-start)/2;
        sorted44(array,start, middle);
        sorted44(array,middle + 1, end);
        merge(array, start,end);
        return array;
    }

void merge(int[] array, int start,int end) {
       int length = end-start+1;
       int[] temp = new int[length];
       for (int k = 0; k < length; k++) {
           temp[k] = array[start+k];
       }
       int left  = 0;
       int tempMiddle = (0 + length-1)/2;
       int right = tempMiddle+1;
       int tempEnd =length-1;
       int i     = start;
       while (left <= tempMiddle && right <= tempEnd) {
           array[i++] = temp[left] < temp[right] ? temp[left++]:temp[right++];
       }

       while (left <= tempMiddle) {
           array[i++] = temp[left++];
       }

       while (right <= tempEnd) {
           array[i++] = temp[right++];
       }
   }
```

### 快速排序

先取第一个元素作为中间值，小于中间值的元素放一组，大于中间值的元素放一组，然后继续对每一组进行递归排序，最终让数组有序。

```
int[] quickSorted(int [] array, int start,int end) {
//如果start和end相等就直接结束循环
	if(start>=end) {return array;}
//取第一个元素作为基准值
	int base = array[start];
	int i = start;//左边从第一个元素开始，如果取得基准值正好是最小值，然后遍历从第二个开始，会导致第二个位置的值与基准值交换，而第二个位置的值是>基准值的
	int j = end;//右边从最后一个元素开始
	//只要i<j就一直循环
	while(i<j) {
			//从右边找出一个元素小于基准值的元素
			while(array[j] > base && i<j) {j--;}
			//从左边找出一个大于基准值的元素
			while(array[i]<=base&&i<j) {i++;}
			//进行交换
			if(i<j) {
          int temp =array[j];
          array[j] = array[i];
          array[i] = temp;
			}
	}
	//将中间值换成基准元素
	array[start] = array[i];
	array[i] = base;
	//左边的组继续进行快排
  quickSorted(array,start,i-1);
    //右边的组继续进行快排
  quickSorted(array,i+1,end);
  return array;
}
```

- 由于分区点很重要（为什么重要见算法分析），因此可以想方法寻找一个好的分区点来使得被分区点分开的两个分区中，数据的数量差不多。下面介绍两种比较常见的算法：
- - **三数取中法。就是从区间的首、尾、中间分别取出一个数，然后对比大小，取这 3 个数的中间值作为分区点。**但是，如果排序的数组比较大，那“三数取中”可能不够了，可能就要“五数取中”或者“十数取中”，也就是间隔某个固定的长度，取数据进行比较，然后选择中间值最为分区点。
  - 随机法。随机法就是从排序的区间中，随机选择一个元素作为分区点。随机法不能保证每次分区点都是比较好的，但是从概率的角度来看，也不太可能出现每次分区点都很差的情况。所以平均情况下，随机法取分区点还是比较好的。
- 递归可能会栈溢出，最好的方式是使用非递归的方式；

### 堆排序

堆排序相当于先建一个大顶堆，建堆方式主要通过从最后一个非叶子节点开始调整位置（调整时主要是通过将节点A与它的最大子节点进行交换，一直交换下去，知道都大于左右子节点），然后每次将堆顶的元素与最后一个元素交换，相当于取出最大元素，放到最后面，然后对堆进行调整，重新成为大顶堆，一直到最后。

```
public static void sort(int []arr){
    //1.构建大顶堆
    for(int i=arr.length/2-1;i>=0;i--){
        //从第一个非叶子结点从下至上，从右至左调整结构
        adjustHeap(arr,i,arr.length);
    }
    //2.调整堆结构+交换堆顶元素与末尾元素
    for(int j=arr.length-1;j>0;j--){
        swap(arr,0,j);//将堆顶元素与末尾元素进行交换
        adjustHeap(arr,0,j);//重新对堆进行调整
    }
}
// 调整的过程其实是将从节点i的左右节点中找出最大值，然后作为当前i的节点，并且会对交换后的节点继续调整
public static void adjustHeap(int []arr,int i,int length){
    int temp = arr[i];//先取出当前元素i
    for(int k=i*2+1;k<length;k=k*2+1){//从i结点的左子结点开始，也就是2i+1处开始
        if(k<length-1 && arr[k]<arr[k+1]){//如果右子节点存在，左子结点小于右子结点，k指向右子结点
            k++;
        }
        if(arr[k] >temp){//如果子节点大于父节点，将子节点值赋给父节点（不用进行交换）
            arr[i] = arr[k];
            i = k;
        }else{ break; }
    }
    arr[i] = temp;//将temp值放到最终的位置
}
//交换元素
public static void swap(int []arr,int a ,int b){
    int temp=arr[a];
    arr[a] = arr[b];
    arr[b] = temp;
}
```



###桶排序

核心思想就是将要排序的数据分到几个有序的桶里，每个桶里的数据再单独进行排序。桶内排序完成之后，再把每个桶里的数据按照顺序依次取出，组成的序列就是有序的了。一般步骤是：

- 先遍历一边序列，获得最大值和最小值，确定要排序的数据的范围，然后分为n个范围；
- 然后根据范围将数据分到桶中（可以选择桶的数量固定，也可以选择桶的大小固定）；
- 之后对每个桶进行排序；
- 之后将桶中的数据进行合并；

桶排序适合应用在外部排序（数据存储在磁盘中，数据量比较大，内存有限，无法将数据全部加载到内存中。）中。比如要排序的数据有 10 GB 的订单数据，但是内存只有几百 MB，无法一次性把  10GB 的数据全都加载到内存中。这个时候，就可以先扫描 10GB 的订单数据，然后确定一下订单数据的所处的范围。比如订单的范围位于 1~10 万元之间，那么可以将所有的数据划分到 100 个桶里。再依次扫描 10GB 的订单数据，把 1~1000 元之内的订单存放到第一个桶中，1001~2000 元之内的订单数据存放到第二个桶中，每个桶对应一个文件，文件的命名按照金额范围的大小顺序编号如 00、01，即第一个桶的数据输出到文件 00 中。

理想情况下，如果订单数据是均匀分布的话。但是，订单数据不一定是均匀分布的。划分之后可能还会存在比较大的文件，那就继续划分。比如订单金额在 1~1000 元之间的比较多，那就将这个区间继续划分为 10 个小区间，1~100、101~200 等等。如果划分之后还是很大，那么继续划分，直到所有的文件都能读入内存。



### 二分查找

```
int findByHalf(int[] array, int target) {
		if (array == null || array.length==0) {
			return -1;//代表没有合适的元素
		}
		int left = 0;
		int right = array.length-1;
		while(left<=right) {//需要注意是小于等于right，否则查找范围会是[left,right),会漏掉对最后一个元素的比较
				int middle = left + (right - left)/2;
				if(array[middle]<target) {
							left = middle+1;//跳过middle
				} else if (array[middle]>target) {
					right = middle-1;
				} else {
					return middle;
				}
		}
		return -1;//代表没有合适的元素
}
```

### 查找链表倒数第K个节点

```
public ListNode findKNode(ListNode node，int k) {
		if (head==null || k <= 0) {//空链表，或者k小于等于0
        return null;
    }
		ListNode quickNode = node;
		for(int i=0;i<k;i++) {
				if(quickNode == null) {
						return null;
				} else {
					quickNode = quickNode.next;
				}
		}
		ListNode slowNode = node;
		while(quickNode != null) {
					slowNode = slowNode.next;
					quickNode = quickNode.next;
		}
		return slowNode;
	}
```

### 链表反转

```
public ListNode reverseNode(ListNode node) {
		if(node==null ||node.next ==null) {
				return node;
		}
		//至少有两个节点
		ListNode first = node;
		ListNode second = node.next;
		ListNode three = second.next;
		first.next = null;
		while(second!=null) {
				second.next = first;
				first = second;
				second = three;
				if (three == null){break};
				else {
					three = three.next;
				}
		}
		return first;
}

```

### 查找第K大的数

### 快排解法

就是选左边的下标作为基准版，从首尾进行遍历，对元素交换，将大的元素交换到前面来，让序列变成递减的序列。然后根据当前的基准元素的下标i+1得到基准元素在序列中是第index大的元素，然后判断index与K的大小，相等就返回基准元素，index>K，说明第K大的数在左边，继续从左边的子序列中找，index<K，说明在右边，去右边的子序列中找。

平均时间复杂度O(2N)，最坏时间复杂度O(N的平方)

```java
 public static Integer findK(int[] array,int start,int end,int K) {
        if (array==null||array.length ==0|| start>=end) {
            return null;
        }

        int base = array[start];
        int i = start;
        int j = end;
        while (i<j) {
            while (array[j] < base && i<j) {j--;}
            while (array[i] >= base && i<j) {i++;}
            if (i<j) {
                int temp = array[i];
                array[i] = array[j];
                array[j] = temp;
            }
        }
        array[start] = array[i];
        array[i] = base;
        int index = i+1;//index代表array[i]是第几大的数
        if (index == K) {//如果array[]
            return array[i];
        } else if (index>K) {//说明数在左边的区间
            return findK(array, start, i-1, K);
        } else {//说明数在右边的区间
            return findK(array,i+1,end, K);
        }
 }
```

### 堆排写法

PriorityQueue是一个优先级队列，可以认为是一个小顶堆，每次poll元素出来都是poll出最小的元素，所以queue中包含K个元素，每次遍历时将元素添加到queue中，并且将最小的元素poll出。

```java
private static Integer findKWayTwo(int array[], int K) {
				PriorityQueue<Integer> queue = new PriorityQueue<Integer>();
        for (int i = 0; i < array.length; i++) {
            queue.add(array[i]);
            if (queue.size()>K) {
                queue.poll();
            }
        }
        return queue.peek();
}
```

### 插入排序解法

就是一个长度为K的排序好的序列，每次遍历时拿元素A与这个序列里面的最小元素B进行比较，A>B，就将A往排序好的序列里面插入。

```java
public static Integer findKByPickSort(int[] input, int k) {
        ArrayList<Integer> arrayList = new ArrayList<Integer>();
        if(input==null || input.length==0 ||input.length<k || k == 0) {
            return null;
        }
        arrayList.add(input[0]);
        for (int i = 1; i < input.length; i++) {
            if (arrayList.size() < k) {//子数组个数没有达到K
                arrayList.add(input[i]);
            } else if (input[i] > arrayList.get(arrayList.size()-1)) {//子数组个数达到了K，并且当前数比子数组最后一个数小
                arrayList.remove(arrayList.size()-1);
                arrayList.add(input[i]);
            } else {
                continue;
            }
            //将最后一个元素移动合适的位置
            for (int j = arrayList.size()-1; j > 0 ; j--) {
                if (arrayList.get(j) > arrayList.get(j-1)) {
                    int temp = arrayList.get(j);
                    arrayList.set(j, arrayList.get(j-1));
                    arrayList.set(j-1, temp);
                }
            }
        }
        return arrayList.get(k-1);
    }
```
#### 有一个1G大小的一个文件，里面每一行是一个词，词的大小不超过16字节，内存限制大小是1M。返回频数最高的100个词.
首先这个问题的难点在于内存太小，1M/16 byte =64，也就是在极端情况下，单词都是16字节时，内存中可能最多存储64个。

执行流程如下：
1.由于内存限制是1M，所以如果每个小文件小于1M以下才能全部加载到内存中，所以可以设置模为5000，遍历每个单词，对单词取hash值%5000，得到index，写入到index名的小文件下，理论上这样的是可以达到每个小文件都是小于1M的，如果大于1M，需要对文件继续进行hash运算，切分成小文件。

2.遍历每个小文件，使用堆排的方法对小文件进行排序，记录每个单词的出现次数，写入一个新的记录次数的小文件。

3.然后取一个记录次数的文件，建了一个包含100个单词的小顶堆，遍历一次所有记录次数文件，得到前100。（由于内存中是存不了100个单词的，所以我们内存中只存堆顶元素，小顶堆是存在磁盘中，每次需要调整堆的时候再去磁盘中读取一部分元素然后进行调整，得到新的堆顶元素。）

### 全排序问题
就是给定一个字符串，返回所有可能的排序结果。例如aba的排序结果有aba,aab,baa。可以认为每一个字符串的排序结果是等于每个非重复字母出现在第一个index+后面子序列每个的组合。
```java
//用于收集每种序列
ArrayList<String> list = new ArrayList<String>();
public void PermutationHelper(char[] charArray,int start) {
    if (charArray == null || charArray.length == 0) {
        return;
    }
    if(start == charArray.length-1) {//最后一个元素
        list.add(String.valueOf(charArray));
        return;
    }
    HashSet<Character> set = new HashSet<Character>();
    for(int i = start;i<charArray.length;i++) {
        if(set.contains(charArray[i]) == false) {
            set.add(charArray[i]);
            //交换
            char temp = charArray[i];
            charArray[i] = charArray[start];
            charArray[start] = temp;
          
            PermutationHelper(charArray,start+1);
            //交换
            charArray[start] = charArray[i];
            charArray[i] = temp;
        }
    }
}
```

### 字符串的最长不重复子串的长度
就是使用滑动窗口来实现，一开始窗口左右节点都等于0，窗口右节点的元素在Set不存在，就添加，然后右节点右移动，然后计算当前窗口大小，如果大于之前存的最大窗口值就替换。如果在Set中存在，那么就Set移除左节点中的值，左节点+1。
```java
int findNotDuplicateStringMaxLength(String string) {
    if (string == null || string.length() == 0) {
        return 0;
    }
    char[] array = string.toCharArray();
    int slow = 0;
    int quick = 0;
    int maxLength=0;
    Set<Character> set       = new HashSet<Character>();
    while (quick<array.length){
        if (set.contains(array[quick]) == true) {//有重复的,窗口左边移动
            set.remove(array[slow]);
            slow++;
        } else {//没有重复
            set.add(array[quick]);
            maxLength = quick - slow +1 > maxLength ? quick - slow +1  : maxLength;
            quick++;
        }
    }
    return maxLength;
}
```

### 9 个硬币中有一个劣币，用天平秤，最坏几次？

最坏是3次可以称出来。

**第一次称**，123 VS 456，

* 如果平衡，那么说明剩下的789里面有劣币，
然后**第二次称**7VS8，平衡，9就是劣币，否则7和8中有一个是劣币，那么**第三次称**拿真币1和7来称，如果平衡则8是假币，不相等则7是假币。
* 如果不平衡，说明现在的123，456个币中有一个是劣质币
假设
重的那一组是1 2 3
轻的那一组 4 5 6
由于**假币的所在的组要么会一直重(如果假币比真币重)，要么会一直轻(如果假币比真币轻)，所以如果一会在重组一会在轻组出现的肯定是真币**。
所以我们先去掉3和6，并且将2和5进行调换，也就是**第二次称**对15和42进行称。
1 5
4 2
* 假设天平平了，说明15和42都是真币，3和5才假币，**第三次称**拿一个其他的币与3称，相同则5是假币，不相等则3是假币。
* 假设天平没有平，并且1 5是重的那一方，由于不平衡，所以排除3和6，由于在之前4 5 6是轻的一方，现在1 5又是重的一方，所以排除5，5不会是假币，同理也排除2，所以只有1和4有可能是假币，**第三次称**拿一个其他的币与1称，平衡则4是假币，不相等则1是假币。
* 假设天平没有平，并且1 5是轻的那一方，由于不平衡，所以排除3和6，同理根据上面的原理，可以排除一会在重组一会在轻组的1，4，所以2和5有可能是假币。同理**第三次称**可以得出2和5谁是假币

### 12个硬币，里面有一个假币

分成四组，**第一次称**1234 VS 5678

1.平衡说明假币在9 10 11 12中，**第二次称**9 10 VS 真币1 真币2，
* 平衡代表11，12中存在假币，**第三次称**11 VS 真币1，平衡代表12是假币，否则11是假币。
* 同理不平衡，说明9 10存在假币，对9和10实时上面的称法。

2.不平衡，说明假币存在于1到8中，
假设
重组是1 2 3 4 
轻组是5 6 7 8

加一个真币X，好分成三组，为了提高区分度，
第一组 1 2 5(两个重组元素+一个轻组元素)
第二组 3 6 X(一个轻组元素+一个重组元素+一个真币)
**第二次称**1 2 5 VS  3 6 X 
* 假设平衡，说明4，7，8中存在假币，称一下7和8，平衡，那么4是假币，不平衡，由于一会在重组的，一会在轻组的肯定是真币，而7，8之前都在轻组，所以7和8对称时，轻的是假币。
* 假设1 2 5 重，由于一会在重组的，一会在轻组的肯定是真币，根据这个原则，5，3肯定是真币，所以只有1，2，6存在可能。同理，根据上面的方法**第三次称**找出假币
* 话说1 2 5轻，由于一会在重组的，一会在轻组的肯定是真币，根据这个原则，可以排除1，2，它们是真币。只有3和5存在可能，**第三次称**找出假币。

### 编辑距离
递归解法
```java
// 假设是要将a变成b的样子
static int findMinValue(char[] a, int aLength, char[] b, int bLength) {
    if (a == null || aLength <= 0) {  return bLength;}
    if (b == null || bLength <= 0) {   return aLength;  }
    if (a[aLength - 1] == b[bLength - 1]) {//相等就前移
        return findMinValue(a, aLength - 1, b, bLength - 1);
    } else {
        //a进行插入，相当于是b可以进行前移
        int first = findMinValue(a, aLength, b, bLength - 1) + 1;
        //a进行删除，相当于a可以进行前移
        int second = findMinValue(a, aLength - 1, b, bLength) + 1;
        //a进行替换，相当于a，b都前移
        int three = findMinValue(a, aLength - 1, b, bLength - 1) + 1;
        int min = first < second ? first : second;
        return min < three ? min : three;
    }
}
```
动态规划解法
```java
static int findMinValueInNewWay(char[] a, int aLength, char[] b, int bLength) {
    int [][] dp = new int[aLength][bLength];
    //这里就是假设b字符串为空时，a的每个子串的编辑距离，也就等于每个子串的长度。
    for (int i = 0; i < aLength; i++) { dp[i][0] = i+1;  }
   //同理，这里是假设a字符串为空
    for (int j = 0; j < aLength; j++) {   dp[0][j] = j+1;}
		//计算a，b每个子串的之间的编辑距离
    for (int i = 1; i < aLength; i++) {
        for (int j = 1; j < bLength; j++) {
            if (a[i] == b[j]) {
                dp[i][j] = dp[i-1][j-1];
            } else {
                //替换 对a当前遍历下标的值进行替换，相当于a，b各减掉一个字符
                int first = dp[i-1][j-1]+1;
                //查 a进行插入b当前下标的字符，相当于b减掉一个字符
                int second = dp[i][j-1] +1;
                //a删除一个元素
                int three = dp[i-1][j] +1;
                int min = first < second ? first : second;
                dp[i][j] = min < three ? min : three;
            }
        }
    }
    return dp[aLength-1][bLength-1];
}
```



### 打印杨辉三角
思路其实是使用一个数组来存储上一层节点的值，然后根据每个节点index去数组中可以取值，父左节点的下标等于index-1，父右节点的下标等于index。

```java
static void printYanghui(int rows) {
    int[] a = new int[rows];
    a[0] = 1;
    //i代表第几层
    for (int i = 0; i < rows; i++) {
        int left = 0;
        int right;
        //j代表这个元素在这一层是第几个，也就是元素在当前层数的序号
        for (int j = 0; j <= i; j++) {
            //每个元素右边的父节点的序号其实跟这个元素的序号是一样的
            right = a[j];
            //每个节点的值是等于父左节点+父右节点
            a[j] = left + right;
            System.out.print(" " +a[j]);
            //当前父右节点其实是下一个元素的父左节点，由于上面已经对a[j]进行赋新值，
            // 所以需要使用left来存
            left = right;
        }
        System.out.println(" ");
    }
}
```

数学解法

或者根据一个数学规律来计算，就是每一层一开始是数都是1，假设前一个数是a，后面的数b，满足b = a*(上一层的层数-a的下标)/(a的下标+1)

```
static void test2(int rows) {
    for (int i = 0; i < rows; i++) {
        int index = 1;
        for (int j = 0; j <= i; j++) {
            System.out.print(" " + index);
            index = index * (i - j)/(j+1);
        }
        System.out.println(" ");
    }
}
```