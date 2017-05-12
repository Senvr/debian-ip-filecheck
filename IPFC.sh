#!/bin/bash
set -e
which git &> /dev/null || { echo >&2 "I require git but it's not installed.  Aborting."; ExitError 1; }
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd  )"
cd $DIR/Temp
wget https://raw.githubusercontent.com/Senvr11/debian-ip-filecheck/master/Files/VERSION
UpVer=$(cat VERSION)
clear
if [ ! "$UpVer" = "$Version" ]; then
bash $DIR/Files/Update.sh
exit 0
else
echo "No update required."
fi

cd $DIR
Version=$(cat $DIR/Files/VERSION)
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
   echo "WARNING: PROGRAM IS NOT SUITED FOR THIS PLATFORM. I DO NOT RECOMMEND RUNNING! YOU HAVE BEEN WARNED."
   sleep 10
else 
   echo "WARNING: PROGRAM CANNOT DETERMINE PLATFORM. I DO NOT RECOMMEND RUNNING! YOU HAVE BEEN WARNED."
   sleep 10
fi
SourceFile=$1
if [ ! -f $SourceFile ]; then
    File="False"
    FileError="file doesn't exist."
fi
if [ ! -r $SourceFile ]; then
	File="False"
	FileError="file could not be read"
fi	
if [ ! -s $SourceFile ]; then
	File="False"
	FileError="filesize less than zero"
fi

ExitError(){
  echo "Program exited with an error! Check the debug file. Severity: $1"
  exit $ErrorCode
}

cat >$DIR/debug.txt <<EOL
Variables:
================
$SourceFile
$DIR
$Version
$platform
$unamestr
$RealFile
$File
=================
Read: $SourceFile. Success: $File. Error (if any): $FileError
=================
End debug
EOL
cd $DIR
clear
echo "IP.F.C, version $Version. Created by Senvr11"
echo ""
if [[ $File == "False" ]]; then
  echo "File $SourceFile: Could not be read because: $FileError. A file was created in $DIR called debug.txt."
  ExitError 1
fi
###Scraping file for IPs
IPs=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $SourceFile)

