using local_packages
using no_runarg_underscore_conversion

#onJoin
	set next[36] black
	set next[34] sign
	set next[171] plaque
	set next[608] white
	setblockid current 1 0 0
	if next[{current}]|=|"" set next[{current}] white
jump #newloop|#tick

#input
#writepacket
	setblockid l_state 1 0 0
	set l_prefix
	ifnot l_state|=|current setblockmessage l_prefix 1 0 0
	placemessageblock {next[{current}]} 1 0 0 {l_prefix}{runArg1}|{runArg2}|
quit

#handleunknownpacket
	msg name: {runArg1}
	msg data: {runArg2}
quit

#packet:#+cmd
	cmd {runArg1}
quit

#packet:env
	env {runArg1}
quit

#packet:motd
	motd {runArg1}
quit

#tick
	setblockid l_state 1 0 0
	if l_state|=|current jump #skipreadpackets
		set current {l_state}
		setblockmessage l_data 1 0 0
		setsplit l_data |
		set l_i 0
		#loophandlepackets
			set l_call {l_data[{l_i}]}
			setadd l_i 1
			if label #packet:{l_call} call #packet:{l_call}|{l_data[{l_i}]}
			else call #handleunknownpacket|{l_call}|{l_data[{l_i}]}
			setadd l_i 1
		if l_i|<|l_data.length jump #loophandlepackets
	#skipreadpackets
	// debug
	cpemsg top1 actionCount: {actionCount}/60000
	// loop
	delay 100
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