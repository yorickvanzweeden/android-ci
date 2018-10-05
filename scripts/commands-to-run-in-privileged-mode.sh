#!/usr/bin/env bash
echo "#############################"
echo " Running privileged commands"
echo "#############################"

echo "Hier met je netstat"
apt update
apt install net-tools

echo "## Running emulator and saving snapshot"
/sdk/emulator/emulator -avd "$1" -no-window -no-audio -no-snapshot-load -memory 2048 &

echo "alias imginfo='/sdk/emulator/qemu-img info ~/.android/avd/"$1".avd/userdata-qemu.img.qcow2'" >> ~/.bashrc
echo "alias emustatus='/sdk/platform-tools/adb -e shell getprop init.svc.bootanim'" >> ~/.bashrc
echo "alias adb='/sdk/platform-tools/adb'" >> ~/.bashrc
echo "alias runemu='/sdk/emulator/emulator -avd myavd -no-snapshot -no-window -no-audio -memory 2048 -verbose'" >> ~/.bashrc

echo "nee" > ~/.emulator_console_auth_token

echo "## Waiting for emulator to come online"
./telnet-wait-for-emulator
./android-wait-for-emulator

echo "## Obtaining auth token"
token="$(cat ~/.emulator_console_auth_token)"
snapshot_name="$2"
port="5554"

echo "## Creating snapshot"
./create-snapshot.sh $token $snapshot_name $port

sleep 15

echo "## Waiting until state has been saved"

while [[ -e ~/.android/avd/"$1".avd/hardware-qemu.ini.lock ]]; do
	echo "State has not been fully saved"
	sleep 1
done
