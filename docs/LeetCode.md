## LeetCode 热门100题题解

#### [1.两数之和](#两数之和)
#### [206. 反转链表](#206.反转链表)
#### [3.无重复字符的最长子串](#3.无重复字符的最长子串)
#### [2. 两数相加](#2.两数相加)
#### [20.有效的括号](#20.有效的括号)
#### [5.最长回文子串](#5.最长回文子串)
#### [121.买卖股票的最佳时机](#121.买卖股票的最佳时机)
#### [70.爬楼梯](#70.爬楼梯)
#### [53.最大子序和](#53.最大子序和)
#### [19.删除链表的倒数第N个节点](#19.删除链表的倒数第N个节点)
#### [21.合并两个有序链表](#21.合并两个有序链表)
#### [283.移动零](#283.移动零)


### 两数之和
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

### 206.反转链表
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
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public ListNode reverseList(ListNode head) {
        if(head==null||head.next==null){return head;}
        ListNode preNode = head;
        ListNode currentNode = head.next;
        head.next = null;
        while(currentNode!=null) {
            ListNode saveNode = currentNode.next;
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
### 3.无重复字符的最长子串
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
### 2.两数相加
题目详情：https://leetcode-cn.com/problems/add-two-numbers/

#### 题目详情：

给出两个 非空 的链表用来表示两个非负的整数。其中，它们各自的位数是按照 逆序 的方式存储的，并且它们的每个节点只能存储 一位 数字。

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
            } else {//有进位就建新节点
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

### 20.有效的括号
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

就是遍历字符串，字符属于左括号就添加到栈中，属于右括号就判断是否属于与栈顶元素对应，是的话可以将栈顶出栈，不是的话就说明不匹配，返回 false。遍历完成需要判断栈的长度是否为0，不为0代表还存在没有匹配上的左括号，不满足要求。 

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


### 5.最长回文子串
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
            if(array[i] == array[i-1]) {//i跟i-1对称
                String value = findMax(s, i-1,i);
                maxString = maxString.length() < value.length() ? value : maxString;
            } 
          	//这里必须是if，而不是else if，因为存在当前字符i与上一个字符i-1回文，同时月存在下一个字符i-1与上一个字符i+1回文，例如ccc
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
### 121.买卖股票的最佳时机
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
### 70.爬楼梯
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
### 53.最大子序和
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


### 19.删除链表的倒数第N个节点
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


### 21.合并两个有序链表
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

### 283.移动零

题目详情：https://leetcode-cn.com/problems/move-zeroes/
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



#### 322. 零钱兑换
题目详情：(https://leetcode-cn.com/problems/coin-change/)
给定不同面额的硬币 coins 和一个总金额 amount。编写一个函数来计算可以凑成总金额所需的最少的硬币个数。如果没有任何一种硬币组合能组成总金额，返回 -1。

你可以认为每种硬币的数量是无限的。

示例 1：

输入：coins = [1, 2, 5], amount = 11
输出：3 
解释：11 = 5 + 5 + 1

#####递归解法

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

## 34. 在排序数组中查找元素的第一个和最后一个位置

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



## 17. 电话号码的字母组合

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







