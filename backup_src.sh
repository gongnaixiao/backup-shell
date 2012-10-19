#!/bin/sh
todayDate=`date +'%Y%m%d'`
echo "当前日期为$todayDate"
# 删除20天前的备份数据
cd
cd backup
# 注意本函数只支持计算最长不超过28天前的日期
N=10
# 定义今天的日期
CURRENT_DATE=`date +%Y%m%d`
echo 当前日期$CURRENT_DATE
# 定义获得年的标示
CURRENT_YEAR=`date +%Y`
# 定义去年的标示
LAST_YEAR=`expr $CURRENT_YEAR - 1`
# 定义获得月的标示
CURRENT_MONTH=`date +%m`
echo 当前月$CURRENT_MONTH
# 定义上个月的标示
if [ $CURRENT_MONTH -gt 1 ]
# 如果本月不是1月份
then
 LAST_MONTH=`expr $CURRENT_MONTH - 1`
 echo 上月$LAST_MONTH
# 如果本月是1月份
else
 LAST_MONTH=12
fi
# 定义获得天的标示
CURRENT_DAY=`date +%d`
# 判断是否闰年:0表示非闰年，1表示闰年
# LEAP_YEAR_CHECK=$(($CURRENT_YEAR%4==0&&$CURRENT_YEAR%100!=0||$CURRENT_YEAR%400==0))
if [ `expr $CURRENT_YEAR % 4` -eq 0 ]
then
 if [ `expr $CURRENT_YEAR % 400` -eq 0 ]
  then
   LEAP_YEAR_CHECK=1
  elif [ `expr $CURRENT_YEAR % 100` -ne 0 ]
   then
    LEAP_YEAR_CHECK=1
  else
   LEAP_YEAR_CHECK=0
 fi
else
 LEAP_YEAR_CHECK=0
fi
# 定义上个月的天数
# 说明：如果是闰年，则2月份是29天，否则为28天
LAST_MONTH_DAYS=0
if [ $CURRENT_MONTH -gt 1 ]
# 如果大于1月份
then
 case $LAST_MONTH in
  1|3|5|7|8|10|12)
   LAST_MONTH_DAYS=31
   ;;
  4|6|9|11)
   LAST_MONTH_DAYS=30
   ;;
  2)
   if [ $LEAP_YEAR_CHECK -eq 0 ]
    then
     LAST_MONTH_DAYS=28
    else
     LAST_MONTH_DAYS=29
   fi
   ;;
  *)
   echo "Error: The month must be in the range from 1 to 12."
   ;;
 esac
# 如果是1月份，则上个月为第12月，天数一定为31
else
 LAST_MONTH_DAYS=31
fi
# 定义最终的年
BEFORE_YEAR=0
# 定义最终的月
BEFORE_MONTH=0
# 定义最终的天
BEFORE_DAY=0
# 定义距离今天N天前的日期
BN_DAYS_AGO=0
# 变量定义完成 -----------------------------------------------

# 程序开始
# ------------------------------------------------------------
# ------------------------------------------------------------
# 如果今天天数大于N
if [ $CURRENT_DAY -gt $N ]
then
 # 年份BEFORE_YEAR = 今年CURRENT_YEAR
 # 月份BEFORE_MONTH = 本月CURRENT_MONTH
 # 天数BEFORE_DAY = 今天天数CURRENT_DAY - N
 echo 月份是当月的情况
 BEFORE_YEAR=$CURRENT_YEAR
 BEFORE_MONTH=`expr $CURRENT_MONTH - 0`
 BEFORE_DAY=`expr $CURRENT_DAY - $N`

# 如果今天天数小于等于N
else
 # 如果当前月份不是1月份
 if [ $CURRENT_MONTH -ne 1 ]
 then
   # 年份BEFORE_YEAR = 今年CURRENT_YEAR
   # 月份BEFORE_MONTH = 前一个月LAST_MONTH
   # 天数BEFORE_DAY = 前一个月的天数LAST_MONTH_DAYS - (N - 今天天数CURRENT_DAY)
   echo 月份不是当月且月份不是1月情况
   echo 上月天数$LAST_MONTH_DAYS
   echo 当前日期$CURRENT_DAY

   BEFORE_YEAR=$CURRENT_YEAR
   BEFORE_MONTH=$LAST_MONTH
   BEFORE_DAY=`expr $LAST_MONTH_DAYS - $N + $CURRENT_DAY`
  # 如果当前月份是1月份
 else
   # 年份BEFORE_YEAR = 前一年LAST_YEAR
   # 月份BEFORE_MONTH = 前一个月LAST_MONTH
   # 天数BEFORE_DAY = 前一个月的天数LAST_MONTH_DAYS - (N - 今天天数CURRENT_DAY)

   BEFORE_YEAR=$LAST_YEAR
   BEFORE_MONTH=$LAST_MONTH
   BEFORE_DAY=`expr $LAST_MONTH_DAYS - $N + $CURRENT_DAY`
 fi
