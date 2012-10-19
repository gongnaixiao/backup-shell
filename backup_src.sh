#!/bin/sh
todayDate=`date +'%Y%m%d'`
echo "��ǰ����Ϊ$todayDate"
# ɾ��20��ǰ�ı�������
cd
cd backup
# ע�Ȿ����ֻ֧�ּ����������28��ǰ������
N=10
# ������������
CURRENT_DATE=`date +%Y%m%d`
echo ��ǰ����$CURRENT_DATE
# ��������ı�ʾ
CURRENT_YEAR=`date +%Y`
# ����ȥ��ı�ʾ
LAST_YEAR=`expr $CURRENT_YEAR - 1`
# �������µı�ʾ
CURRENT_MONTH=`date +%m`
echo ��ǰ��$CURRENT_MONTH
# �����ϸ��µı�ʾ
if [ $CURRENT_MONTH -gt 1 ]
# ������²���1�·�
then
 LAST_MONTH=`expr $CURRENT_MONTH - 1`
 echo ����$LAST_MONTH
# ���������1�·�
else
 LAST_MONTH=12
fi
# ��������ı�ʾ
CURRENT_DAY=`date +%d`
# �ж��Ƿ�����:0��ʾ�����꣬1��ʾ����
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
# �����ϸ��µ�����
# ˵������������꣬��2�·���29�죬����Ϊ28��
LAST_MONTH_DAYS=0
if [ $CURRENT_MONTH -gt 1 ]
# �������1�·�
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
# �����1�·ݣ����ϸ���Ϊ��12�£�����һ��Ϊ31
else
 LAST_MONTH_DAYS=31
fi
# �������յ���
BEFORE_YEAR=0
# �������յ���
BEFORE_MONTH=0
# �������յ���
BEFORE_DAY=0
# ����������N��ǰ������
BN_DAYS_AGO=0
# ����������� -----------------------------------------------

# ����ʼ
# ------------------------------------------------------------
# ------------------------------------------------------------
# ���������������N
if [ $CURRENT_DAY -gt $N ]
then
 # ���BEFORE_YEAR = ����CURRENT_YEAR
 # �·�BEFORE_MONTH = ����CURRENT_MONTH
 # ����BEFORE_DAY = ��������CURRENT_DAY - N
 echo �·��ǵ��µ����
 BEFORE_YEAR=$CURRENT_YEAR
 BEFORE_MONTH=`expr $CURRENT_MONTH - 0`
 BEFORE_DAY=`expr $CURRENT_DAY - $N`

# �����������С�ڵ���N
else
 # �����ǰ�·ݲ���1�·�
 if [ $CURRENT_MONTH -ne 1 ]
 then
   # ���BEFORE_YEAR = ����CURRENT_YEAR
   # �·�BEFORE_MONTH = ǰһ����LAST_MONTH
   # ����BEFORE_DAY = ǰһ���µ�����LAST_MONTH_DAYS - (N - ��������CURRENT_DAY)
   echo �·ݲ��ǵ������·ݲ���1�����
   echo ��������$LAST_MONTH_DAYS
   echo ��ǰ����$CURRENT_DAY

   BEFORE_YEAR=$CURRENT_YEAR
   BEFORE_MONTH=$LAST_MONTH
   BEFORE_DAY=`expr $LAST_MONTH_DAYS - $N + $CURRENT_DAY`
  # �����ǰ�·���1�·�
 else
   # ���BEFORE_YEAR = ǰһ��LAST_YEAR
   # �·�BEFORE_MONTH = ǰһ����LAST_MONTH
   # ����BEFORE_DAY = ǰһ���µ�����LAST_MONTH_DAYS - (N - ��������CURRENT_DAY)

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
echo "-----------------------���ҵ��� .c �ļ��ܹ�$SUM-------------------------"
FILES=`find ./src -name "*.c"`
NUM=0
for FILE in $FILES
do
   printf "���[%3d]%%,                                                            \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%3d]%%,���ڴ���%25s...      \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
echo "���� .c �ļ�  ���$NUM�� "

SUM=`find ./src -name "*.ec"|grep -c ec`
echo "----------------------���ҵ��� .ec �ļ��ܹ�$SUM--------------------------"
FILES=`find ./src -name "*.ec"`
NUM=0
for FILE in $FILES
do
   printf "���[%3d]%%,                                                             \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%3d]%%,���ڴ���%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "���� .ec �ļ�  ���[%6d]��    \n \n \n" `expr $NUM`

SUM=`find ./src -name "*.pc"|grep -c pc`
echo "----------------------���ҵ��� .pc �ļ��ܹ�$SUM--------------------------"
FILES=`find ./src -name "*.pc"`
NUM=0
for FILE in $FILES
do
   printf "���[%3d]%%,                                                             \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%3d]%%,���ڴ���%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "���� .pc �ļ�  ���[%6d]��    \n \n \n" `expr $NUM`


