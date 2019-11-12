#!/usr/bin/expect

log_user 1

foreach file [glob *.tx] {
	set walletname [lindex [split $file "."] 0]
	if { [file exists $walletname] == 1} {
		puts "Found tx '$file' and matching wallet"
		spawn grin-wallet -d $walletname receive -i $file
		expect "Password:"
		send "\r"
		expect "Command 'receive' completed successfully"
		puts "ok\n"
	} else {
		puts "Missing wallet directory '$walletname' for tx '$file'"
	}
}
