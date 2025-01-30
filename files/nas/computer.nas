#onJoin
	// hide the mb
	tempblock 0 127 127 127
	// give the option to boot
	replysilent 1|Boot|#setup
quit

#setup
	motd model=invisible -hax +speed +fly +respawn
	reach 0
	cpemsg announce Setting up... This may lag for a minute.
	freeze
	// default packages
	set {} {} {}
	// create the standing platform
	tempblock 751 64 59 78
	// clear the colors, leave black to be the screen
	tempchunk 0 0 33 127 127 63 0 0 1
	// teleport to it
	cmd tp 64 60 78 0 0
	unfreeze
quit

#fill
// X Y X2 Y2 color
	tempchunk {runArg1} {runArg2} {runArg5} {runArg3} {runArg4} {runArg5} {runArg1} {runArg2} 0
quit

#copychar
// sX sY X Y
	set sX2 {runArg1}
	set sY2 {runArg2}
	setadd sX2 3
	setadd sY2 7
	tempchunk {runArg1} {runArg2} 17 {sX2} {sY2} 17 {runArg3} {runArg4} 0
quit

#resume
jump {resume}

#replaceUnderscores
	set str {runArg1}
	setsplit str

quit

#input
	msg {runArg1} {runArg2} {runArg3}
quit