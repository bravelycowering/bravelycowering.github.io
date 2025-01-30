#onJoin
	replysilent 1|Boot|#setup
quit

#setup
	motd model=invisible -hax +speed +fly +respawn
	reach 0
	cpemsg announce Setting up... This may lag for a minute.
	freeze
	// default packages
	set {} {} {}
	// hide the mb
	tempblock 0 127 127 127
	// create the standing platform
	tempblock 1 64 59 78
	// teleport to it
	cmd tp 64 60 78 0 0
	// clear the colors
	tempchunk 0 0 32 127 127 63 0 0 0
	// create the screen
	tempchunk 0 0 0 127 127 0 0 0 0
	unfreeze
quit

#fill
// X Y color

quit

#copychar
// X Y

#resume
jump {resume}

#replaceUnderscores
	set str {runArg1}
	setsplit str

quit

#input
	msg {runArg1} {runArg2} {runArg3}
quit