fi
if [ $BEFORE_MONTH -lt 10 ]
then
 BEFORE_MONTH='0'$BEFORE_MONTH;
 echo $BEFORE_MONTH
fi

if [ $BEFORE_DAY -lt 10 ]
then
 echo $BEFORE_DAY
 BEFORE_DAY='0'$BEFORE_DAY;
 echo $BEFORE_DAY
fi

BN_DAYS_AGO=$BEFORE_YEAR$BEFORE_MONTH$BEFORE_DAY
echo $BN_DAYS_AGO
rm -f backup_$BN_DAYS_AGO.tar.Z
rm -f /tmp/tarfile.log
cd
TMPFILE=/tmp/tmp.a
cd
echo .profile >tmpfile.lst

SUM=`find ./src -name "*.c"|grep -c c`
echo "-----------------------查找到的 .c 文件总共$SUM-------------------------"
FILES=`find ./src -name "*.c"`
NUM=0
for FILE in $FILES
do
   printf "完成[%3d]%%,                                                            \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%3d]%%,正在处理%25s...      \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
echo "查找 .c 文件  完成$NUM条 "

SUM=`find ./src -name "*.ec"|grep -c ec`
echo "----------------------查找到的 .ec 文件总共$SUM--------------------------"
FILES=`find ./src -name "*.ec"`
NUM=0
for FILE in $FILES
do
   printf "完成[%3d]%%,                                                             \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%3d]%%,正在处理%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "查找 .ec 文件  完成[%6d]条    \n \n \n" `expr $NUM`

SUM=`find ./src -name "*.pc"|grep -c pc`
echo "----------------------查找到的 .pc 文件总共$SUM--------------------------"
FILES=`find ./src -name "*.pc"`
NUM=0
for FILE in $FILES
do
   printf "完成[%3d]%%,                                                             \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%3d]%%,正在处理%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "查找 .pc 文件  完成[%6d]条    \n \n \n" `expr $NUM`


SUM=`find ./src -name Makefile|grep -c Makefile`
echo "----------------------查找到的 Makefile 文件总共$SUM------------------"
FILES=`find ./src -name Makefile`
NUM=0
for FILE in $FILES
do
   printf "完成[%3d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%3d]%%,正在处理%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst

   NUM=`expr $NUM + 1`
done
printf "查找 Makefile 文件  完成[%6d]条    \n \n \n" `expr $NUM`

SUM=`find ./src -name makefile|grep -c makefile`
echo "----------------------查找到的 makefile 文件总共$SUM------------------"
FILES=`find ./src -name makefile`
NUM=0
for FILE in $FILES
do
   printf "完成[%3d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%3d]%%,正在处理%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst

   NUM=`expr $NUM + 1`
done
printf " \n \n \n" 
printf "查找 makefile 文件  完成[%6d]条    \n \n \n" `expr $NUM`
printf " \n \n \n" 

SUM=`find ./src -name "mk.*"|grep -c mk.`
echo "----------------------查找到的 mk 文件总共$SUM------------------"
FILES=`find ./src -name "mk.*"`
NUM=0
for FILE in $FILES
do
   printf "完成[%3d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%3d]%%,正在处理%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst

   NUM=`expr $NUM + 1`
done
printf " \n \n \n" 
printf "查找 mk 文件  完成[%6d]条    \n \n \n" `expr $NUM`
printf " \n \n \n" 

SUM=`find . -name "*.h"|grep -c .h|grep -v usr|grep -v backup`
echo "查找到的 .h 文件总共$SUM"
FILES=`find . -name "*.h"|grep -v usr|grep -v backup`
NUM=0
for FILE in $FILES
do
   printf "完成[%5d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%5d]%%,正在处理%25s...    \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "查找 .h 文件  完成[%6d]条         \n \n \n" `expr $NUM`


