#!/bin/bash
ExitError(){
  if [ -z "$1"];
  then
    ErrorCode=1
  echo ""

  echo "Program exited with an error! Check the debug file. Severity: $1"
  exit $ErrorCode
}
set -e
echo "Setting variables"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd  )"
Version=$(cat $DIR/Files/VERSION)
platform='unknown'
unamestr=`uname`
echo "Checking platform"
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
echo "Checking if file is real"
SourceFile=$1
if [ ! -f $SourceFile ]; then
    File="False"
    FileError="file doesn't exist."
fi
echo "Checking if file is readable"
if [ ! -r $SourceFile ]; then
	File="False"
	FileError="file could not be read"
fi	
echo "Checking if file has a size greator than zero"
if [ ! -s $SourceFile ]; then
	File="False"
	FileError="filesize less than zero"
fi

echo "Making debug file"
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
clear
echo "IP.F.C, version $Version. Created by Senvr11"
echo ""
if [[ $File == "False" ]]; then
  echo "File $SourceFile: Could not be read because: $FileError. A file was created in $DIR called debug.txt."
  ExitError 1
fi
###Scraping file for IPs
IPs=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' $SourceFile)

