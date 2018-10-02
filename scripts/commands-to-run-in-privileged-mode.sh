#!/usr/bin/env bash
echo "Running further commands"

mkdir /sdk/snapshot/
cp -r /sdk/snapshot_temp/* /sdk/snapshot/

exit
echo "HELLL"
echo "## Create snapshot container"
/sdk/emulator/qemu-img create -f qcow2 /sdk/emulator/snapshots.img 500M

echo "## Run emulator and save snapshot"
/sdk/emulator/emulator64-x86 -avd test -no-window -no-audio -snapshot snapshot2 -snapstorage /sdk/emulator/snapshots.img &

echo "## Wait for emulator to come online"
./android-wait-for-emulator

echo "## Obtain auth token"
token="$(cat ~/.emulator_console_auth_token)"
emulator_name="myemulator"
port="5554"

# Use tellnet
apt-get update
echo "## Install telnet"
apt-get install -y telnet

echo "## Install tzdata"
ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
apt-get install -y tzdata

echo "## Install expect"
echo y | apt-get install expect

echo "## Create snapshot"
./create-snapshot.sh $token $snapshot_name $port

