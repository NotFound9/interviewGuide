## LeetCode 热门100题-题解(上)

##### 主要是记录自己刷题的过程，也方便自己复习

##### [第1题-两数之和](#第1题-两数之和)
##### [第206题-反转链表](#第206题-反转链表)

##### [第2题-两数相加](#第2题-两数相加)
##### [第3题-无重复字符的最长子串](#第3题-无重复字符的最长子串)
##### [第20题-有效的括号](#第20题-有效的括号)
##### [第5题-最长回文子串](#第5题-最长回文子串)
##### [第19题-删除链表的倒数第N个节点](#第19题-删除链表的倒数第N个节点)
##### [第121题-买卖股票的最佳时机](#第121题-买卖股票的最佳时机)
##### [第70题-爬楼梯](#第70题-爬楼梯)
##### [第53题-最大子序和](#第53题-最大子序和)
##### [第21题-合并两个有序链表](#第21题-合并两个有序链表)
##### [第283题-移动零](#第283题-移动零)
##### [第34题-在排序数组中查找元素的第一个和最后一个位置](#第34题-在排序数组中查找元素的第一个和最后一个位置)
##### [第11题-盛最多水的容器](#第11题-盛最多水的容器)
##### [第17题-电话号码的字母组合](#第17题-电话号码的字母组合)
##### [第15题-三数之和](#第15题-三数之和)
##### [第141题-环形链表](#第141题-环形链表)
##### [第104题-二叉树的最大深度](#第104题-二叉树的最大深度)  
##### [第22题-括号生成](#第22题-括号生成)
##### [第102题-二叉树的层序遍历](#第102题-二叉树的层序遍历)
##### [第198题-打家劫舍](#第198题-打家劫舍)
##### [第46题-全排列](#第46题-全排列)
##### [第55题-跳跃游戏](#第55题-跳跃游戏)
##### [第62题-不同路径](#第62题-不同路径)
##### [第56题-合并区间](#第56题-合并区间)
##### [第169题-多数元素](#第169题-多数元素)
##### [第101题-对称二叉树](#第101题-对称二叉树)
##### [第136题-只出现一次的数字](#第136题-只出现一次的数字)
##### [第23题-合并K个升序链表](#第23题-合并K个升序链表)
##### [第94题-二叉树的中序遍历](#第94题-二叉树的中序遍历)
##### [第64题-最小路径和](#第64题-最小路径和)
##### [第215题- 数组中的第K个最大元素](#第215题-数组中的第K个最大元素)

##### [第234题- 回文链表](#第234题-回文链表)
##### [第200题-岛屿数量](#第200题-岛屿数量)
##### [第48题-旋转图像](#第48题-旋转图像)
##### [第98题-验证二叉搜索树](#第98题-验证二叉搜索树)
##### [第78题-子集](#第78题-子集)
##### [第75题-颜色分类](#第75题-颜色分类)
##### [第39题-组合总和](#第39题-组合总和)
##### [第226题-翻转二叉树](#第226题-翻转二叉树)
##### [第31题-下一个排列](#第31题-下一个排列)
##### [第322题-零钱兑换](#第322题-零钱兑换)
##### [第300题-最长递增子序列](#第300题-最长递增子序列)

### 第1题-两数之和

#### 题目描述
题目详情：https://leetcode-cn.com/problems/two-sum/
给定一个整数数组 nums 和一个目标值 target，请你在该数组中找出和为目标值的那 两个 整数，并返回他们的数组下标。

你可以假设每种输入只会对应一个答案。但是，数组中同一个元素不能使用两遍。

 ```
示例:
给定 nums = [2, 7, 11, 15], target = 9
因为 nums[0] + nums[1] = 2 + 7 = 9
所以返回 [0, 1]
 ```

#### 思路

其实也没啥好说的，就是对数组进行遍历，遍历时将target-nums[i]得到需要的值needValue，判断hashMap中是否存在这个needValue，存在就直接返回了，不存在就将nums[i]添加到hashMap，继续遍历。

```java
import java.util.HashMap;
class Solution {
    HashMap<Integer,Integer> hashMap = new HashMap<Integer,Integer>();
    public int[] twoSum(int[] nums, int target) {
        if(nums==null||nums.length==0) {return null;}
        for(int i = 0;i<nums.length;i++) {
            int needValue = target - nums[i];
            if(hashMap.containsKey(needValue)) {
                int[] array = new int[2];
                array[0] = hashMap.get(needValue);
                array[1] = i;
                return array;
            }
            hashMap.put(nums[i],i);   
        }
        return null;
    }
 }
```

### 第206题-反转链表
题目详情：https://leetcode-cn.com/problems/reverse-linked-list/

#### 题目描述：

反转一个单链表。

**示例:**

```j&#39;a
输入: 1->2->3->4->5->NULL
输出: 5->4->3->2->1->NULL
```
#### 解题思路

循环的思路就是遍历节点，保存每个节点的下一个节点，然后将当前节点的next指针指向上一个节点，一直反转到最后。需要注意的地方就是需要将原链表头结点head的next指针置为null，否则会形成环。

#### 循环的解法：

```java
class Solution {
    public ListNode reverseList(ListNode head) {
        if(head==null||head.next==null){return head;}
        ListNode preNode = head;
        ListNode currentNode = head.next;
      	//将原来头结点的next指针设置为null
        head.next = null;
        while(currentNode!=null) {
          	//保存指向下一个节点的指针
            ListNode saveNode = currentNode.next;
          	//将当前节点的next指向前一个节点
            currentNode.next = preNode;
            preNode = currentNode;
            currentNode = saveNode;
        }
        return preNode;
    }
}
```

#### 递归解法

就是一直递归，然后将每个节点的next节点的next指针指向当前节点

```java
ListNode newHead = null;
public static ListNode reverseList(ListNode node) {
    if(node==null){return node;}
    if(node.next==null) {//说明是旧链表的尾节点，设置为新链表的头
        newHead = node;
        return newHead;
    }
    ListNode nextNode = node.next;
    reverseList(nextNode);
    nextNode.next = node;
    //这个其实主要是为了将旧链表的头结点设置为null
    node.next = null;
    return newHead;
}
```
### 第3题-无重复字符的最长子串
题目详情：https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/

#### 题目描述：

给定一个字符串，请你找出其中不含有重复字符的 最长子串 的长度。

示例 1:

输入: "abcabcbb"
输出: 3 
解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
示例 2:

输入: "bbbbb"
输出: 1
解释: 因为无重复字符的最长子串是 "b"，所以其长度为 1。
示例 3:

输入: "pwwkew"
输出: 3
解释: 因为无重复字符的最长子串是 "wke"，所以其长度为 3。
     请注意，你的答案必须是 子串 的长度，"pwke" 是一个子序列，不是子串。

#### 解题思路

就是用滑动窗口，初始left指针指向第一个元素，right指针指向第二个元素，然后在while循环中判断，set中是否包含right指针当前的字符（set会包含left到right之间所有的字符）

1.包含，说明之前窗口已经出现了right指针当前的字符，那么从set中移除left指针对应的字符，然后left指针右移。

2.不包含，说明之前窗口没有出现right指针当前的字符，那么更新最大窗口值max，并且right指针右移。

```java
public int lengthOfLongestSubstring(String s) {
    if(s==null||s.length()==0) {
        return 0;
    }
    HashSet<Character> set = new HashSet<Character>();
    int left = 0;
    int right = 1;
    int max=1;
    char[] array = s.toCharArray();
    set.add(array[0]);
    while(right<array.length) {
        if(set.contains(array[right])) {
            set.remove(array[left]);
            left++;
        } else {
            set.add(array[right]);
            max = right - left + 1 > max ? right - left + 1:max;
            right++;
        }
    }
    return max;
}
```
### 第2题-两数相加
题目详情：https://leetcode-cn.com/problems/add-two-numbers/

#### 题目详情：

给出两个 非空 的链表用来表示两个非负的整数。其中，它们各自的位数是按照逆序的方式存储的，并且它们的每个节点只能存储 一位 数字。

如果，我们将这两个数相加起来，则会返回一个新的链表来表示它们的和。

您可以假设除了数字 0 之外，这两个数都不会以 0 开头。

示例：

输入：(2 -> 4 -> 3) + (5 -> 6 -> 4)
输出：7 -> 0 -> 8
原因：342 + 465 = 807

#### 解题思路

有点像是合并链表，不过合并时是将两个原链表的节点值相加，得到一个新节点的值，主要需要考虑相加时的进位问题。如果链表还没有遍历完，进位只需要将carryFlag设置为1，下次循环时，计算sum时加1就好了，主要是当存在一个链表遍历完了时，这里采取的策略是：

* 1.如果carryFlag为0，不需要考虑进位，将另外一个链表添加到新链表后面，结束循环。
* 2.如果carryFlag为1，需要考虑进位，
  * 2.1两个链表都为空，那么建一个值为1的节点添加到新链表最后面，结束循环。
  * 2.2链表l1为空，那么一个值为1的节点到链表l1的末尾，继续循环。
  * 2.3链表l2为空，那么一个值为1的节点到链表l2的末尾，继续循环。

```java
public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
    ListNode head = new ListNode(-1);
    ListNode currentNode = head;
    int carryFlag = 0;
    while(l1!=null&&l2!=null) {
        int sum = l1.val+l2.val;
        if(carryFlag==1) {
            sum++;
            carryFlag=0;
        }
        if(sum>=10) {
            sum = sum%10;
            carryFlag = 1;
        }
        ListNode node = new ListNode(sum);
        currentNode.next = node;
        currentNode = node;
        if(l1.next == null || l2.next == null) {//将后面的拼过来            
            if(carryFlag == 0) {//没有进位，直接将剩余链表接过来
                currentNode.next = l1.next == null ? l2.next : l1.next;
                break;
            } else {
              //两个链表都到末尾了，并且有进位就建新节点
                if(l1.next == null && l2.next == null) {
                    currentNode.next = new ListNode(1);
                    break;
                } else if(l1.next == null) {//只是链表1后面没有节点了，添加一个新节点到链表1后面
                    l1.next = new ListNode(1);
                    carryFlag=0;
                } else {//只是链表2后面没有节点了，添加一个新节点到链表1后面
                    l2.next = new ListNode(1);
                    carryFlag=0;
                }
            }
        }
        l1=l1.next;
        l2=l2.next;
    }
    return head.next;
}
```

