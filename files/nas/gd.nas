#onJoin
#reloop
	cmd oss #loop repeatable
terminate

#loop
	if abort quit
	boost 0.9 0 0 1 0 1
	delay 100
	if actionCount|>=|50000 jump #reloop
jump #loop

#setgcol
	env clouds {runArg1}
quit

#setbgcol
	env sky {runArg1}
	env fog {runArg1}
quit

#hax
	cmd maphack
	set abort true
	env cloudheight 0
quit