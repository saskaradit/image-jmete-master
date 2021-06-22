#!/bin/bash

# Run the jmeter from the Jmeter bin directory

set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

mv /opt/apache-jmeter-5.3/data/master.jmx /opt/apache-jmeter-5.3/bin/run.jmx 

echo "===========Running Jmeter============="
echo "======================================"
echo "JVM_ARGS=${JVM_ARGS}"
echo "======================================"
echo "Docker arguments jmeter args=$@"
echo "======================================"

jmeter -n -t /opt/apache-jmeter-5.3/bin/run.jmx -l /opt/apache-jmeter-5.3/data/result.csv -e -o /opt/apache-jmeter-5.3/data/Result -R $@
echo "===========End of Run================="