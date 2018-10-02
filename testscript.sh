echo "cd emulator"
cd ~/Android/Sdk/emulator

echo "start emulator"
# sudo ./emulator64-x86 -avd test -snapshot-list -no-window -no-audio -snapshot snapshot4 -snapstorage ~/snapshots.img &
# sudo ./emulator64-x86 -avd test -snapshot-list -no-window -no-audio -snapshot snapshot4 -snapstorage ~/Android/snapshots_qcow.img &
sudo ./emulator64-x86 -avd test -snapshot-list -no-window -no-audio -snapshot snapshot4 -snapstorage ~/Android/snapshots_qcow2.img &

echo "cd android-ci"
cd ~/Repositories/android-ci

echo "wait for emulator"
until [[ "$bootanim" =~ "stopped" ]]; do
  bootanim=`adb -e shell getprop init.svc.bootanim 2>&1 &`
  if [[ "$bootanim" =~ "device not found" || "$bootanim" =~ "device offline"
    || "$bootanim" =~ "running" ]]; then
    let "failcounter += 10"
    echo "Waiting for emulator to start"
    if [[ $failcounter -gt timeout_in_sec ]]; then
      echo "Timeout ($timeout_in_sec seconds) reached; failed to start emulator"
      exit 1
    fi
  elif [[ "$bootanim" =~ "no emulators found" ]]; then
    echo "No emulators were found"
    exit 1
  fi
  sleep 10
done

echo "Emulator is ready"

adb -e shell getprop init.svc.bootanim
adb devices

token="$(sudo cat ~/.emulator_console_auth_token)"

emulator_name="myemulator"
port="5554"


echo "create snapshot"
./create-snapshot.sh $token $snapshot_name $port
