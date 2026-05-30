#test
	newthread #thread
	cmd main
quit

#thread
	show LevelName
	if LevelName|=|"bravelycowering+8" newthread #thread
	else newthread #thread2
quit

#thread2
	msg one
	delay 1000
	msg two
	delay 1000
	msg three
quit
