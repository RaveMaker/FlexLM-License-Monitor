#!/bin/bash

workdir=/scripts
logfile=$workdir/license-check.run
listfile=$workdir/license-check.lst
finallogfile=$workdir/license-check-$(date +%y%m%d)
emailfile=$workdir/license-check.email
emailaddress="mymail@mail.com"

(
cd $workdir/
if [ -a $logfile ] ; then
    echo ""
    echo "Script is Running! check " $logfile
    echo ""
    exit; 
fi

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
    cat $emailfile |mail -s "licenses check on LicServer01 and LicServer02" $emailaddress
    rm -f $emailfile
fi