### 第20题-有效的括号
题目详情：https://leetcode-cn.com/problems/valid-parentheses/

#### 题目描述

给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。

有效字符串需满足：

左括号必须用相同类型的右括号闭合。
左括号必须以正确的顺序闭合。
注意空字符串可被认为是有效字符串。

```java
示例 1:

输入: "()"
输出: true
示例 2:

输入: "()[]{}"
输出: true
示例 3:

输入: "(]"
输出: false
示例 4:

输入: "([)]"
输出: false
示例 5:

输入: "{[]}"
输出: true
```

#### 解题思路

就是遍历字符串，

字符属于左括号就添加到栈中，

字符属于右括号就判断是否属于与栈顶元素对应，是的话可以将栈顶出栈，不是的话就说明不匹配，返回 false。遍历完成需要判断栈的长度是否为0，不为0代表还存在没有匹配上的左括号，不满足要求。 

```java
class Solution {
    public boolean isValid(String s) {
        char[] array = s.toCharArray();
        HashMap<Character,Character> map = new HashMap<Character,Character>();
        map.put('(',')');
        map.put('[',']');
        map.put('{','}');
        Stack<Character> stack = new Stack<Character>();
        for(int i = 0 ; i < array.length ; i++) {
            char c = array[i];
            if(map.containsKey(c)) {
                stack.push(map.get(c));
            } else {
                if (stack.size() > 0 && c == stack.peek()) {
                    stack.pop();
                } else {
                    return false;
                }
            }
        }
        return stack.size() == 0 ? true : false;
    }
}
```


### 第5题-最长回文子串
题目详情：https://leetcode-cn.com/problems/longest-palindromic-substring/

#### 题目详情

给定一个字符串 `s`，找到 `s` 中最长的回文子串。你可以假设 `s` 的最大长度为 1000。

**示例 1：**

```
输入: "babad"
输出: "bab"
注意: "aba" 也是一个有效答案。
```

**示例 2：**

```
输入: "cbbd"
输出: "bb"
```

#### 解题思路

就是遍历字符串，

1.判断每个字符i，是否与上一个字符i-1回文，是的话从i-1向左，i向右，双指针判断，找出最长回文字符串。

2.判断每个字符i，它的前一个字符i-1与后一个字符i+1是否回文，是的话，i-1向左，i+1向右，双指针判断，找出最长回文字符串。

时间复杂度是O(N^2)，空间复杂度是O(1)

```java
class Solution {
    public String longestPalindrome(String s) {
        if(s ==null || s.length()<=1) {
            return s;
        }
        char[] array = s.toCharArray();
        String maxString = String.valueOf(array[0]);
        for(int i = 1;i<array.length;i++) {
          //判断是否是偶数回文串
            if(array[i] == array[i-1]) {//i跟i-1对称
                String value = findMax(s, i-1,i);
                maxString = maxString.length() < value.length() ? value : maxString;
            } 
          	//判断是否是奇数回文串
            if (i+1 <= array.length -1 && array[i-1] == array[i+1]) {//i+1跟i-1对称
                String value = findMax(s, i-1,i+1);
                maxString = maxString.length() < value.length() ? value : maxString;
            }
        }
        return maxString;
    }

    String findMax(String string,int left, int right) {
        char[] array = string.toCharArray();
        while(left >=0 && right <= array.length-1 && array[left] == array[right]) {
                    left--;
                    right++;
                }
        //subString是一个左闭右开区间，也就是会包含左边界的值，但是不包含右边界的值，而我们应该要取的值是left+1到right-1。
        return string.substring(left+1,right);
    }
}
```
### 第121题-买卖股票的最佳时机
题目详情：https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/

#### 题目介绍

给定一个数组，它的第 *i* 个元素是一支给定股票第 *i* 天的价格。

如果你最多只允许完成一笔交易（即买入和卖出一支股票一次），设计一个算法来计算你所能获取的最大利润。

注意：你不能在买入股票前卖出股票。

**示例 1:**

```
输入: [7,1,5,3,6,4]
输出: 5
解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
     注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格；同时，你不能在买入前卖出股票。
```

**示例 2:**

```
输入: [7,6,4,3,1]
输出: 0
解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
```

#### 解题思路

这个题就是使用min变量记录之前出现的值，使用maxValue保存之前的最大差值，对数组遍历，将当前股票价格prices[i]-min得到利润，如果比maxValue大那么就进行替换，并且如果prices[i]比min变量小，那么也替换出现过的最小值。

```java
class Solution {
    public int maxProfit(int[] prices) {
        if(prices==null||prices.length<=1){
            return 0;
        }
        int min = prices[0];//之前出现的最小值
        int maxValue = 0;//之前计算得到的最大差值
        for(int i = 1; i < prices.length; i++) {
            maxValue = prices[i] - min > maxValue ? prices[i] - min : maxValue;
            min = prices[i] < min ? prices[i] : min; 
        }
        return maxValue;
    }
}
```
### 第70题-爬楼梯
题目详情：https://leetcode-cn.com/problems/climbing-stairs/

#### 题目介绍

假设你正在爬楼梯。需要 *n* 阶你才能到达楼顶。

每次你可以爬 1 或 2 个台阶。你有多少种不同的方法可以爬到楼顶呢？

**注意：**给定 *n* 是一个正整数。

**示例 1：**

```
输入： 2
输出： 2
解释： 有两种方法可以爬到楼顶。
1.  1 阶 + 1 阶
2.  2 阶
```

**示例 2：**

```
输入： 3
输出： 3
解释： 有三种方法可以爬到楼顶。
1.  1 阶 + 1 阶 + 1 阶
2.  1 阶 + 2 阶
3.  2 阶 + 1 阶
```

#### 解题思路

这个就是斐波拉契数列，就是f(n) = f(n-1)+f(n-2),需要注意的是，如果使用递归来实现，会有重复计算重叠子问题的问题。比如f(5)=f(4)+f(3)=(f(3)+f(2))+(f(2)+f(1))  其实是计算了两遍f(3)，所以可以使用hashMap来缓存f(3)的结果，这样避免重复递归计算。 

```java
class Solution {
    HashMap<Integer,Integer> map = new HashMap<Integer,Integer>();
    public int climbStairs(int n) {
        if(n <= 0) {return 0;}
        else if(n == 1 || n == 2) {
            return n;
        } else if (map.containsKey(n)) {
            return map.get(n);
        } else {
            int value = climbStairs(n-1) + climbStairs(n-2);
            map.put(n,value);
            return value;
        }
    }
}
```
### 第53题-最大子序和
题目详情：https://leetcode-cn.com/problems/maximum-subarray/

#### 题目介绍

给定一个整数数组 `nums` ，找到一个具有最大和的连续子数组（子数组最少包含一个元素），返回其最大和。

**示例:**

```
输入: [-2,1,-3,4,-1,2,1,-5,4]
输出: 6
解释: 连续子数组 [4,-1,2,1] 的和最大，为 6。
```
#### 解题思路

就是遍历一遍，判断包含从0到当前遍历值i的最大子序列和，

如果sum<0，那么就丢掉之前的子序列，直接让sum=nums[i]，

如果sum>0否则sum=sum+nums[i]

计算后的sum如果大于maxSum，那么就进行替换。


```java 
class Solution {
    public int maxSubArray(int[] nums) {
        if(nums==null||nums.length==0) {
            return 0;
        }
        if(nums.length==1) {
            return nums[0];
        }
        int maxSum = nums[0];
        int sum = nums[0];
        for(int i = 1; i < nums.length; i++) {
            sum = sum < 0 ? nums[i] : sum + nums[i]; 
            maxSum = sum > maxSum ? sum : maxSum;
        }
        return maxSum;
    }
    
}
```


### 第19题-删除链表的倒数第N个节点
题目详情：https://leetcode-cn.com/problems/remove-nth-node-from-end-of-list/

#### 题目介绍

给定一个链表，删除链表的倒数第 *n* 个节点，并且返回链表的头结点。

**示例：**

```
给定一个链表: 1->2->3->4->5, 和 n = 2.

当删除了倒数第二个节点后，链表变为 1->2->3->5.
```

**说明：**

给定的 *n* 保证是有效的。

#### 解题思路

就是用快慢指针，快指针quickNode先走n步，然后慢指针slowNode从链表头部出发，每次quickNode和slowNode都只走一步，直到快指针quickNode走到最后一步，此时slowNode与quickNode之间相差n步，其实是此时slowNode是倒数第n+1个节点，也就是要删除的节点的前一个节点，直接将slowNode.next = slowNode.next.next;，就可以将节点删除。

但是需要考虑到如果删除的是头结点，此时会比较麻烦，严格意义上，m个节点，头结点与最后一个节点之间只存在m-1个节点的间隔，也就是只能走m-1步，所以解决方案就是先建一个临时节点加在头结点前面，这样就可以走出m步了，也就是可以删除倒数第m个节点，也就是头结点了。

```java
class Solution {
    public ListNode removeNthFromEnd(ListNode head, int n) {
        //因为head有可能是要被删除的节点，所以需要建一个preHead方便操作
        ListNode preHead = new ListNode();
        preHead.next = head;
        ListNode quickNode = preHead;
        while(n>0) {
            quickNode = quickNode.next;
            n--;
        }
        ListNode slowNode = preHead;//preDeleteNode就是要删除的节点的前一个节点
        while(quickNode.next!=null) {//这个循环遍历完可以保证quickNode是最后一个节点
            quickNode = quickNode.next;
            slowNode = slowNode.next;
        }
        slowNode.next = slowNode.next.next;
        return preHead.next;
    }
}
```


### 第21题-合并两个有序链表
题目详情：https://leetcode-cn.com/problems/merge-two-sorted-lists/

#### 题目介绍

将两个升序链表合并为一个新的 **升序** 链表并返回。新链表是通过拼接给定的两个链表的所有节点组成的。  

