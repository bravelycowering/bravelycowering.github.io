#test
	msg 1
	delay 1000
	msg 2
	delay 1000
	msg 3
	newthread #test2
	msg post thread creation
	allowmbrepeat
terminate

#test2
	delay 1000
	msg 4
	delay 1000
	msg 5
quit