SUM=`find ./src -name Makefile|grep -c Makefile`
echo "----------------------���ҵ��� Makefile �ļ��ܹ�$SUM------------------"
FILES=`find ./src -name Makefile`
NUM=0
for FILE in $FILES
do
   printf "���[%3d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%3d]%%,���ڴ���%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst

   NUM=`expr $NUM + 1`
done
printf "���� Makefile �ļ�  ���[%6d]��    \n \n \n" `expr $NUM`

SUM=`find ./src -name makefile|grep -c makefile`
echo "----------------------���ҵ��� makefile �ļ��ܹ�$SUM------------------"
FILES=`find ./src -name makefile`
NUM=0
for FILE in $FILES
do
   printf "���[%3d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%3d]%%,���ڴ���%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst

   NUM=`expr $NUM + 1`
done
printf " \n \n \n" 
printf "���� makefile �ļ�  ���[%6d]��    \n \n \n" `expr $NUM`
printf " \n \n \n" 

SUM=`find ./src -name "mk.*"|grep -c mk.`
echo "----------------------���ҵ��� mk �ļ��ܹ�$SUM------------------"
FILES=`find ./src -name "mk.*"`
NUM=0
for FILE in $FILES
do
   printf "���[%3d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%3d]%%,���ڴ���%25s...     \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst

   NUM=`expr $NUM + 1`
done
printf " \n \n \n" 
printf "���� mk �ļ�  ���[%6d]��    \n \n \n" `expr $NUM`
printf " \n \n \n" 

SUM=`find . -name "*.h"|grep -c .h|grep -v usr|grep -v backup`
echo "���ҵ��� .h �ļ��ܹ�$SUM"
FILES=`find . -name "*.h"|grep -v usr|grep -v backup`
NUM=0
for FILE in $FILES
do
   printf "���[%5d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%5d]%%,���ڴ���%25s...    \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "���� .h �ļ�  ���[%6d]��         \n \n \n" `expr $NUM`


SUM=`find . -name "*.sh"|grep -c .sh`
echo "���ҵ��� .sh �ļ��ܹ�$SUM"
FILES=`find . -name "*.sh"|grep -v usr`
NUM=0
for FILE in $FILES
do
   printf "���[%5d]%%,                                                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%5d]%%,���ڴ���%25s...    \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "���� .sh �ļ�  ���[%6d]��         \n \n \n" `expr $NUM`



SUM=`find . -name "*.sql"|grep -c .sql|grep -v usr|grep -v backup`
echo "���ҵ��� .sql �ļ��ܹ�$SUM"
FILES=`find . -name "*.sql"|grep -v usr|grep -v backup`
NUM=0
for FILE in $FILES
do
   printf "���[%3d]%%,                       \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%3d]%%,���ڴ���%25s...        \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "���� .sql �ļ�  ���[%3d]%%          \n" `expr $NUM '*' 100 '/' $SUM`


SUM=`find . -name "ubbnew"|grep -v grep`
echo "���ҵ��� .sql �ļ��ܹ�$SUM"
FILES=`find . -name "ubbnew"|grep -v grep`
NUM=0
for FILE in $FILES
do
   printf "���[%3d]%%,                       \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%3d]%%,���ڴ���%25s...        \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "���� ubbnew �ļ�  ���[%3d]%%          \n" `expr $NUM '*' 100 '/' $SUM`


SUM=`find . -name "*.xml"|grep -c .xml`
FILES=`find . -name "*.xml"|grep -v usr`
NUM=0
for FILE in $FILES
do
   printf "���[%5d]%%,                        \r" `expr $NUM '*' 100 '/' $SUM`
   printf "���[%5d]%%,���ڴ���%25s...         \r" `expr $NUM '*' 100 '/' $SUM` $FILE
   echo $FILE >>tmpfile.lst
   NUM=`expr $NUM + 1`
done
printf "���[%5d]%%,                                                                           \r" `expr $NUM '*' 100 '/' $SUM`
echo '��ʼtar����ѡ��'

tar -cvf backup_$todayDate.tar -L tmpfile.lst >>/tmp/tarfile.log
rm -f tmpfile.lst
#����dataoverĿ¼�µĶ������1,dat�ļ���2��libĿ¼�ļ�
#tar -rvf backup_$todayDate.tar ./src/dataover/lib/*
#tar -rvf backup_$todayDate.tar ./src/dataover/sgdata/*
#tar -rvf backup_$todayDate.tar ./src/dataover/patch/*
#tar -rvf backup_$todayDate.tar ./src/dataover/data/*
#tar -rvf backup_$todayDate.tar ./src/dataover/ready-data/*
#tar -rvf backup_$todayDate.tar ./src/dataover/sql/*.cfg
#tar -rvf backup_$todayDate.tar ./src/dataover/sql/*.cfg
#tar -rvf backup_$todayDate.tar ./src/dataover/readme.txt
#tar -rvf backup_$todayDate.tar ./src/dataover/etc
#����binĿ¼�µĶ������
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
