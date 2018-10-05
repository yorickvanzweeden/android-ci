#!/usr/bin/expect -f

set snapshot_name [lindex $argv 0];

set port [lindex $argv 2]
if {$port == ""} {
  set port "5554"
}

# Spawn telnet
spawn telnet localhost $port

# Wait till OK is shown
expect "OK"

# Authenticate
send "auth nee\r"

# Wait till OK is shown
expect "OK"

# Wait till OK is shown
send "avd snapshot load $snapshot_name\r"

# Wait till OK is shown
expect "OK"

# Kill emulator
send "exit\r"

# Wait till OK is shown
expect "OK"
