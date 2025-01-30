#onJoin
	cpemsg announce Setting up... This may lag for a minute.
	// default packages
	set {} {} {}
	// hide the mb
	tempblock 0 127 127 126
	// create the standing platform
	tempblock 1 64 59 50
	// teleport to it
	cmd tp 64 60 50 180 0
	// clear the colors
	tempchunk 0 0 16 127 127 31 0 0 0
	// create the screen
	tempchunk 0 0 0 127 127 0 0 0 127
quit

#replaceUnderscores
	set str {runArg1}
	setsplit str

quit

#input
	msg {runArg1}
quit