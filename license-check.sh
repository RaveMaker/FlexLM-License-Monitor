#!/bin/bash

# Runs a FlexLM licenses test on multiple servers and ports.
# Sends a report in case of an expired/malfunctioned license.
#
# by RaveMaker - http://ravemaker.net

# Load settings

SCRIPTDIRECTORY=$(cd `dirname $0` && pwd)
cd $SCRIPTDIRECTORY
if [ -f settings.cfg ] ; then
    echo "Loading settings..."
    source settings.cfg
else
    echo "ERROR: Create settings.cfg (from settings.cfg.example)"
    exit
fi;

workdir=`pwd`
logfile=$workdir/license-check.run
listfile=$workdir/license-check.lst
finallogfile=$workdir/license-check-$(date +%y%m%d)
emailfile=$workdir/license-check.email

(
cd $workdir/
cat $listfile | while read line
do
	appname=$(echo $line | awk '{print $(NF-1)}')
	portserver=$(echo $line | awk '{print $NF}')
	/usr/bin/lmutil lmstat -a -c $portserver |grep Error
	if [ $? != 1 ] ; then
	    echo $appname license DOWN - $portserver >> $emailfile
	    echo "================================================================================"
	    echo $appname license DOWN - $portserver
	    echo "================================================================================"
	else
	    echo "================================================================================"
	    echo $appname license OK - $portserver
	    echo "================================================================================"
	fi
done
echo ""
echo "**************************************"
echo "*****           All Done         *****"
echo "**************************************"
echo ""
) 2>&1 | tee -a $logfile
mv $logfile $finallogfile

if [ -a $emailfile ] ; then 
    echo "**************************************"
    cat $emailfile
    echo "**************************************"
    cat $emailfile |mail -s "licenses check" $emailaddress
    rm -f $emailfile
fi
