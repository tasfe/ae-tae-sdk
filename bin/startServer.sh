#!/bin/sh


SCRIPT_PATH=`dirname $0`
cd $SCRIPT_PATH
CURRENT_DIR=`pwd`
export DCSDK_HOME="$CURRENT_DIR/.."

start_jar_found(){
	JETTY_OPTS="-Dfile.encoding=UTF-8 -jar $START_JAR  $DCSDK_HOME/conf/jetty.xml"
	if [ "$JAVA_OPTS" ];then
		JETTY_OPTS="$JAVA_OPTS $JETTY_OPTS"
	fi
	cd $JETTY_HOME
	echo "$JETTY_OPTS"
	$JAVA_HOME/bin/java $JETTY_OPTS
}

java_found(){
	JETTY_HOME=$DCSDK_HOME/lib/jetty
	JAVA_OPTS="$JAVA_OPTS -client"
	JAVA_OPTS="$JAVA_OPTS -XX:+AggressiveOpts"
	JAVA_OPTS="$JAVA_OPTS -XX:+UseParallelGC"
	JAVA_OPTS="$JAVA_OPTS -XX:+UseStringCache"
	JAVA_OPTS="$JAVA_OPTS -XX:+UseBiasedLocking"
	JAVA_OPTS="$JAVA_OPTS -XX:+UseFastAccessorMethods"
	JAVA_OPTS="$JAVA_OPTS -XX:MaxPermSize=256m"
	JAVA_OPTS="$JAVA_OPTS -javaagent:$DCSDK_HOME/lib/taobao/ae-sdk-agent-2.0.0-SNAPSHOT.jar"
	JAVA_OPTS="$JAVA_OPTS -DDCSDK_HOME=$DCSDK_HOME"
	JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
    JAVA_OPTS="$JAVA_OPTS -Dmain.class=com.taobao.tae.sdk.platform.Main"
    JAVA_OPTS="$JAVA_OPTS -DSTART=$DCSDK_HOME/conf/start.config"
    JAVA_OPTS="$JAVA_OPTS -Djava.io.tmpdir=$DCSDK_HOME/temp"
    JAVA_OPTS="$JAVA_OPTS -Duser.home=$DCSDK_HOME/temp"
    JAVA_OPTS="$JAVA_OPTS -Duser.dir=$DCSDK_HOME/temp"
    JAVA_OPTS="$JAVA_OPTS -Ddevelopment.mode=true"
	JAVA_OPTS="$JAVA_OPTS -Xrunjdwp:transport=dt_socket,address=2020,server=y,suspend=n"
	START_JAR=""
	for _START_JAR in $JETTY_HOME/start*.jar
	do
		START_JAR=$_START_JAR
	done
	if [ "$START_JAR" ];then
		start_jar_found
	else
		echo "start.jar was not found.  Check your SDK installation."
		exit 1
	fi
}

start(){
	TEMP_JAVA_HOME="$DCSDK_HOME/jre"
	if [ -x "$TEMP_JAVA_HOME/bin/java" ];then
	       JAVA_HOME=$TEMP_JAVA_HOME
	fi
	if [ -d "/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home" ];then
        JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home
    fi
	if [ -x "$JAVA_HOME/bin/java" ];then
		java_found
	else
		echo "JAVA_HOME does not point at a JDK or JRE.  Either set the JAVA_HOME environment variable or specify a JDK."
		exit 1
	fi
}

start

