#!/bin/bash
set -e
Time="$(date +"%m-%d-%y")"
echo $Time"Set the time" > $DIR/debug.txt
mkdir -p Temp
echo $Time"Made the directory Temp" >> $DIR/debug.txt

echo $Time"Checked GIT version" >> $DIR/debug.txt
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd  )"
ExitError(){
  echo "Program exited with an error! Check the debug file. Severity: $1"
  cd $DIR
  cd Temp
  rm *
  exit $ErrorCode
}
echo $Time"Set the ExitError function" >> $DIR/debug.txt

echo "Reading config...." >&2
. $DIR/Config.cfg
source $DIR/Config.cfg
if [ "$Auto" = "True" ]; then
  FillVar=True
fi
SourceFile=$1
if [ "$FillVar" = "True" ]; then
   if [ -z $SourceFile ]; then
	SourceFile="/var/log/auth.log"
fi
fi
echo $SourceFile
cd $DIR/Temp
echo $Time"CD to dir var" >> $DIR/debug.txt
wget https://raw.githubusercontent.com/Senvr11/debian-ip-filecheck/master/Files/VERSION
echo $Time"get github file" >> $DIR/debug.txt
UpVer=$(cat VERSION)
echo $Time"check" >> $DIR/debug.txt
Version=$(cat $DIR/Files/VERSION)
echo $Time"im lasy" >> $DIR/debug.txt
if [ ! "$UpVer" = "$Version" ]; then
bash $DIR/Files/Update.sh
else
echo "No update required."
fi
which git &> /dev/null || { echo >&2 "I require git but it's not installed.  Aborting."; ExitError 1; }
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
if [ ! -f $SourceFile ]; then
    File="False"
    FileError="file doesn't exist."
fi
if [ ! -r $SourceFile ]; then
	File="False"
	FileError="file could not be read. check permissions"
fi	
if [ ! -s $SourceFile ]; then
	File="False"
	FileError="filesize less than zero"
fi




echo $Time" " >> $DIR/debug.txt
cd $DIR
clear
echo "IP.F.C, version $Version. Created by Senvr11"
echo ""
if [[ $File == "False" ]]; then
  echo "File $SourceFile: Could not be read because: $FileError. A file was created in $DIR called debug.txt."
  ExitError 1
fi
###Scraping file for IPs
fileA=$DIR/Temp/TempFile.A.txt
if [ ! -e "$fileA" ] ; then
    touch "$fileA"
fi

if [ ! -w "$fileA" ] ; then
    echo cannot write to $file
    ExitError 2
fi
echo $Auto
if [ "$Auto" = "False" ]; then
 echo "Please enter the file you would like to scan! (To disable this feature, go to $DIR/Config.cfg and turn "Auto" to False. (CASES MATTER!!!!)"
 read SourceFile
fi

sudo grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" $SourceFile > $DIR/Temp/TempFile.A.txt
cd $DIR/Temp
perl -ne 'print if ! $a{$_}++' $DIR/Temp/TempFile.A.txt > $DIR/Temp/TempFIle.B.txt

