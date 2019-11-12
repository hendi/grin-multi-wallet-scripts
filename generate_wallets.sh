#!/usr/bin/expect

set numwallets 2
set walletprefix "my_"

log_user 0

for {set i 1} {$i <= $numwallets} {incr i} {
	set walletname $walletprefix$i
	spawn grin-wallet -d $walletname init
	expect "Password:"
	send "\r"
	expect "Confirm Password:"
	send "\r"
	expect "Your recovery phrase is:"
	expect "Please back-up these words in a non-digital format."
	set seed [lindex [split $expect_out(buffer) "\n"] 2]
	puts "$walletname,$seed"
}
