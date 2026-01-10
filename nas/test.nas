#onJoin
	set threads 0
quit

#tick
	cpemsg top1 AC: {actionCount}
	delay 200
	if actionCount|>=|100 jump #newloop|#tick
ifnot ABORT jump #tick

#newloop
	newthread {runArg1}
	setadd threads 1
	msg THREADS: {threads}
terminate