**示例：**

```
输入：1->2->4, 1->3->4
输出：1->1->2->3->4->4
```

#### 解题思路

就是创建一个preNode，作为头结点前面的节点，再创建一个currentNode作为实际遍历时的节点，每次从链表l1和l2各取出节点，进行比较，val较小的节点赋值给currentNode的next指针，然后再将currentNode后移，链表中的节点进行后移。直到某个链表遍历完毕了，然后将另外一个链表后续的节点接到currentNode的next指针上。

```java
public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
    if(l1==null) {return l2;}
    if(l2==null) {return l1;}
    ListNode preHead = new ListNode();
    ListNode currentNode = preHead;
    while(l1!=null && l2!=null) {
        if(l1.val < l2.val) {
            currentNode.next = l1;
            currentNode = currentNode.next;
            l1 =l1.next;
        } else {
            currentNode.next = l2;
            currentNode = currentNode.next;
            l2 =l2.next;
        }
    }
    if(l1!=null) {currentNode.next = l1;}
    if(l2!=null) {currentNode.next = l2;}
    return preHead.next;
}
```

### 第283题-移动零

给定一个数组 `nums`，编写一个函数将所有 `0` 移动到数组的末尾，同时保持非零元素的相对顺序。

题目详情：https://leetcode-cn.com/problems/move-zeroes/

```
输入: [0,1,0,3,12]
输出: [1,3,12,0,0]
```

解题思路：

对数组进行遍历，就是找到一个为0的数，然后继续往后找，找到一个不为0的数，与它进行交换，这样就可以把0全部移动到后面去了。

```java
public void moveZeroes(int[] nums) {
      if(nums==null || nums.length<=1) { return;}
      int slow = 0,quick = 0;
      while (slow<nums.length && quick<nums.length) {
        //找到第一个为0的数nums[slow]
        while (slow < nums.length && nums[slow] != 0) { slow++;}
        quick = slow;
        //从这个为0的数往后找到第一个不为0的数nums[quick]
        while (quick < nums.length && nums[quick] == 0 ) { quick++;}
        //将nums[slow]与nums[quick]进行交换
        if (slow < nums.length && quick < nums.length) {
          nums[slow] = nums[quick];
          nums[quick] = 0;
        }
      }
}
```

一种更简洁的写法：可以认为是用一个指针记录一下前面的空位置，然后从数组后面元素找到一个不为0的数字，填充到这个空位置上去。

```java
public void moveZeroes(int* nums, int numsSize) {
    int i = 0,j = 0;
    for(i = 0 ; i < numsSize; i++)
    {
        if(nums[i] != 0)
        {
            nums[j++] = nums[i];
        }
    }
    while(j < numsSize)
    {
        nums[j++] = 0;
    }
}
```

### 第34题-在排序数组中查找元素的第一个和最后一个位置

给定一个按照升序排列的整数数组 nums，和一个目标值 target。找出给定目标值在数组中的开始位置和结束位置。

如果数组中不存在目标值 target，返回 [-1, -1]。

##### 思路：
其实可以用普通的二分查找，查到这个target值，然后向两边遍历，获得起始和结束位置，复杂度是log(N)+right-left,但是如果目标值的的开始位置left接近于0，结束位置right接近于length-1，right-left就会接近于N，此时复杂度为O(N)。
这里的解题思路是O(LogN)的一种解法，就是通过先找出一种查找左边界的二分查找算法（可以理解为可以从数组中查找出第一个>=输入值的元素下标)，所以本题可以通过找出target-0.5查找左边界，得到target的最左边的值，同时通过找出target+0.5查找出第一个大于目标值的元素下标，然后-1得到taget最右边的值。（当然也需要考虑taget不存在的情况）

```java
public int[] searchRange(int[] nums, int target) {
    int[] array = new int[2];
    array[0]=-1;
    array[1]=-1;
    if (nums==null||nums.length==0) {
        return array;
    }
    int left = findLeftBound(nums,target-0.5);
    int right = findLeftBound(nums,target+0.5);
    if (left==-1) {//nums不存在这个target值
        return array;
    }
    if (right==-1) {//taget值可能是数组最后一个元素
        right = nums.length-1;
    } else {//right是第一个大于target的值，减一得到target的右边界
        right = right -1;
    }
    //如果相等，那么返回下标
    if (nums[left] == target && nums[right] == target) {
        array[0] = left;
        array[1] = right;
        return array;
    }
    return array;
}
//查找target值的左边界（也就是第一个>=target的元素下标）
int findLeftBound(int[] nums,double target) {
    int left = 0;
    int right = nums.length-1;
    while (left<=right) {
        int mid = left+(right-left)/2;
        if (nums[mid] == target) {
            right=mid-1;
        } else if (nums[mid]>target) {
            right = mid-1;
        } else if (nums[mid]<target) {
            left = mid+1;
        }
    }
    if (left>=nums.length) {
        return -1;
    } else {
        return left;
    }
}
```
### 第11题-盛最多水的容器

给你 n 个非负整数 a1，a2，...，an，每个数代表坐标中的一个点 (i, ai) 。在坐标内画 n 条垂直线，垂直线 i 的两个端点分别为 (i, ai) 和 (i, 0) 。找出其中的两条线，使得它们与 x 轴共同构成的容器可以容纳最多的水。

说明：你不能倾斜容器。
示例 1：

![img](../static/question_11.jpg)输入：[1,8,6,2,5,4,8,3,7]
输出：49 
解释：图中垂直线代表输入数组 [1,8,6,2,5,4,8,3,7]。在此情况下，容器能够容纳水（表示为蓝色部分）的最大值为 49。

##### 解题思路

我们取两个指针从数组的两端往内遍历，i从数组头部出发，j从数组尾部出发。每次计算最大面积，并且移动高度较小的那个端点。

对于两个端点i和j来说，容纳水的面积是是等于(j-i)*min(height[i],height[j])，假设height[i]是两者之间较小的那一个，那么面积等于(j-i)*height[i],假设i不移动，j向左移动，这样宽度j-i会减少，而height[j]即便变大也不会使得面积变大，因为面积是由宽度乘以两者中较小的高度决定的，所以此时的面积对于i这个端点来说，已经是最大的面积，我们可以右移高度较小的端点i。

```java
public int maxArea(int[] height) {
        if (height==null||height.length==0) {return 0;}
        int left =0;
        int right = height.length-1;
        int maxArea = 0;
        while (left<right) {
          	//每次都是移动height[i]较小的那个端点
            if (height[left]<height[right]) {
                int area = height[left] * (right-left);
                maxArea = maxArea > area ? maxArea : area;
                left++;
            } else {
                int area = height[right] * (right-left);
                maxArea = maxArea > area ? maxArea : area;
                right--;
            }
        }
        return maxArea;
    }
```
### 第17题-电话号码的字母组合
给定一个仅包含数字 2-9 的字符串，返回所有它能表示的字母组合。
给出数字到字母的映射如下（与电话按键相同）。注意 1 不对应任何字母。

示例:

输入："23"
输出：["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"].

##### 解题思路：
                         ""
           "a"           "b"            "c"      
      "d" "e" "f"    "d" "e" "f"    "d" "e" "f"
    "ad" "ae" "af" "bd" "be" "bf"  "cd" "ce" "cf"
其实可以认为这是一个多叉树，根节点到叶子节点的路径就是每一种字符的组合，然后我们可以通过宽度遍历的方式来得到根节点到叶子节点路径。


```java
public List<String> letterCombinations(String digits) {
        List<String> list = new ArrayList<String>();
        if (digits==null || digits.length() ==0) {
            return list;
        }
        LinkedList<String> queue = new LinkedList<>();
        // 空字符串是作为多叉树的根节点
        queue.add("");
        //下面是多叉树的宽度遍历的过程
        for (int i = 0; i < digits.length(); i++) {
            String[] array = convert(digits.charAt(i));
            //当queue.getFirst().length() == i+1是说明是本次循环添加的值，那么不应该加进来
            while (queue.size()>0&&queue.getFirst().length()<=i) {
                String firstValue = queue.removeFirst();
                //拼接后添加到最后面j
                for (int j = 0; j < array.length; j++) {
                    String temp = firstValue+array[j];
                    queue.add(temp);
                }
            }
        }
        return queue;
    }
    String[] convert(Character character) {
        String[] list = new String[4];
        if (character == '2') { list = new String[]{"a","b","c"}; }
        if (character == '3') { list = new String[]{"d","e","f"}; }
        if (character == '4') { list = new String[]{"g","h","i"}; }
        if (character == '5') { list = new String[]{"j","k","l"}; }
        if (character == '6') { list = new String[]{"m","n","o"}; }
        if (character == '7') { list = new String[]{"p","q","r","s"}; }
        if (character == '8') { list = new String[]{"t","u","v"}; }
        if (character == '9') { list = new String[]{"w","x","y","z"}; }
        return list;
    }
```

下面是另外一种解法，主要是多叉树的深度遍历的解法：

```java
public List<String> letterCombinations(String digits) {
    List<String> arrayList = new ArrayList<>();
    if (digits==null||digits.length()==0) {
        return arrayList;
    }
    tranverse(digits,"",0,arrayList);
    return arrayList;
}
//递归进行深度遍历
public void tranverse(String digits,String currentString,int start,List<String> arrayList) {
 		//下一层已经没有节点时，直接添加字符串
    if (start>=digits.length()) {
        arrayList.add(currentString);
        return;
    }
  	//convert方法就不重复列出来了，在上面的解法中有相关的实现
    String[] array = convert(digits.charAt(start));
  //对每一个子节点进行继续递归遍历
    for (int i = 0; i < array.length; i++) {
        String temp = currentString + array[i];
        tranverse(digits,temp,start+1,arrayList);
    }
}
```

### 第15题-三数之和

给你一个包含 *n* 个整数的数组 `nums`，判断 `nums` 中是否存在三个元素 *a，b，c ，*使得 *a + b + c =* 0 ？请你找出所有满足条件且不重复的三元组。

**注意：**答案中不可以包含重复的三元组。

**示例：**

