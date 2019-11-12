#!/usr/bin/expect

set senderwallet "my_main"
set senderpassword ""
set amount "1.0"
set numwallets 2
set walletprefix "my_"

log_user 0

# send to self in order to create enough outputs
puts "sending 0.1 GRIN to myself and create [expr $numwallets + 1] change outputs"
spawn grin-wallet -d $senderwallet send -o [expr $numwallets + 1] -m self 0.1
expect "Password:"
send "$senderpassword\r"

lassign [wait] pid spawnid os_error_flag value
if {$os_error_flag == 0 && $value == 0} {
	puts "==> ok\n"
} else {
	puts "==> ERROR, aborting"
	exit
}

puts "now I sleep for 10 minutes, so the outputs get confirmed...\n"

after 600000

for {set i 1} {$i <= $numwallets} {incr i} {
	while {1} {
		puts "tx $i: trying to create tx"
		spawn ./grin-wallet -d $senderwallet send -d $walletprefix$i.tx -m file -s smallest $amount
		expect "Password:"
		send "$senderpassword\r"
		lassign [wait] pid spawnid os_error_flag value
		if {$os_error_flag == 0 && $value == 0} {
			puts "tx $i: Created $walletprefix$i.tx\n"
			break
		} elseif {$os_error_flag == 0 && $value == 1} {
			puts "tx $i: grin-wallet returned an error, trying again in a minute"
			after 60000
		} else {
			puts "unknown error, EXIT"
			exit 1
		}
	}	
}

