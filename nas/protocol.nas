using local_packages

#onJoin
	set next[36] black
	set next[34] sign
	set next[171] plaque
	set next[608] white
	setblockid current 1 0 0
	if next[{current}]|=|"" set next[{current}] white
jump #newloop|#tick

#input
	call #writepacket|{runArg1}|{runArg2}
quit

#writepacket
	setblockid l_state 1 0 0
	set l_prefix
	ifnot l_state|=|current setblockmessage l_prefix 1 0 0
	placemessageblock {next[{current}]} 1 0 0 {l_prefix}{runArg1}|{runArg2}|
quit

#handlepacket
	msg name: {runArg1}
	msg data: {runArg2}
quit

#tick
	setblockid l_state 1 0 0
	if l_state|=|current jump #skipreadpackets
		set current {l_state}
		setblockmessage l_data 1 0 0
		setsplit l_data |
		set l_i 0
		#loophandlepackets
			set l_call #handlepacket|{l_data[{l_i}]}
			setadd l_i 1
			call {l_call}|{l_data[{l_i}]}
			setadd l_i 1
		if l_i|<|l_data.length jump #loophandlepackets
	#skipreadpackets
	// debug
	cpemsg top1 {actionCount}/60000
	// loop
	delay 50
	if actionCount|>=|60000 jump #newloop|#tick
jump #tick

#newloop
	set LoopPoint {runArg1}
	cmd m 0 0 0
terminate

#resumeloop
	set l_lbl {LoopPoint}
	set LoopPoint
	ifnot l_lbl|=|"" jump {l_lbl}
quit