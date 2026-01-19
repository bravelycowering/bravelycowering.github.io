#play
	cmd tp 4 3 44 180 0
	set Jumps 0
	cpemsg top1 Jumps: {Jumps}
	boost 0 0 0 1 1 1
	allowmbrepeat
	tempchunk 4 2 43 4 2 45 4 2 43
quit

#didjump
	cmd reltp 0 0 -4
	setadd Jumps 1
	cpemsg top1 Jumps: {Jumps}
	allowmbrepeat
	tempchunk 4 2 48 4 2 49 4 2 44
	delay 100
	tempblock 215 4 2 44
	delay 100
	tempblock 215 4 2 45
quit