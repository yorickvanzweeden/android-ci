#!/usr/bin/expect -f

# Get token argument
set token [lindex $argv 0];

# Get token argument
set snapshot_name [lindex $argv 1];

# Get port argument or set to 5554
set port [lindex $argv 2]
if {$port == ""} {
  set port "5554"
}

# Spawn telnet
spawn telnet localhost $port

# Wait till OK is shown
expect "OK"

# Authenticate
send "auth $token\r"

# Wait till OK is shown
expect "OK"

# Wait till OK is shown
send "avd snapshot save $snapshot_name\r"

# Wait till OK is shown
expect "OK"

# Kill emulator
send "kill\r"

# Wait till OK is shown
expect "OK"