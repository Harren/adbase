#!/bin/bash

#{{{ options
echo "Start cmake configure....."
echo -e "\033[31m\033[05m编译 Debug 级别 [Debug(D)|Release(R)]: \033[0m\c"
read makelevel
case $makelevel in
	Debug | D )
		CMAKE_BUILD_TYPE="Debug";;
	Release | R )
		CMAKE_BUILD_TYPE="Release";;
	*)
		CMAKE_BUILD_TYPE="Debug";;
esac
echo -e "\033[31m\033[05m编译环境[32bit(32)|64bit(64)]: \033[0m\c"
read makebit
case $makebit in
	32bit | 32 )
		M32=1;;
	64bit | 64 )
		M32=0;;
	*)
		M32=0;;
esac
echo -e "\033[31m\033[05m安装 adbase_kafka 模块 [Y|N]: \033[0m\c"
read usekafka
case $usekafka in
	Y | y )
		USEKAFKA=1;;
	N | n )
		USEKAFKA=0;;
	*)
		USEKAFKA=1;;
esac
echo -e "\033[31m\033[05m是否是开发模式 [Y|N]: \033[0m\c"
read isdev
case $isdev in
	Y | y )
		DEV=1;;
	N | n )
		DEV=0;;
	*)
		DEV=1;;
esac

# }}}

# 计算版本号
LAST_TAG=`git tag|tail -n 1`
VERSION=${LAST_TAG/v/}
VERSION_TMP=(${VERSION//\./ })
SOVERSION=${VERSION_TMP[0]}

# 判断是否打标签
COMMITDIFFNUM=`git diff HEAD $LAST_TAG --numstat |wc -l`
if [ $COMMITDIFFNUM -gt 0 ]; then
	SOVERSION=999
fi

CMD="cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DM32=$M32 -DUSEKAFKA=$USEKAFKA  -DADINFVERSION=$VERSION -DADINFSOVERSION=$SOVERSION -DDEV=$DEV -DCMAKE_CXX_COMPILER=g++ .."

if [ -d ./build ]; then
	echo "mkdir build.";
else
	mkdir ./build;
fi
cd ./build;
echo $CMD
eval $CMD
