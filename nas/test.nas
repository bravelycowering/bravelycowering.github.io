#test
	newthread #thread
	cmd main
quit

#thread
	newthread #thread2
quit

#thread2
	msg one
	delay 1000
	msg two
	delay 1000
	msg three
quit
