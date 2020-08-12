## LeetCode 热门100题题解

#### [1.两数之和](#两数之和)

#### 题目描述

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

### [206. 反转链表](https://leetcode-cn.com/problems/reverse-linked-list/)

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

### [3.无重复字符的最长子串](https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/)

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

### [2. 两数相加](https://leetcode-cn.com/problems/add-two-numbers/)

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

