#!/usr/bin/expect

set senderwallet "my_main"
set senderpassword ""

log_user 1

foreach file [glob *.tx.response] {
	puts "Found tx.response '$file'"
	spawn grin-wallet -d $senderwallet finalize -i $file
	expect "Password:"
	send "$senderpassword\r"
	expect "Command 'finalize' completed successfully"
	puts "ok\n"
}
