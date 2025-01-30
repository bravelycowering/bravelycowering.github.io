using allow_include

#Pipes:version
// (no arguments)
	msg &fRunning Pipes &a2.2
quit

// runs the pipestone at the message block
#Pipes:messageblock
// (message block) (no arguments)
	allowmbrepeat
	set X {MBX}
	set Y {MBY}
	set Z {MBZ}
	set coords {MBCoords}
	set dir ?
	setblockid id {coords}
	// prerun
	if label #Pipes:prerun[{id}] call #Pipes:prerun[{id}]
	// adds the lines
	call #Pipes:softbox
	if Pipes.inprogress quit
	set Pipes.tick 0
	set Pipes.maxtick 0
jump #Pipes:doalllines

// runs the pipestone at the click event
#Pipes:clickevent
// (clickevent block) (no arguments)
	allowmbrepeat
	set coords {click.coords}
	setsplit coords " "
	set X {coords[0]}
	set Y {coords[1]}
	set Z {coords[2]}
	set dir ?
	setblockid id {coords}
	// prerun
	if label #Pipes:prerun[{id}] call #Pipes:prerun[{id}]
	// adds the lines
	call #Pipes:softbox
	if Pipes.inprogress quit
	set Pipes.tick 0
	set Pipes.maxtick 0
jump #Pipes:doalllines

// delays are 1 indexed
#Pipes:schedulebox
// X, Y, Z, in
	set Pipes.temp {Pipes.tick}
	setadd Pipes.temp {runArg1}
	if Pipes.maxtick|<|{Pipes.temp} set Pipes.maxtick {Pipes.temp}
	setadd Pipes.delay{Pipes.temp}.length 1
	set Pipes.delay{Pipes.temp}[{Pipes.delay{Pipes.temp}.length}].X {X}
	set Pipes.delay{Pipes.temp}[{Pipes.delay{Pipes.temp}.length}].Y {Y}
	set Pipes.delay{Pipes.temp}[{Pipes.delay{Pipes.temp}.length}].Z {Z}
	set Pipes.delay{Pipes.temp}[{Pipes.delay{Pipes.temp}.length}].dir {dir}
quit

// keep in mind, lines are 1-indexed
#Pipes:pushline
// X, Y, Z, Direction
	ifnot Pipes.line{Pipes.lines}.ceased setadd Pipes.lines 1
	set Pipes.line{Pipes.lines}.X {runArg1}
	set Pipes.line{Pipes.lines}.Y {runArg2}
	set Pipes.line{Pipes.lines}.Z {runArg3}
	setblockid Pipes.line{Pipes.lines}.id {runArg1} {runArg2} {runArg3}
	set Pipes.line{Pipes.lines}.dir {runArg4}
	set Pipes.line{Pipes.lines}.ceased false
quit

#Pipes:doalllines
// (no arguments)
	set Pipes.inprogress true
	set Pipes.index 0
	set Pipes.validlines false
	#Pipes:lineloop
	// (no arguments)
		// spin up a new thread if action count is running high
		if actionCount|>|50000 jump #Pipes:failsafe|#Pipes:lineloop
		setadd Pipes.index 1
		if Pipes.line{Pipes.index}.ceased jump #Pipes:skip
		set Pipes.validlines true
		// unwrap once
		set id {Pipes.line{Pipes.index}.id}
		// if pipes move in pipe direction
		if id|=|550 jump #Pipes:{Pipes.line{Pipes.index}.dir}
		if id|=|551 jump #Pipes:{Pipes.line{Pipes.index}.dir}
		if id|=|552 jump #Pipes:{Pipes.line{Pipes.index}.dir}
		// if box then do box
		if id|=|238 jump #Pipes:box
		// if delay do delay
		if id|=|485 jump #Pipes:delay|1
		if id|=|486 jump #Pipes:delay|2
		if id|=|487 jump #Pipes:delay|3
		if id|=|488 jump #Pipes:delay|4
		if id|=|489 jump #Pipes:delay|5
		// not a box or a pipe so set packages
		set X {Pipes.line{Pipes.index}.X}
		set Y {Pipes.line{Pipes.index}.Y}
		set Z {Pipes.line{Pipes.index}.Z}
		set dir {Pipes.line{Pipes.index}.dir}
		set coords {X} {Y} {Z}
		// cease line
		set Pipes.line{Pipes.index}.ceased true
		// and call gizmo if its not been called yet
		if Pipes.gizmo{X},{Y},{Z} jump #Pipes:skip
		set Pipes.gizmo{X},{Y},{Z} true
		if label #Pipes:gizmo[{id}] call #Pipes:gizmo[{id}]
		#Pipes:skip
		if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
	if Pipes.validlines jump #Pipes:doalllines
	// erase everything
	resetdata packages Pipes.line*
	resetdata packages Pipes.gizmo*
	resetdata packages Pipes.box*
	// loop increment tick and delay 100ms until maxticks hit
	#Pipes:tickloop
		setadd Pipes.tick 1
		if Pipes.tick|>|Pipes.maxtick jump #Pipes:cleanup
		delay 100
		// next iteration if it doesnt exist
		if Pipes.delay{Pipes.tick}.length|=|"" jump #Pipes:tickloop
		// loop through all and do boxes
		set Pipes.temp 0
		#Pipes:delayloop
			if actionCount|>|50000 jump #Pipes:failsafe|#Pipes:delayloop
			setadd Pipes.temp 1
			set X {Pipes.delay{Pipes.tick}[{Pipes.temp}].X}
			set Y {Pipes.delay{Pipes.tick}[{Pipes.temp}].Y}
			set Z {Pipes.delay{Pipes.tick}[{Pipes.temp}].Z}
			set dir {Pipes.delay{Pipes.tick}[{Pipes.temp}].dir}
			call #Pipes:softbox
		if Pipes.temp|<|Pipes.delay{Pipes.tick}.length jump #Pipes:delayloop
	jump #Pipes:doalllines
	// cleanup
	#Pipes:cleanup
	resetdata packages Pipes.delay*
	if Pipes.threads|>|0 msg &eUsed {Pipes.threads} thread(s) and {actionCount} actions.
	set Pipes.threads 0
	set Pipes.inprogress false