SUM=`find . -name "*.sh"|grep -c .sh`
echo "查找到的 .sh 文件总共$SUM"
FILES=`find . -name "*.sh"|grep -v usr`
NUM=0
for FILE in $FILES
do
   printf "完成[%5d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%5d]%%,正在处理%25s...    \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "查找 .sh 文件  完成[%6d]条         \n \n \n" `expr $NUM`



SUM=`find . -name "*.sql"|grep -c .sql|grep -v usr|grep -v backup`
echo "查找到的 .sql 文件总共$SUM"
FILES=`find . -name "*.sql"|grep -v usr|grep -v backup`
NUM=0
for FILE in $FILES
do
   printf "完成[%3d]%%,                       \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%3d]%%,正在处理%25s...        \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "查找 .sql 文件  完成[%3d]%%          \n" `expr $NUM '*' 100 '/' $SUM`


SUM=`find . -name "ubbnew"|grep -v grep`
echo "查找到的 .sql 文件总共$SUM"
FILES=`find . -name "ubbnew"|grep -v grep`
NUM=0
for FILE in $FILES
do
   printf "完成[%3d]%%,                       \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%3d]%%,正在处理%25s...        \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "查找 ubbnew 文件  完成[%3d]%%          \n" `expr $NUM '*' 100 '/' $SUM`


SUM=`find . -name "*.xml"|grep -c .xml`
FILES=`find . -name "*.xml"|grep -v usr`
NUM=0
for FILE in $FILES
do
   printf "完成[%5d]%%,                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "完成[%5d]%%,正在处理%25s...         \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "完成[%5d]%%,                                                                           \r" `expr $NUM '*' 100 '/' $SUM`
echo '开始tar出该选项'

tar -cvf backup_$todayDate.tar -L tmpfile.lst >>/tmp/tarfile.log
rm -f tmpfile.lst
#备份dataover目录下的额外程序，1,dat文件，2，lib目录文件
#tar -rvf backup_$todayDate.tar ./src/dataover/lib/*
#tar -rvf backup_$todayDate.tar ./src/dataover/sgdata/*
#tar -rvf backup_$todayDate.tar ./src/dataover/patch/*
#tar -rvf backup_$todayDate.tar ./src/dataover/data/*
#tar -rvf backup_$todayDate.tar ./src/dataover/ready-data/*
#tar -rvf backup_$todayDate.tar ./src/dataover/sql/*.cfg
#tar -rvf backup_$todayDate.tar ./src/dataover/sql/*.cfg
#tar -rvf backup_$todayDate.tar ./src/dataover/readme.txt
#tar -rvf backup_$todayDate.tar ./src/dataover/etc
#备份bin目录下的额外程序
tar -rvf backup_$todayDate.tar ./bin/applist
tar -rvf backup_$todayDate.tar ./bin/appstop
tar -rvf backup_$todayDate.tar ./bin/appstart
#tar -rvf backup_$todayDate.tar ./bin/dbkil.sh
tar -rvf backup_$todayDate.tar ./bin/xgrep
tar -rvf backup_$todayDate.tar ./bin/kilshm
#tar -rvf backup_$todayDate.tar ./bin/fedit
#tar -rvf backup_$todayDate.tar ./bin/fview
#tar -rvf backup_$todayDate.tar ./bin/hsql
tar -rvf backup_$todayDate.tar ./bin/sql
#tar -rvf backup_$todayDate.tar ./bin/load_owner_table
#tar -rvf backup_$todayDate.tar ./bin/lp_rpt.sh
#tar -rvf backup_$todayDate.tar ./bin/printfile
#tar -rvf backup_$todayDate.tar ./bin/prt.sh
#tar -rvf backup_$todayDate.tar ./bin/remember
tar -rvf backup_$todayDate.tar ./bin/ttx
#tar -rvf backup_$todayDate.tar ./bin/txml
#tar -rvf backup_$todayDate.tar ./bin/unloadfx

mv backup_$todayDate.tar ./backup
cd backup
echo "backup finish"
compress backup_$todayDate.tar
cp backup_$todayDate.tar.Z $HOME/usr/xyy/backup/
echo "compress finish"
#rm backup_$todayDate.tar