```java
给定数组 nums = [-1, 0, 1, 2, -1, -4]，

满足要求的三元组集合为：
[
  [-1, 0, 1],
  [-1, -1, 2]
]
```

##### 解题思路
两数之和的是通过两个指针从首尾两端向中间移动来解决的，三数之和相当于是基于两数之和来解答的，相当于对数组进行遍历，对于每个数调用两数之和的函数获得结果，大致思路如下：
```java
for(int i=0;i<nums.length;i++) {
		twoSum(nums,i+1,target - nums[i]);//target即为三数之和i+1到nums.length-1是计算三数之和的取值范围
}
```
主要难点其实是在于如何避免提交重复的三元组到数组中去，本题是通过只对不同的元素调用twoSum方法，并且调用范围为i+1到nums.length-1。
```java
		List<List<Integer>> totalList = new ArrayList<>();
    public List<List<Integer>> threeSum(int[] nums) {
      	//先对数组进行排序
        Arrays.sort(nums);
        for (int i = 0; i < nums.length; i++) {
            //说明上次循环已经添加了
            if(i>=1 && nums[i] == nums[i-1]) {
                continue;
            }
            int target = 0 - nums[i];
            //这里不是从0开始遍历，而是只是对后面的元素遍历，防止三元组重复
            twoSum(nums, i+1, target);
        }
        return totalList;
    }

    public void twoSum(int[] nums,int start, int target) {
        int i = start,j=nums.length-1;
        while (i<j) {
            int sum = nums[i]+nums[j];
            //有可能是存在一个数组是 1，1，1，1，2，2，3，3，3 要求sum为4，
            // 这样会存在多组一样的，在添加时需要判断是否重复,
            // 所以非第一次循环，并且跟上次循环的数一样，那么就跳过
            if (i>start && nums[i] == nums[i-1]){
                i++;
                continue;
            } else if (sum == target) {
                List<Integer> list = new ArrayList<>();
                list.add(0-target);
                list.add(nums[i]);
                list.add(nums[j]);
                totalList.add(list);
                i++;
                j--;
            } else if (sum > target) {
                j--;
            } else if(sum<target){
                i++;
            }
        }
    }
```



### 第141题-环形链表

给定一个链表，判断链表中是否有环。

![img](../static/circularlinkedlist.png)

##### 解题思路

就是使用快慢指针来解决这个问题，如果相遇，代表有环，不相遇代表没有环。

```java
public boolean hasCycle(ListNode head) {
        ListNode slow = head;
        ListNode quick = head;
        while(quick!=null) {
            if(quick.next == null){return false;}
            quick = quick.next.next;
            slow = slow.next;
            if(quick==slow) {return true;}
        }
        return false;
    }
```

### 第104题-二叉树的最大深度
给定一个二叉树，找出其最大深度。
二叉树的深度为根节点到最远叶子节点的最长路径上的节点数。
```java
public int maxDepth(TreeNode root) {
        if(root==null) {return 0;}
        int leftDepth = maxDepth(root.left);
        int rightDepth = maxDepth(root.right);
        return leftDepth > rightDepth ? leftDepth+ 1: rightDepth+1;
    }
```

## 第22题-括号生成
数字 n 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 有效的 括号组合。

示例：

输入：n = 3
输出：[
       "((()))", 000111
       "(()())", 001011
       "(())()", 001101
       "()(())", 010011
       "()()()"  010101
     ]

##### 解题思路

其实这一题也是一个回朔的解法，就是可以把每个"("和")"看成是一个二叉树的节点，从根节点到叶子节点的路径组成了每种括号组合。例如n=3时，二叉树如下：

二叉树第1层                                                         ""

第2层								(   							  							            )

​	                  （                                ）							  		（ 					   ）

（    							  ）   （					  ）	  	（			  		）  （                   ）

每次就使用回朔的方法进行深度遍历，每当发现当前的路径不符合要求时，进行剪枝，回退到上一层，遍历其他路径。(本题中剪枝的要求是左括号数量>n，或者右括号数量>n，或者右括号数量>左括号。)

```java
		public List<String> generateParenthesis(int n) {
        List<String> totalList = new ArrayList<String>();
        if(n<=0) {
            return totalList;
        }
        LinkedList<Character> stack = new LinkedList<Character>();
        //使用回朔算法进行遍历
        generateParenthesis(n,0,0,stack,totalList);
        return totalList;
    }
		
    public void generateParenthesis(int n,int left,int right,LinkedList<Character> stack,List<String> totalList) {
      //不满足要求，进行剪枝，回退去遍历其他节点
       if(left>n || right>n || right>left) {return;}  
       if(left==n&&right==n) {//正好匹配上了，将栈中所有值转换为
            StringBuffer str = new StringBuffer();
            for(int i = 0;i < stack.size(); i++) {
                str.append(stack.get(i));
            }
            totalList.add(str.toString());
        }
        //往左边遍历
        stack.add('(');
        generateParenthesis(n,left+1,right,stack,totalList);
        //回朔
        stack.removeLast();
        //往右边遍历
        stack.add(')');
        generateParenthesis(n,left,right+1,stack,totalList);
        //回朔
        stack.removeLast();
    }
```

PS:回朔算法的框架

```
List result = new ArrayList<>();
void backtrack(路径, 选择列表stack):
    if 超出范围 return
    
    if 满足结束条件:
        result.add(路径)
        return

    for 选择 in 选择列表:
        做选择 stack.add(当前元素);
        backtrack(路径, 选择列表)
        撤销选择 stack.remove(当前元素);
```
### 第42题-接雨水

给定 n 个非负整数表示每个宽度为 1 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。

示例 1：

![img](../static/rainwatertrap.png)

输入：height = [0,1,0,2,1,0,1,3,2,1,2,1]
输出：6
解释：上面是由数组 [0,1,0,2,1,0,1,3,2,1,2,1] 表示的高度图，在这种情况下，可以接 6 个单位的雨水（蓝色部分表示雨水）。

##### 解题思路

就是对于每个柱子来说，它这个位置顶上可以容纳的水，其实是等于柱子左边柱子的最大值leftMax，右边柱子的最大值rightMax，两者中的较小值min，水容量=min-height[i]。所以先统计出每个柱子左边的最大值和右边的最大值，然后就可以计算水容量了。

```java
public int trap(int[] height) {
        if (height==null||height.length==0){return 0;}
        int[][] dp = new int[height.length][2];
        int leftMax = height[0];
  			//统计每个柱子左边的最大值
        for (int i = 1; i < height.length; i++) {
            leftMax = leftMax > height[i] ? leftMax : height[i];
            dp[i][0] = leftMax;
        }
        int rightMax = height[height.length-1];
        //统计每个柱子右边的最大值
  			for (int i = height.length-2; i >=0 ; i--) {
            rightMax = rightMax > height[i] ? rightMax : height[i];
            dp[i][1] = rightMax;
        }
        int area = 0;
  			//统计每个柱子可以存的水
        for (int i = 1; i <= height.length-2; i++) {
            int min = dp[i][0] < dp[i][1] ? dp[i][0] : dp[i][1];
            area += min-height[i];
        }
        return area;
    }
```




### 第102题-二叉树的层序遍历

给你一个二叉树，请你返回其按 **层序遍历** 得到的节点值。 （即逐层地，从左到右访问所有节点）。

示例：

```
二叉树：[3,9,20,null,null,15,7],

    3
   / \
  9  20
    /  \
   15   7
返回其层次遍历结果：

[
  [3],
  [9,20],
  [15,7]
]
```

##### 解题思路

其实就是二叉树的宽度优先遍历，只不过返回结果，是每一层的节点存在同一个数组中

```java
public List<List<Integer>> levelOrder(TreeNode root) {
        List totalList = new ArrayList<>();
        if(root==null){
            return totalList;
        }
        LinkedList<TreeNode> currentQueue = new LinkedList<TreeNode>();
        LinkedList<TreeNode> nextQueue = new LinkedList<TreeNode>();
        currentQueue.add(root);
        while(currentQueue.size()>0) {
            List<Integer> list = new ArrayList<Integer>();
            while(currentQueue.size()>0) {
                TreeNode node = currentQueue.removeFirst();
                if(node != null) {
                    list.add(node.val);
                    if(node.left!=null) {
                        nextQueue.add(node.left);
                    }
                    if(node.right!=null) {
                        nextQueue.add(node.right);
                    }
                }
            }
            totalList.add(list);
            currentQueue = nextQueue;
            nextQueue = new LinkedList<TreeNode>();
        }
        return totalList;
    }
```



### 第198题-打家劫舍
你是一个专业的小偷，计划偷窃沿街的房屋。每间房内都藏有一定的现金，影响你偷窃的唯一制约因素就是相邻的房屋装有相互连通的防盗系统，如果两间相邻的房屋在同一晚上被小偷闯入，系统会自动报警。

给定一个代表每个房屋存放金额的非负整数数组，计算你 不触动警报装置的情况下 ，一夜之内能够偷窃到的最高金额。

示例 1：

输入：[1,2,3,1]
输出：4
解释：偷窃 1 号房屋 (金额 = 1) ，然后偷窃 3 号房屋 (金额 = 3)。
     偷窃到的最高金额 = 1 + 3 = 4 。

##### 解题思路：

其实跟斐波拉契数列很像，这道题中其实如果要计算nums数组的前n个元素的最高金额的话，使用f(n)来代替。

f(0)=nums[0];

f(1)=nums[1]>nums[0]?nums[1]:nums[0];//也就是num[0]和nums[1]之间的最大值。

状态转移方程如下：

f(n) = f(n-1) > f(n-2)+nums[n] ? f(n-1) :f(n-2)+nums[n]

```java
Integer[] saveTable;
    public int rob(int[] nums) {
        if(nums==null|| nums.length == 0) {
            return 0;
        }
        if(nums.length==1) {
            return nums[0];
        }
        saveTable = new Integer[nums.length];
        int value1 = maxRob(nums,nums.length-1);
        int value2 = maxRob(nums,nums.length-2);
        return value1 > value2 ? value1 : value2;
    }

    public int maxRob(int[] nums,int n) {
        if(saveTable[n]!=null)
        {
            return saveTable[n];
        }
        int max = 0;
        if(n==0) {
            max = nums[0];
        } else if(n==1) {
            max = nums[1]>nums[0]?nums[1]:nums[0];
        } else if(n-2>=0) {
            int value1 = maxRob(nums,n-1);
            int value2 = maxRob(nums,n-2)+nums[n];
            max = value1 > value2 ? value1 : value2;
        } 
        saveTable[n] = max;
        return max;
    }
```