quit

#Pipes:failsafe
// (no arguments)
	if Pipes.threads|=|0 msg &cWarning: actions exceeded 50k ({actionCount}), using threads to complete...
	setadd Pipes.threads 1
	newthread {runArg1}
quit

#Pipes:X+
// (no arguments)
	setadd Pipes.line{Pipes.index}.X 1
	set Pipes.line{Pipes.index}.dir X+
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:X-
// (no arguments)
	setsub Pipes.line{Pipes.index}.X 1
	set Pipes.line{Pipes.index}.dir X-
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Y+
// (no arguments)
	setadd Pipes.line{Pipes.index}.Y 1
	set Pipes.line{Pipes.index}.dir Y+
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Y-
// (no arguments)
	setsub Pipes.line{Pipes.index}.Y 1
	set Pipes.line{Pipes.index}.dir Y-
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Z+
// (no arguments)
	setadd Pipes.line{Pipes.index}.Z 1
	set Pipes.line{Pipes.index}.dir Z+
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Z-
// (no arguments)
	setsub Pipes.line{Pipes.index}.Z 1
	set Pipes.line{Pipes.index}.dir Z-
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:terminate
resetdata packages
terminate

#Pipes:delay
// in
	// set generic packages
	set X {Pipes.line{Pipes.index}.X}
	set Y {Pipes.line{Pipes.index}.Y}
	set Z {Pipes.line{Pipes.index}.Z}
	set dir {Pipes.line{Pipes.index}.dir}
	// schedule the delay for the runarg
	call #Pipes:schedulebox|{runArg1}
	// cease the line
	set Pipes.line{Pipes.index}.ceased true
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:box
// (no arguments)
	// set generic packages
	set X {Pipes.line{Pipes.index}.X}
	set Y {Pipes.line{Pipes.index}.Y}
	set Z {Pipes.line{Pipes.index}.Z}
	set dir {Pipes.line{Pipes.index}.dir}
	set id {Pipes.line{Pipes.index}.id}
	// cease the line
	set Pipes.line{Pipes.index}.ceased true
	call #Pipes:softbox
	if Pipes.index|<=|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:softbox
// (no arguments)
	if Pipes.box{X},{Y},{Z} quit
	set Pipes.box{X},{Y},{Z} true
	//
	// check X+
	setadd X 1
	setblockid id {X} {Y} {Z}
	if dir|=|"X-" set id 0
	if id|=|551 call #Pipes:pushline|{X}|{Y}|{Z}|X+
	// check X-
	setsub X 2
	setblockid id {X} {Y} {Z}
	if dir|=|"X+" set id 0
	if id|=|551 call #Pipes:pushline|{X}|{Y}|{Z}|X-
	// reset X
	setadd X 1
	//
	// check Z+
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if dir|=|"Z-" set id 0
	if id|=|552 call #Pipes:pushline|{X}|{Y}|{Z}|Z+
	// check Z-
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if dir|=|"Z+" set id 0
	if id|=|552 call #Pipes:pushline|{X}|{Y}|{Z}|Z-
	// reset Z
	setadd Z 1
	//
	// check Y+
	setadd Y 1
	setblockid id {X} {Y} {Z}
	if dir|=|"Y-" set id 0
	if id|=|550 call #Pipes:pushline|{X}|{Y}|{Z}|Y+
	// check Y-
	setsub Y 2
	setblockid id {X} {Y} {Z}
	if dir|=|"Y+" set id 0
	if id|=|550 call #Pipes:pushline|{X}|{Y}|{Z}|Y-
	// reset Y
	setadd Y 1
quit