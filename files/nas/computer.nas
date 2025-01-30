#onJoin
	msg Setting up... This may lag for a minute.
	// default packages
	set {} {} {}
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