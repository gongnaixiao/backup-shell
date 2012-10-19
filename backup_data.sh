YORN=`echo $1`
TODAY=`date +'%Y%m%d'`
WORKSPACE=/home/jiaozht
DATA_USER=jzsh
DATA_PASSWD=dhccjrbjzsh
if [ -z "$ORACLE_HOME" ]
then

	export ORACLE_BASE=/home/ora10g
	export ORACLE_HOME=/home/ora10g/product/10.2.1
	export ORACLE_SID=orcl
	export ORACLE_TERM=vt100
	export NLS_LANG="SIMPLIFIED CHINESE_CHINA.ZHS16GBK"
	export NLS_DATE_FORMAT=YYYYMMDDHH24MISS
	export ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data
	export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
	export NLSPATH=/usr/lib/nls/msg/%L/%N:/usr/lib/nls/msg/%L/%N.cat

	# Set shell search paths: 
	export PATH=.:$PATH:$ORACLE_HOME/bin:$ORACLE_HOME/sqlj/bin::

	# CLASSPATH must include the following JRE locations: 
	export CLASSPATH=$ORACLE_HOME/jdbc/lib/classes12.jar:$ORACLE_HOME/sqlj/lib/translator.jar:$ORACLE_HOME/sqlj/lib/runtime12.jar:$CLASSPATH

	BIN=$ORACLE_HOME/bin
fi

FILE=$WORKSPACE/backup/exp_${DATA_USER}_${TODAY}.dmp
LOG="$WORKSPACE/backup/exp_${DATA_USER}_$TODAY.log"
EXP_CMD=" $DATA_USER/$DATA_PASSWD owner=$DATA_USER  compress=n volsize=0 file=$FILE log=$LOG "
echo $YORN
if [ "$YORN" != "-f" ]
then
	echo "È·¶¨\n exp $EXP_CMD \n,(y/n)[y]?"
	read answer
	if [ "$answer" = "n" ]
	then
		exit 1
	fi
	exp $EXP_CMD
else
	$BIN/exp $EXP_CMD
fi