### 第46题-全排列

给定一个 **没有重复** 数字的序列，返回其所有可能的全排列。
**示例:**

```
输入: [1,2,3]
输出:
[
  [1,2,3],
  [1,3,2],
  [2,1,3],
  [2,3,1],
  [3,1,2],
  [3,2,1]
]
```

##### 递归解法

假设你需要计算[1,2,3]的全排列结果，其实等于

1为首元素，[2,3]的全排列结果，

2为首元素，[1,3]的全排列结果，

3首元素，[1,2]的全排列结果

```java
		public List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> totalList = new ArrayList<List<Integer>>();
        if (nums == null|| nums.length==0){
            return totalList;
        }
        tranverse(nums,0,totalList);
        return totalList;
    }
		//遍历
    public void tranverse(int[] nums,int start,List<List<Integer>> totalList) {
        if (start>=nums.length) {//说明递归到最后了，将所有元素添加到list
            List<Integer> list = new ArrayList<Integer>();
            for (int i = 0; i < nums.length; i++) {
                list.add(nums[i]);
            }
            totalList.add(list);
            return;
        }
        //遍历将后面的元素取出，与首元素交换，然后对子串递归，因为对于[1,2,3]而言，所有排序结果是等于1为首元素，后面子数组的结果+2为首元素，后面子数组的结果+3为首元素，后面子数组的结果
        for (int i = start; i < nums.length; i++) {
            swap(nums,start,i);
            tranverse(nums,start+1,totalList);
            swap(nums,i,start);
        }
    }
    void swap(int[] nums,int a,int b) {
        int temp = nums[a];
        nums[a] = nums[b];
        nums[b] = temp;
    }
```

##### 回朔解法

