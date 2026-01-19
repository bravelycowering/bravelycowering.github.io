#play
	cmd tp 4 3 44 180 0
	set Jumps 0
	cpemsg top1 Jumps: {Jumps}
quit

#didjump
	cmd reltp 0 0 -4
	cpemsg top1 Jumps: {Jumps}
	setadd Jumps 1
	allowmbrepeat
quit