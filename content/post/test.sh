#!/bin/bash

## 1.数据类型
# shell脚本默认字符串类型

## 2.变量定义
a=123
b='123$a' # 单引号:原样输出
c="123$a" # 双引号:占位符会被替换
readonly d=123 # 只读变量
echo "$b"
echo "$c"

## 3.变量调用
# 1)getter
echo "$a" # $等价于${},表示取值
echo "${a}"
echo "`ls -l`" # ``等价于$(),表示执行命令
echo "$(ls -l)"
# 2)setter
a=456

## 4.特殊变量
# 1)脚本或函数的参数:$1,$2,...${10},${11}...${n}
# 2)脚本文件名:$0
# 3)脚本或函数的参数个数:$#
# 4)脚本或函数的所有参数:$*
# 5)脚本或函数的所有参数:$@
# 6)上一个命令的退出状态或函数返回值:$?
# 7)当前shell进程ID:$$

## 5.字符串处理
# 1)字符串长度:${#string_name}
str="hello world"
echo "${#str}"
# 2)字符串拼接:${string_name1}${string_name2}
str1=hello
str2=world
str3=${str1}${str2}
echo "$str3"
# 3)字符串截取
str="hello world"
# (1)${string: index: length}或${string: 0-index: length}
echo "${str: 2: 5}" # 从左至右,从左0计数,索引从2开始,长度为5
echo "${str: 2}" # 从左至右,从左0计数,索引从2开始,长度为到末尾
echo "${str: 0-7: 5}" # 从左至右,从右1计数,索引从7开始,长度为5
echo "${str: 0-7}" # 从左至右,从右1计数,索引从7开始,长度为到末尾
# (2)${string#*substring}或${string##*substring}
echo "${str#*el}" # 截取最前一个*el右边的所有字符,*是通配符
echo "${str##*l}" # 截取最后一个*l右边的所有字符,*是通配符
# (3)${string%substring*}或${string%%substring*}
echo "${str%l*}" # 截取最后一个l*左边的所有字符,*是通配符
echo "${str%%l*}" # 截取最前一个l*左边的所有字符,*是通配符

## 6.数组
arr1=(29 100 13 8 91 44)
arr2=(20 56 "hello world")
echo "${arr1[1]}" # 输出索引为1的元素
echo "${arr2[*]}" # 输出所有元素
arr1[10]=66
echo "${arr1[@]}" # 输出所有元素
echo "${arr2[2]}" # 输出索引为2的元素
echo "${#arr1[@]}" # 输出元素个数
echo "${#arr2[*]}" # 输出元素个数
arr3=(${arr1[*]} ${arr2[*]}) # 数组拼接
echo "${arr3[*]}"
unset arr3[1] # 删除数组元素
echo "${arr3[1]}"

## 7.数据运算
# 算术运算(整型)
# 1)使用declare -i
declare -i m n ret
m=10
n=30
ret=$m+$n
echo "$ret"

# 2)使用(()),推荐用法
echo "$((1+1))"
i=5
((i=i+5))
j=$((i=i+5, 4+5))
echo "$i"
echo "$j"

# 3)使用let
i=2
let i+=8
echo "$i"

# 4)使用expr命令
i=3
echo "`expr 4 + $i`"
j=`expr 5 + 6`
echo "$j"

# 逻辑运算(整型)
echo "$((3 < 8))" # 输出1表示真
echo "$((3 > 8))" # 输出0表示假
echo "$?" # 输出0,表示上一个命令执行成功,退出状态为0;上一个命令执行失败,退出状态为非0,一般为1
echo "$((3 == 3))" # 输出1表示真
echo "$((3 == 3 && 3 < 8 && 3 < 6))" # 输出1表示真
echo "$?" # 输出0,表示上一个命令执行成功,退出状态为0;上一个命令执行失败,退出状态为非0,一般为1

## 8.控制语句
# 1)if语句
read -p "请输入a的值:" a # 从键盘读取数据赋值给a,按Ctrl+D组合键结束读取
read -p "请输入b的值:" b
if (($a == $b)); then
    echo "a和b相等!"
else
    echo "a和b不相等!"
fi

age=17
if (($age > 0 && $age <= 17)); then
    echo "你还未成年哦!"
else
    echo "你已经是成人了!"
fi

# test等价于[  ],此时[  ]左右两边各含有一个空格
# test比(())更强大.(())只能比较整型,test可以比较整型、字符串、文件,test命令中使用的变量建议加双引号
# 字符串比较是从左至右逐个比较字符对应的ASCII码
if test "$age" -gt 0 && test "$age" -le 17; then
    echo "你还未成年哦!"
else
    echo "你已经是成人了!"
fi

filename="/dev/null"
if test -w "$filename"; then
    echo "文件存在且有可写权限!"
else
    echo "文件不存在!"
fi

str1=hello
str2=world
if test -n "$str1" && test -n "$str2"; then
    echo "str1和str2都不为空!"
else
    echo "str1和str2至少有一个为空!"
fi

if test -n "$str1" -a -n "$str2"; then
    echo "str1和str2都不为空!"
else
    echo "str1和str2至少有一个为空!"
fi

if [ -n "$str1" -a -n "$str2" ]; then
    echo "str1和str2都不为空!"
else
    echo "str1和str2至少有一个为空!"
fi

if [ "$str1" \> "$str2" ]; then
    echo "str1大于str2!"
else
    echo "str1小于等于str2!"
fi

# [[  ]]是[  ]命令的升级版,使用变量不需要加双引号,不需要对>、<进行转义
if [[ -n $str1 ]] && [[ -n $str2 ]]; then
    echo "str1和str2都不为空!"
else
    echo "str1和str2至少有一个为空!"
fi

if [[ -n $str1 && -n $str2 ]]; then
    echo "str1和str2都不为空!"
else
    echo "str1和str2至少有一个为空!"
fi

if [[ $str1 > $str2 ]]; then
    echo "str1大于str2!"
else
    echo "str1小于等于str2!"
fi

# 2)case语句
str=b
case $str in
    a)
        echo "我是a"
        ;;
    b)
        echo "我是b"
        ;;
    c)
        echo "我是c"
        ;;
    *)
        echo "error"
esac

# 3)while语句
i=1
sum=0
while ((i <= 100))
do
    ((sum += i))
    ((i++))
done
echo "sum = $sum"

i=1
sum=0
while [ "$i" -le 100 ]
do
    ((sum += i))
    ((i++))
done
echo "sum = $sum"

sum=0
for ((i=1; i <= 100; i++))
do
    ((sum += i))
done
echo "sum = $sum"