回溯算法实际上一个类似枚举的搜索尝试过程，主要是在搜索尝试过程中寻找问题的解，当发现已不满足求解条件时，就“回溯”返回，尝试别的路径。回溯法是一种选优[搜索](https://baike.baidu.com/item/搜索/2791632)法，按选优条件向前搜索，以达到目标。但当探索到某一步时，发现原先选择并不优或达不到目标，就退回一步重新选择，这种走不通就退回再走的技术为回溯法，而满足回溯条件的某个状态的点称为“回溯点”。这道题中其实就是用回朔方法对多叉树进行一次遍历，每次到叶子节点后，发现没有元素了就退回。

![6111](../static/6111.jpeg)

```java
List<List<Integer>> totalList = new ArrayList<List<Integer>>();
LinkedList stack = new LinkedList<Integer>();
HashSet<Integer> set = new HashSet<Integer>();
public List<List<Integer>> permute1(int[] nums) {
    if (nums==null||nums.length==0) {
        return totalList;
    }
    permute1(nums);
    return totalList;
}
public void permute1(int[] nums) {
    if (stack.size()==nums.length) {//排列完毕了
        LinkedList<Integer> newList = new LinkedList<>(stack);
        totalList.add(newList);
        return;
    }
    for (int i = 0; i < nums.length; i++) {
        if (set.contains(nums[i])) {//包含说明此元素在前面出现过了
            continue;
        }
        //在剩余元素中找到一个stack中未出现的，然后添加到stack
        stack.add(nums[i]);
        set.add(nums[i]);
        permute1(nums,stack,totalList);
        //回撤
        stack.removeLast();
        set.remove(nums[i]);
    }
}
```

### 第55题-跳跃游戏

给定一个非负整数数组，你最初位于数组的第一个位置。

数组中的每个元素代表你在该位置可以跳跃的最大长度。

判断你是否能够到达最后一个位置。

示例 1:

输入: [2,3,1,1,4]
输出: true
解释: 我们可以先跳 1 步，从位置 0 到达 位置 1, 然后再从位置 1 跳 3 步到达最后一个位置。

##### 解题思路

这个其实也是通过回朔法去判断每个下标能否到达最后一步

```java
    //这个数组主要用于记录那些不能到达最后一个元素的数组下标，减少冗余计算
    Boolean[] recordArray;
    public boolean canJump(int[] nums) {
        if(nums==null||nums.length==0) {return false;}
        recordArray = new Boolean[nums.length];
        return canJump(nums,0);
    }

    public boolean canJump(int[] nums,int start) {
      //当前start已经处于最后一步了，或者是当前数组下标加上数字超过最后一个元素了
        if(start >= nums.length-1 || start+nums[start] >= nums.length-1) 				{
            return true;
        }
      	//已经对于改已经有记录结果，不用重复计算
        if(recordArray[start]!=null) {
            return recordArray[start];
        }
        int end = start+nums[start]; 
      	//计算[start+1,end]之间的元素，是否有可以到达最后一步的
        for(int i = start+1;i<=end;i++) {
            if(canJump(nums,i)) {
                return true;
            }
        }
        recordArray[start] = false;
        return false;
    }
```

##### 贪心解法

```java
public boolean canJump(int[] nums) {
        if(nums==null||nums.length==0) {return false;}
  			//maxDepth代表可以抵达的最远距离
  			int maxDepth = nums[0];
        for(int i=1;i<=maxDepth && i< nums.length;i++){
            //当前元素的可抵达距离超过maxDepth，进行更新
          	if(nums[i]+i>maxDepth){
                maxDepth = nums[i]+i;
            }
        }
        return maxDepth>= nums.length-1;
    }
```

### 第62题-不同路径

一个机器人位于一个 m x n 网格的左上角 （起始点在下图中标记为 “Start” ）。

机器人每次只能向下或者向右移动一步。机器人试图达到网格的右下角（在下图中标记为 “Finish” ）。

问总共有多少条不同的路径？  右6  下2 C 2 8 



![img](../static/robot_maze.png)

输入：m = 3, n = 2
输出：3
解释：
从左上角开始，总共有 3 条路径可以到达右下角。
1. 向右 -> 向右 -> 向下
2. 向右 -> 向下 -> 向右
3. 向下 -> 向右 -> 向右

##### 解题思路

其实就是C(m-1,m-1+n-1)，其实总共要走m-1+n-1步，其中有m-1步是向右的，n-1步是向下的，所以其实是一个组合问题，相当于在m-1+n-1步中找出m-1步的组合数。

```java
public int uniquePaths(int m, int n) {
        int rightStep = m-1;
        int downStep = n-1;
        int min = rightStep<downStep ? rightStep:downStep;
        int sum = rightStep+downStep;
        long allTimes=1;
        long innerTimes=1;
        while(min>0) {
            allTimes = allTimes*sum;
            innerTimes = innerTimes *min;
            min--;
            sum--;
        }
        return (int) (allTimes/innerTimes);
    }
```
### 第56题-合并区间

给出一个区间的集合，请合并所有重叠的区间。

示例 1:
```
输入: intervals = [[1,3],[2,6],[8,10],[15,18]]
输出: [[1,6],[8,10],[15,18]]
解释: 区间 [1,3] 和 [2,6] 重叠, 将它们合并为 [1,6]。
```

##### 解题思路

就是先根据左边界进行排序，排序完之后进行进行区间合并，合并的判断规则就是当前区间的左边界是否在上一个区间内。

```java
public int[][] merge(int[][] intervals) {
        if (intervals==null||intervals.length<=1) {
            return intervals;
        }
  		//先进行排序
        quickSort(intervals,0,intervals.length-1);
        int lastIndex = 0;
        for (int i = 1; i < intervals.length; i++) {
            if (intervals[i][0] >= intervals[lastIndex][0]
                    && intervals[i][0] <= intervals[lastIndex][1]) {
                //如果当前区间的左边界处于上一个区间中间，说明可以被合并
                intervals[lastIndex][1] = intervals[lastIndex][1] > intervals[i][1]
                        ? intervals[lastIndex][1] : intervals[i][1];
            } else {//不能被合并
                lastIndex++;
                intervals[lastIndex][0] = intervals[i][0];
                intervals[lastIndex][1] = intervals[i][1];
            }
        }
        //对数组进拷贝
        int[][] result = new int[lastIndex+1][2];
        for (int i = 0; i <= lastIndex ; i++) {
            result[i][0] = intervals[i][0];
            result[i][1] = intervals[i][1];
        }
        return result;
    }
		//快排，按照每个区间的左边界进行排序
    void quickSort(int[][] array,int start,int end) {
        if (start>=end){return;}
        int i = start;
        int j = end;
        int base = array[start][0];
        while (i<j) {
            while (array[j][0] > base && j>i) {j--;}
            while (array[i][0]<=base&&j>i) {i++;}
            swap(array,i,j);
        }
        swap(array,start, i); ;
        quickSort(array,start,i-1);
        quickSort(array,i+1,end);
    }
		//交换元素
    void swap(int[][] array, int i,int j) {
        int temp_0 = array[j][0];
        int temp_1 = array[j][1];
        array[j][0] = array[i][0];
        array[j][1] = array[i][1];
        array[i][0] = temp_0;
        array[i][1] = temp_1;
    }
```
### 第169题-多数元素
给定一个大小为 n 的数组，找到其中的多数元素。多数元素是指在数组中出现次数大于n/2 的元素。

你可以假设数组是非空的，并且给定的数组总是存在多数元素。

示例 1:
```
输入: [3,2,3]
输出: 3
```
##### 解题思路
这个多数元素一定是数组的中位数，所以可以转换为寻找数组的中位数，也就是寻找第nums.length/2小的元素，也就转换为Top K问题了，所以使用快排解决。
```java
public int majorityElement(int[] nums) {
        if (nums==null||nums.length==0) { return 0; }
        return quickSort(nums,nums.length/2,0,nums.length-1);
    }
    int quickSort(int[] nums,int k,int start,int end) {
        if (start>=end) {
            return nums[start];
        }
        int base = nums[start];
        int i = start;
        int j = end;
        while (i<j) {
            while (nums[j]>base&&i<j) {j--;}
            while (nums[i]<=base&&i<j) {i++;}
            int temp = nums[i];
            nums[i] = nums[j];
            nums[j] = temp;
        }
        nums[start] = nums[i];
        nums[i] = base;
        if (i == k) {
            return nums[i];
        } else if (i>k) {
           return quickSort(nums,k,start,i-1);
        } else {
           return quickSort(nums,k,i+1,end);
        }
    }
```
### 第101题-对称二叉树

给定一个二叉树，检查它是否是镜像对称的。 

例如，二叉树 [1,2,2,3,4,4,3] 是对称的。

        1
       / \
      2   2
     / \ / \
    3  4 4  3
##### 解题思路

```java
public boolean isSymmetric(TreeNode root) {
    if (root == null) {
        return true;
    }
    return isSymmetric(root.left, root.right);
}
public boolean isSymmetric(TreeNode left, TreeNode right) {
    if (left == null && right == null) {//都为null
        return true;
    }
    if ((left == null && right != null) || (left != null && right == null)) {//其中一个为null
        return false;
    }
    if (left.val != right.val) {//都不为null但是值不相等
        return false;
    }
  //判断子节点是否相等
    return isSymmetric(left.left, right.right) && isSymmetric(left.right, right.left);
}
```
### 第33题-搜索旋转排序数组
升序排列的整数数组 nums 在预先未知的某个点上进行了旋转（例如， [0,1,2,4,5,6,7] 经旋转后可能变为 [4,5,6,7,0,1,2] ）。

请你在数组中搜索 target ，如果数组中存在这个目标值，则返回它的索引，否则返回 -1 。
示例 1：

输入：nums = [4,5,6,7,0,1,2], target = 0
输出：4
##### 解题思路
还是按照二分搜索来进行搜索，只是多一步判断，如果nums[mid]<nums[right]，说明右半部分是递增有序的，我们直接把这一半当成正常的二分搜索来进行，判断target是否在这一半里面。否则就对左半段进行判断。
```java
public int search(int[] nums, int target) {
        int left =0;
        int right = nums.length - 1;
        while (left<=right) {
            int mid = (left+right)/2;
            if(nums[mid] == target) {//说明是正好是目标值
                return mid;
            } else if(nums[mid] < nums[right]) {//说明旋转点不在右边，这边是有序的
                if(target>nums[mid] && target<=nums[right]) {
                    left = mid+1;
                } else {
                    right = mid-1;
                }
            } else {//说明旋转点在右边，这是我们根据左边来判断
                if(target>=nums[left] && target < nums[mid]) {
                    right = mid-1;
                } else {
                    left = mid+1;
                }
            }
        }
        return -1;
    }
```
### 第136题-只出现一次的数字

给定一个非空整数数组，除了某个元素只出现一次以外，其余每个元素均出现两次。找出那个只出现了一次的元素。

说明：

你的算法应该具有线性时间复杂度。 你可以不使用额外空间来实现吗？

示例 1:

输入: [2,2,1]
输出: 1

##### 解题思路

```java
public int singleNumber(int[] nums) {
        int value =0;
        for(int i = 0;i<nums.length;i++) {
            value=value^nums[i];
        }
        return value;
}
```

### 第23题-合并K个升序链表
给你一个链表数组，每个链表都已经按升序排列。
请你将所有链表合并到一个升序链表中，返回合并后的链表。

示例 1：

输入：lists = [[1,4,5],[1,3,4],[2,6]]
输出：[1,1,2,3,4,4,5,6]
解释：链表数组如下：
[
  1->4->5,
  1->3->4,
  2->6
]
将它们合并到一个有序链表中得到。
1->1->2->3->4->4->5->6

##### 解题思路
就是对K个链表的头结点建立一个小顶堆，每次取堆顶元素出来，放到新链表的末尾。然后对堆进行调整，每次调整复杂度为logK，总时间复杂度是N*LogK.
```java
public ListNode mergeKLists(ListNode[] lists) {
        if(lists==null||lists.length==0) {return null;}
        ListNode preHead = new ListNode(-1);
        ListNode currentNode = preHead;
        ArrayList<ListNode> arrayList = new ArrayList<>();
        //过滤lists中为null的元素，然后将不为null的元素添加到arrayList中去
        // （测试用例中有很多为null的用例)
        for (int i = 0; i < lists.length; i++) {
            if (lists[i] != null) {
                arrayList.add(lists[i]);
            }
        }
        if (arrayList.size()==0) {
            return null;
        }
        //建立小顶堆
        for (int i = arrayList.size()/2-1; i >= 0; i--) {
            adjustHeap(arrayList,i,arrayList.size());
        }
        while (arrayList.size()>0) {
            if (arrayList.get(0) == null) {//这个链表到最后一个节点了，从小顶堆中移除
                swap(arrayList,0,arrayList.size()-1);
                arrayList.remove(arrayList.size()-1);
                continue;
            }
            adjustHeap(arrayList,0,arrayList.size());

            ListNode node = arrayList.get(0);
            currentNode.next =  node;
            currentNode =  currentNode.next;
            arrayList.set(0,node.next);
        }
        return preHead.next;
    }

    void adjustHeap(ArrayList<ListNode> lists, int i, int length) {
        while (2*i+1<length) {
            int left = 2*i+1;
            int right = 2*i+2;
            int min = lists.get(i).val < lists.get(left).val ? i:left;
            if (right<length) {
                min = lists.get(min).val < lists.get(right).val ? min:right;
            }
            if (min == i) {
                break;
            } else {
                swap(lists,min,i);
                i = min;
            }
        }
    }
    void swap(ArrayList<ListNode>  lists,int a, int b) {
        ListNode temp = lists.get(a);
        lists.set(a,lists.get(b));
        lists.set(b,temp);
    }
```

### 第94题-二叉树的中序遍历

给定一个二叉树的根节点 `root` ，返回它的 **中序** 遍历。

**示例 1：**

![img](../static/inorder_1.jpg)

```
输入：root = [1,null,2,3]
输出：[1,3,2]
```

##### 解题思路

递归解法

```java
List<Integer> list = new ArrayList<Integer>();
public List<Integer> inorderTraversal(TreeNode root) {
    if(root==null){return list;}
    inorderTraversal(root.left);
    list.add(root.val);
    inorderTraversal(root.right);
    return list;
}
```

栈解法

就是遍历到每个节点时，先把这个节点的右节点right添加到栈，再把这个节点添加到栈，再把这个节点的左节点left添加到栈。再把这个节点的left和right指针设置为null，代表这个节点的左右子节点已经被访问到了，下次遍历到这个节点时可以直接添加到列表中。

```java
public List<Integer> inorderTraversal1(TreeNode root) {
    List<Integer> list = new ArrayList<Integer>();
    if (root==null){return list;}
    Stack<TreeNode> stack = new Stack<>();
    stack.add(root);
    while (stack.size()>0) {
        TreeNode node = stack.pop();
        if (node.left == null && node.right==null) {
            list.add(node.val);
            continue;
        }
        if (node.right!=null) {
            stack.push(node.right);
            //这里将right置为null主要防止父节点多次遍历，也可以使用一个HashSet来记录那些已经添加子节点的父节点。
            node.right =null;
        }
        stack.push(node);
        if (node.left!=null) {
            stack.push(node.left);
          //这里将left置为null主要防止父节点多次遍历，也可以使用一个HashSet来记录那些已经添加子节点的父节点。
            node.left=null;
        }
    }
    return list;
}
```

### 第64题-最小路径和

给定一个包含非负整数的 m x n 网格 grid ，请找出一条从左上角到右下角的路径，使得路径上的数字总和为最小。

说明：每次只能向下或者向右移动一步。

示例 1：

![img](../static/minpath.jpg)

```
输入：grid = [[1,3,1],[1,5,1],[4,2,1]]
输出：7
解释：因为路径 1→3→1→1→1 的总和最小。
```

##### 解题思路

其实跟斐波拉契数列的题很相似

```java
int[][] cache;
public int minPathSum(int[][] grid) {
    if (grid==null||grid[0]==null) {return 0;}
    cache = new int[grid.length][grid[0].length];
    return minPathSum(grid,0,0);
}

public int minPathSum(int[][] grid, int row,int col) {
    //缓存中已有这一步到右下角的数据，直接从缓存中取值
    if (cache[row][col]!=0) {
        return cache[row][col];
    }
    int max_row = grid.length-1;
    int max_col = grid[0].length-1;
    int path = 0;
    if (row == max_row && col == max_col) {//已经处于右下角
        path =  grid[row][col];
    } else if (row == max_row) {//当前处于最下面的一行，只能往右边走
        path = grid[row][col] + minPathSum(grid,row,col+1);
    } else if (col == max_col) {//当前处于最右边的一行，只能往下边走
        path = grid[row][col] + minPathSum(grid,row+1,col);
    } else {
        //往下走
        int down  = grid[row][col] + minPathSum(grid, row, col + 1);
        int right = grid[row][col] + minPathSum(grid, row + 1, col);
        path = down < right ? down : right;
    }
    cache[row][col] = path;
    return path;
}
```
### 第215题-数组中的第K个最大元素

在未排序的数组中找到第 k 个最大的元素。请注意，你需要找的是数组排序后的第 k 个最大的元素，而不是第 k 个不同的元素。

示例 1:

输入: [3,2,1,5,6,4] 和 k = 2
输出: 5

##### 解题思路

就是Top K问题，这里可以使用堆排进行排序，需要注意的是，大顶堆建堆结束后，每次将堆顶元素移动到数组末尾，然后继续对剩下的0到i-1范围内的元素进行调整,所以是adjustHeap(nums,0,i);
```java
public int findKthLargest(int[] nums, int k) {
        for (int i = nums.length/2-1; i >=0 ; i--) {
            //对整个数组看成一个对，进行大顶堆调整
            adjustHeap(nums,i,nums.length);
        }
        for (int i = nums.length-1; i > 0; i--) {
            swap(nums,0,i);
            //对0到i-1范围内的元素看成一个堆，进行大顶堆调整
            if (i==nums.length-k) {
                break;
            }
            adjustHeap(nums,0,i);
        }
        return nums[nums.length - k];
    }
    void adjustHeap(int[] nums, int i,int currentLength) {
        //左子节点存在
        while (2*i+1<currentLength) {
            int left = 2*i+1;
            int right = 2*i+2;
            if (right<currentLength && nums[right] > nums[left]) {//右节点也存在,并且大于左节点
                if (nums[right] > nums[i]) {//右节点大
                    swap(nums,i,right);
                    i = right;
                } else {//根节点最大
                    break;
                }
            } else {//右节点不存在，或者右节点比左节点小
                if (nums[left] > nums[i]) {
                    swap(nums,i,left);
                    i = left;
                } else {
                    break;
                }
            }
        }
    }
```

### 第234题-回文链表
请判断一个链表是否为回文链表。

示例 1:

输入: 1->2
输出: false
示例 2:

输入: 1->2->2->1
输出: true
##### 解题思路
就是用一个快慢指针，找到链表的中位数节点，然后对后半部分链表进行反转，然后分别从原链表头部和尾部开始遍历判断。
```java
 public boolean isPalindrome(ListNode head) {
        ListNode slow = head;
        ListNode quick = head;
        while (quick != null) {
            quick = quick.next;
            if (quick == null) {
                break;
            }
            quick = quick.next;
            slow = slow.next;
        }
        //此时的slow要么是中位数节点，
        // 中位数有两个时，就是靠前的那个中位数节点
        //总结点数为奇数  1->2->3->2->1  slow为3
        //总结点数为偶数数 1->2->2->1     slow为第一个2
        //对后面的节点进行翻转
        ListNode preNode = slow;
        ListNode currentNode = slow.next;
        while (currentNode!=null) {
            ListNode tempNode = currentNode.next;
            currentNode.next = preNode;
            preNode = currentNode;
            currentNode = tempNode;
        }
        slow.next = null;
        ListNode otherHead = preNode;
        while (head!=null && otherHead!=null) {
            if ((head==null&&otherHead!=null)
                    || (head!=null&&otherHead==null)) {
                return false;
            }
            if (head.val!=otherHead.val) {
                return false;
            }
            head=head.next;
            otherHead = otherHead.next;
        }
        return true;
    }
```

### 第200题-岛屿数量
给你一个由 '1'（陆地）和 '0'（水）组成的的二维网格，请你计算网格中岛屿的数量。

岛屿总是被水包围，并且每座岛屿只能由水平方向和/或竖直方向上相邻的陆地连接形成。
此外，你可以假设该网格的四条边均被水包围。
示例 1：

输入：grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
输出：1

#### 解题思路
因为每个岛屿中所有的1之间是可以相互抵达的，只要你找到岛屿中的一个1，然后向四周进行遍历，判断是1继续向四周扩散，可以抵达这个岛屿所有的节点，所以通过infect函数对每个未被遍历的岛屿点进行扩散，判断这个点是1就将它设置为2，代表已遍历，然后继续扩散。这样就可以统计出岛屿数量。
```java
public int numIslands(char[][] grid) {
        if (grid==null||grid[0]==null){return 0;}
        int num =0;
        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[i].length; j++) {
                char c = grid[i][j];
                if (c == '1') {//如果是未感染的陆地，那么使用infect函数向四周扩散
                    infect(grid,i,j);
                    num++;
                }
            }
        }
        return num;
    }
    //向四周未被遍历的陆地进行扩散
    void infect(char[][] grid,int i,int j) {
        if (i < 0 || i >= grid.length || j < 0 || j >= grid[i].length) {
            return;
        }
        if (grid[i][j] == '1') {
            grid[i][j]= '2';
            infect(grid,i-1,j);
            infect(grid,i+1,j);
            infect(grid,i,j-1);
            infect(grid,i,j+1);
        }
    }
```
### 第48题-旋转图像

给定一个 n × n 的二维矩阵表示一个图像。
将图像顺时针旋转 90 度。
说明：
你必须在原地旋转图像，这意味着你需要直接修改输入的二维矩阵。请不要使用另一个矩阵来旋转图像。
示例 1:
给定 matrix = 
[
  [1,2,3],
  [4,5,6],
  [7,8,9]
],

原地旋转输入矩阵，使其变为:
[
  [7,4,1],
  [8,5,2],
  [9,6,3]
]
##### 解题思路
这个题就是你可以每次只旋转外圈元素，然后旋转完毕后把内圈元素看成一个新的矩阵，继续对矩阵进行旋转。在对外圈元素进行旋转时，我们只需要先将最上方一条边的元素与右方元素交换，再与下方元交换，在于左方元素交换，这样最好就旋转成功了。

例如：
	[1,2,3],
  [4,5,6],
  [7,8,9]
  对于这个矩阵来说，我们只旋转外圈元素，也就是1，2，3，6，9，8，7，4，1。然后把里面的元素，也就是5看成一个新的矩阵，继续对外圈元素进行旋转，直到最后矩阵只剩下一个元素。

如何对外圈元素进行旋转呢？
我们对最上面的一条边进行遍历，也就是[1,3)进行遍历，例如一开始的元素是1，将左上角的元素1与右上角的元素3交换，此时左上角元素为3，再将左上角的3与右下角的9交换，此时左上角为9，再将左上角的9与左下角的7进行交换，这样对于四个角的元素来说，就完成了旋转，然后继续遍历，对2，6，8，4四个元素按照相同的方法进行旋转。
```java
public void rotate(int[][] matrix) {
        if (matrix == null || matrix[0] == null) {
            return;
        }
        rotate(matrix,0,matrix.length-1,0,matrix[0].length-1);
    }
    //对矩阵进行旋转
    public void rotate(int[][] matrix,int rowStart,int rowEnd,int colStart,int colEnd) {
        if (rowStart>=rowEnd || colStart>= colEnd) {
            return;
        }
        //进行交换
        for (int j = colStart; j < colEnd; j++) {
            //当前j从原点走了几步
            int race = j-colStart;
            //左上角与右上角元素交换
            swap(matrix,rowStart,j,rowStart+race,colEnd);
            //左上角与右下角元素交换
            swap(matrix,rowStart,j,rowEnd,colEnd-race);
            //左上角与左下角元素交换
            swap(matrix,rowStart,j,rowEnd-race,colStart);
        }
        //然后对内圈元素进行旋转
        rotate(matrix,rowStart+1,rowEnd-1,colStart+1,colEnd-1);
    }

    void swap(int[][] matrix,int i,int j,int other_i,int other_j) {
        int temp = matrix[i][j];
        matrix[i][j] = matrix[other_i][other_j];
        matrix[other_i][other_j] = temp;
    }
```

### 第98题-验证二叉搜索树

给定一个二叉树，判断其是否是一个有效的二叉搜索树。

假设一个二叉搜索树具有如下特征：

节点的左子树只包含小于当前节点的数。
节点的右子树只包含大于当前节点的数。
所有左子树和右子树自身必须也是二叉搜索树。
示例 1:

输入:
    2
   / \
  1   3
输出: true

##### 解题思路

二叉搜索树的中序遍历结果就是一个排序好的序列，所以我们可以对二叉树进行中序遍历

，判断当前的遍历节点值是否大于上一个节点值。

```java
Integer lastValue = null;
public boolean isValidBST(TreeNode root) {
      if (root==null) {return true;}
      Boolean leftResult = isValidBST(root.left);
      if (leftResult==false){return false;}
      if (lastValue==null){
        		lastValue=root.val;
      } else if (lastValue>=root.val) {
        		return false;
      } else if (lastValue<root.val) {
       		  lastValue = root.val;
      }
      return isValidBST(root.right);
}
```

### 第78题-子集

给定一组不含重复元素的整数数组 nums，返回该数组所有可能的子集（幂集）。

说明：解集不能包含重复的子集。

示例:

输入: nums = [1,2,3]
输出:
[
  [3],
  [1],
  [2],
  [1,2,3],
  [1,3],
  [2,3],
  [1,2],
  []
]

##### 解题思路
由于原数组是没有重复元素的，所以其实一共有2的nums.length次组合，也就是这么多组子集。

可以用回朔法，也可以用循环法。

```java
public List<List<Integer>> subsets(int[] nums) {
        List<List<Integer>> totalList = new ArrayList<List<Integer>>();
        int size = (int)Math.pow(2,nums.length);
        for (int i = 0; i < size; i++) {
            List<Integer> list = new ArrayList<>();
            for (int j = 0; j < nums.length; j++) {
               //j是元素在数组中的位置，通过判断i的第j个二进制位是否为0，来决定是否添加这个元素
                int result = i & (1<<j);
                if (result!=0) {
                    list.add(nums[j]);
                }
            }
            totalList.add(list);
        }
        return totalList;
    }
```

### 第75题-颜色分类

给定一个包含红色、白色和蓝色，一共 n 个元素的数组，原地对它们进行排序，使得相同颜色的元素相邻，并按照红色、白色、蓝色顺序排列。

此题中，我们使用整数 0、 1 和 2 分别表示红色、白色和蓝色。


进阶：

你可以不使用代码库中的排序函数来解决这道题吗？
你能想出一个仅使用常数空间的一趟扫描算法吗？


示例 1：

输入：nums = [2,0,2,1,1,0]
输出：[0,0,1,1,2,2]

##### 解题思路
三路快排思路，就是遇到0添加到数组前面，遇到2就添加到数组后面的元素交换，遇到1就继续遍历，这样可以保证0在最前面，2在最后面，1在中间。
```java
 public void sortColors(int[] nums) {
        if (nums==null||nums.length==0) {
            return;
        }
        int red = 0;
        int blue = nums.length-1;
        for (int i = 0; i <= blue; i++) {
            if (nums[i] == 0) {
                //if (i==0) {
                  //  red++;
                  // continue;
               // } else {
                    int temp = nums[red];
                    nums[red] = 0;
                    nums[i] = temp;
                    red++;
                //}
            } else if(nums[i]==1) {
                continue;
            } else if(nums[i]==2) {
                int temp = nums[blue];
                nums[blue] = 2;
                nums[i] = temp;
                blue--;
                i--;
            }
        }
    }
```

### 第39题-组合总和

给定一个无重复元素的数组 candidates 和一个目标数 target ，找出 candidates 中所有可以使数字和为 target 的组合。

candidates 中的数字可以无限制重复被选取。

说明：

所有数字（包括 target）都是正整数。
解集不能包含重复的组合。 
示例 1：

输入：candidates = [2,3,6,7], target = 7,
所求解集为：
[
  [7],
  [2,2,3]
]

##### 解题思路

就是使用回朔法进行解决，组合问题，排列问题，一般都是使用回朔法进行解决。对于每个元素，只会有0到target/candidates[i]种结果。回朔法解题框架

```java
List resultList;
void tranverse(int[] array, Stack stack) {
	if (满足某种条件) {
			resultList.add(stack);
  }
 	for(int i=0;i<array.length;i++) {//遍历各种结果
 			//做选择
 			stack.add(array[i]);
 			tranverse(array,stack);
 			//撤销选择
 			stack.removeLast();
 	}
}
```

代码

```java
List<List<Integer>> totalList = new ArrayList<List<Integer>>();
    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        combinationSum(candidates,target,candidates.length-1,new LinkedList<Integer>());
        return totalList;
    }

    public void combinationSum(int[] candidates,
                                              int target, int end,
                                              LinkedList<Integer> stack) {
        if (target==0) {
            List<Integer> copyList = new ArrayList<>(stack);
            totalList.add(copyList);
            return;
        } else if (target<0||end<0) {
            return;
        }

        for (int i = 0; i*candidates[end] <= target ; i++) {
            for (int j = 0; j < i; j++) {//添加j个当前元素,也就是假设子集和中有j个candidates[end]元素
                stack.add(candidates[end]);
            }
            combinationSum(candidates,target-i*candidates[end],end-1,stack);
            for (int j = 0; j < i; j++) {//移除j个当前元素
                stack.removeLast();
            }
        }
    }
```

### 第226题-翻转二叉树

翻转一棵二叉树。

示例：

    输入：
     			4
        /   \
      2     7
     / \   / \
    1   3 6   9
    输出：
        4
      /   \
      7     2
     / \   / \
    9   6 3   1

##### 解题思路

```java
public TreeNode invertTree(TreeNode root) {
    if (root==null) {return null;}
    TreeNode temp = root.left;
    root.left = root.right;
    root.right = temp;
    invertTree(root.left);
    invertTree(root.right);
    return root;
}
```

## 第31题-下一个排列

实现获取 下一个排列 的函数，算法需要将给定数字序列重新排列成字典序中下一个更大的排列。

如果不存在下一个更大的排列，则将数字重新排列成最小的排列（即升序排列）。

必须 原地 修改，只允许使用额外常数空间。 

示例 1：

输入：nums = [1,2,3]
输出：[1,3,2]

##### 解题思路
本题其实就是提升数字的字典序,并且要提升的幅度最小。就是从后面往前找到第一个nums[i-1]<nums[i]的数，这是需要调整使得数字字典序更大的地方，然后从i到length-1之间找到一个大于nums[i-1]但是又最小的数，然后与nums[i-1]替换。

```java
public void nextPermutation(int[] nums) {
        int flag=0;
        for (int i = nums.length-1; i >0 ; i--) {

            if (nums[i-1]<nums[i])  {//从往前找到第一个前一个数<后一个数的情况
                
                int min = i;
              //再后面找到一个比nums[i-1]大，但是又最小的值
                for (int j = i; j <nums.length ; j++) {
                    if (nums[j] < nums[min] && nums[j] > nums[i-1]) {
                        min = j;
                    }
                }
              //进行交换
                int temp = nums[i-1];
                nums[i-1] = nums[min];
                nums[min] = temp;
                flag=1;
              //然后再对后面的元素进行排序
                Arrays.sort(nums,i,nums.length);
                break;
            }
        }
  			//如果现在的数组就是字典序最大的，那么就排序，得到字典序最小的进行返回。
        if (flag==0) {
            Arrays.sort(nums);
        }
    }
```


### 第322题-零钱兑换

题目详情：(https://leetcode-cn.com/problems/coin-change/)
给定不同面额的硬币 coins 和一个总金额 amount。编写一个函数来计算可以凑成总金额所需的最少的硬币个数。如果没有任何一种硬币组合能组成总金额，返回 -1。

你可以认为每种硬币的数量是无限的。

示例 1：

输入：coins = [1, 2, 5], amount = 11
输出：3 
解释：11 = 5 + 5 + 1

##### 递归解法

```java
    Integer[] array;
    public int coinChange(int[] coins, int amount) {
        if (array == null) {//初始化缓存数组
            array = new Integer[amount+1];
        }
        if (amount == 0) {
            return 0;
        } else if (amount < 0) {
            return -1;
        } else if(array[amount]!=null) {//缓存数组中有值，直接返回
            return array[amount];
        }
        Integer minNum = null;
        for (int i = 0; i < coins.length; i++) {//遍历计算最大值
            int remainNum = coinChange(coins, amount - coins[i]);
            if (remainNum == -1) {
                continue;
            } else if(minNum==null || remainNum + 1 < minNum ) {
                minNum = remainNum + 1;
            }
        }
        array[amount] = minNum;
        return minNum == null ? -1 : minNum;
    }
```

##### 动态规划解法

1.找到Base Case

金额为0时，需要返回的硬币数是0。f(0)=0

2.确定状态

也就是原问题和子问题中会变化的变量。这个问题中的变量就是金额会变化，硬币面额是确定的，数量是无限。

3.确定选择

也就是导致「状态」产生变化的行为，这个题里面的选择就是在凑金额的时候，硬币面额的选择，

4.确定对应的`dp`函数/数组

这里会有一个递归的 `dp` 函数，一般来说函数的参数就是状态转移中会变化的量，也就是上面说到的「状态」；函数的返回值就是题目要求我们计算的量。就这个题来说，状态只有一个，即「目标金额」，题目要求我们计算凑出目标金额所需的最少硬币数量，每个目标金额的最少硬币数量=min(目标金额-硬币面额后的金额所需最少硬币数)，所以我们可以这样定义 `dp` 函数：

![coin](../static/coin.png)

搞清楚上面这几个关键点，解法的伪码就可以写出来了：

```python
# 伪码框架
def coinChange(coins: List[int], amount: int):
    # 定义：要凑出金额 n，至少要 dp(n) 个硬币
    def dp(n):
        # 做选择，选择需要硬币最少的那个结果
        for coin in coins:
            res = min(res, 1 + dp(n - coin))
        return res
    # 题目要求的最终结果是 dp(amount)
    return dp(amount)
```

```java
//动态规划解法
public int coinChange1(int[] coins, int amount) {
    int[] array = new int[amount+1];
    for (int i = 1; i <= amount; i++) {
        Integer minNum=null;
        for (int j = 0; j < coins.length; j++) {
            int remain = i - coins[j];
            if (remain < 0 || array[remain]==-1) {
                continue;
            }
            //此时肯定有值
            if (minNum==null || array[remain]+1 < minNum ) {
                minNum = array[remain]+1;
            }
        }
        array[i] = minNum == null ? -1 : minNum;
    }
    return array[amount];
}
```

### 第300题-最长递增子序列

给你一个整数数组 nums ，找到其中最长严格递增子序列的长度。

子序列是由数组派生而来的序列，删除（或不删除）数组中的元素而不改变其余元素的顺序。例如，[3,6,2,7] 是数组 [0,3,1,6,2,2,7] 的子序列。


示例 1：

输入：nums = [10,9,2,5,3,7,101,18]
输出：4
解释：最长递增子序列是 [2,3,7,101]，因此长度为 4 。

##### 解题思路
使用一个数组dp[i]来记录包含元素i时，最大递增子序列长度，所以状态转移方程为
dp[i] = max(1,dp[k]+1); k<i,并且nums[k]<nums[i]

```java
  public int lengthOfLIS(int[] nums) {
        if (nums==null||nums.length==0) {
            return 0;
        }
        //包含元素nums[i]时的最大长度
        int[] dp = new int[nums.length];
        dp[0] = 1;
        int totalMax = 1;
        for (int i = 1; i < nums.length; i++) {
            int max = 1;
          	//向前遍历，找到一个比nums[i]小的数，与它组成一个递增序列。
            for (int j = i-1; j >=0; j--) {
                if (nums[j] < nums[i] && dp[j] + 1 > max) {
                    max = dp[j] + 1;
                }
            }
            dp[i] = max;
            totalMax = max > totalMax ? max : totalMax;
        }
        return totalMax;
    }

```

时间复杂度为O(NlogN)的解法，就是使用一个数组sizeArray记录元素对应的最长子序列长度，sizeArray[i]代表sizeArray[i]这个元素组成的最长子序列的长度为i+1

```java
public int anotherLengthOfLIS(int[] nums) {
    if (nums== null||nums.length==0) {
        return 0;
    }
    //sizeArray[i]代表sizeArray[i]这个元素组成的最长子序列的长度为i+1
    int[] sizeArray = new int[nums.length];
    sizeArray[0] = nums[0];//第一个元素的最长子序列长度为1
    int maxSize = 0;
    for (int i = 1; i < nums.length; i++) {
        if (nums[i]>sizeArray[maxSize]) {//如果当前元素比最长子序列的尾部元素大
            maxSize++;
            sizeArray[maxSize] = nums[i];
        } else if (nums[i]==sizeArray[maxSize]) {//等于尾部元素，那么不用更新
            continue;
        } else {//小于尾部元素进行更新，在sizeArray中进行二分查找
            int left = 0;
            int right = maxSize;
            while (left < right) {
                int mid = (left+right)/2;
                if (sizeArray[mid] < nums[i]) {
                    left = mid+1;
                } else {
                    right = mid;
                }
            }
            //最后left的位置肯定就是需要进行插入的位置
            //left左边的元素都比nums[i]小
            sizeArray[left]=nums[i];
        }
    }
    return maxSize+1;
}
```