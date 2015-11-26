#!/usr/bin/env bash

if [ $# -ne 1 -o "$1" != '1338' ]
then
    echo "Do not use this script directly. Call backup-launcher.sh instead."
    exit 1
fi

echo -n "Date is "
date

echo ""
echo -n "Machine: "
uname -a
uptime

echo ""
echo -n "Backup directory: "
pwd

echo ""
echo "Contents of directory:"
du -sh *

echo ""
echo "Disk space usage:"
df -h

echo ""
echo "---------------------"

baseName="mongodb-dump-`date '+%a-%Hh'`"

echo ""
echo "Dumping MongoDB to $baseName:"
echo ""

mongodump --username "$username" --password "$password" --oplog --out "$baseName"
success=$?

if [ $success -ne 0 ]
then
    echo ""
    echo "mongodump failed, removing dump:"
    echo ""
    rm -fvr "$baseName"
    exit $success
fi

echo ""
echo "mongodump OK, tar:"
echo ""

tarFile="${baseName}.tar.gz"

tar -cvzf "$tarFile" "$baseName"
success=$?

if [ $success -ne 0 ]
then
    echo ""
    echo "tar failed, removing dump and tar:"
    echo ""
    rm -fvr "$baseName"
    rm -fvr "$tarFile"
    exit $success
fi

echo ""
echo "tar OK, removing dump:"
echo ""

rm -fvr "$baseName"

if [ $ftpEnabled -ne 0 ]
then
    echo ""
    echo "Copying via FTP:"
    echo ""
    ncftpput -u "$ftpLogin" -p "$ftpPassword" "$ftpHost" "$ftpPath" "$tarFile"
    success=$?
    if [ $success -ne 0 ]
    then
        echo ""
        echo "Copy via FTP failed"
        echo ""
        exit $success
    fi
fi

if [ $scpEnabled -ne 0 ]
then
    echo ""
    echo "Copying via SCP:"
    echo ""
    if [ ! -r "$scpSshEnv" ]
    then
        echo "$scpSshEnv does not exist or is not readable"
        exit 1
    fi
    . $scpSshEnv
    scp -v "$tarFile" "$scpPath"
    success=$?
    if [ $success -ne 0 ]
    then
        echo ""
        echo "Copy via SCP failed"
        echo ""
        exit $success
    fi
fi
