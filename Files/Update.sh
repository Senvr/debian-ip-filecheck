#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd  )"
cd $DIR
cd ..
. Config.cfg

if [ "$NoUpdate" = "True" ]; then
echo "Due to the configuration in Config.cfg, the auto updating feature has been disabled."
exit 0
fi
ExitError(){
  echo "Program exited with an error! Check the debug file. Severity: $1"
  cd $DIR
  cd Temp
  rm *
  exit $ErrorCode
}
if [[ ! $EUID -ne 0 ]]; then
   echo "This script cannot be ran as root." 
   ExitError 1
fi
echo "IPFC Update Module."
echo ""
echo "WARNING: YOU HAVE TEN SECONDS TO CANCEL THE UPDATE."
sleep 1
echo ""
echo "Commencing update!"
sleep 2


echo ""
echo "Set dir var"
cd $DIR
cd ..
cd Temp
ls

rm VERSION.* 
echo ""
echo "remove"
UpVer=$(cat VERSION)
Version=$(cat $DIR/VERSION)
if [ ! "$UpVer" = "$Version" ]; then
echo "Update needed."
cd $DIR
cd ..
git clone https://github.com/Senvr11/debian-ip-filecheck.git
cd debian-ip-filecheck
cp -R * ../
rm -R debian-ip-filecheck
echo "Updated. Restart script."
exit 0
else
echo "No update required."
fi

rm VERSION* &> /dev/null
cd $DIR
cd ..
ls
sudo chown -R $USER ./
clear
echo "Finished."
