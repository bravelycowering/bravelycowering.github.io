#test
	msg 1
	delay 1000
	msg 2
	delay 1000
	msg 3
	allowmbrepeat
	newthread #test2
terminate

#test2
	delay 1000
	msg 4
	delay 1000
	msg 5
quit