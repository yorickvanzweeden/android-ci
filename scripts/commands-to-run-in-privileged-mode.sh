#!/usr/bin/env bash
echo "#############################"
echo " Running privileged commands"
echo "#############################"

echo "## Running emulator and saving snapshot"
/sdk/emulator/emulator -avd "$1" -no-window -no-audio -no-snapshot-save &

echo "## Waiting for emulator to come online"
./android-wait-for-emulator

echo "## Making sure the emulator has fully booted"
sleep 15

echo "## Obtaining auth token"
token="$(cat ~/.emulator_console_auth_token)"
snapshot_name="$2"
port="5554"

echo "## Creating snapshot"
./create-snapshot.sh $token $snapshot_name $port

echo "## Waiting until state has been saved"

while [[ -e ~/.android/avd/"$1".avd/hardware-qemu.ini.lock ]]; do
	echo "State has not been fully saved"
	sleep 1
done
