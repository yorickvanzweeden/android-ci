#!/usr/bin/env bash
echo "#############################"
echo " Running privileged commands"
echo "#############################"

echo "## Running emulator and saving snapshot"
/sdk/emulator/emulator -avd test -no-window -no-audio -no-snapshot-save &

echo "## Waiting for emulator to come online"
./android-wait-for-emulator

echo "## Obtaining auth token"
token="$(cat ~/.emulator_console_auth_token)"
snapshot_name="myemulator"
port="5554"

echo "## Creating snapshot"
./create-snapshot.sh $token $snapshot_name $port

echo "## Waiting until state has been saved"

while [[ -e ~/.android/avd/test.avd/hardware-qemu.ini.lock ]]; do
	echo "State has not been fully saved"
	sleep 1
done
