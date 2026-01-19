#play
	cmd tp 4 3 44 180 0
	set Jumps 0
	cpemsg top1 Jumps: {Jumps}
	boost 0 0 0 1 1 1
	allowmbrepeat
quit

#didjump
	cmd reltp 0 0 -4
	setadd Jumps 1
	cpemsg top1 Jumps: {Jumps}
	allowmbrepeat
quit