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

```
public ListNode findLastNode(ListNode node) {
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

```
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

