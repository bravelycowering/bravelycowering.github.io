using allow_include

#Pipes:version
// (no arguments)
	msg &fRunning Pipes &a2.3.12
quit

#Pipes:debug
// (no arguments)
	ifnot Pipes.conf.debug msg &cDebug mode is disabled
	ifnot Pipes.conf.debug quit
quit

#Pipes:setup
// (no arguments)
	set Pipes.setup true
	set Pipes.laststart 0
// ids
	// The block ID to use for UD pipes
	if Pipes.id.pipe-UD|=|"" set Pipes.id.pipe-UD 550
	// The block ID to use for WE pipes
	if Pipes.id.pipe-WE|=|"" set Pipes.id.pipe-WE 551
	// The block ID to use for NS pipes
	if Pipes.id.pipe-NS|=|"" set Pipes.id.pipe-NS 552
	// The block ID to use for Boxes
	if Pipes.id.box|=|"" set Pipes.id.box 238
	// The block ID to use for the start of the list of delays
	if Pipes.id.delay|=|"" set Pipes.id.delay 485
// conf
	// The amount of delays to use. If set to 0, this will disable the delay system entirely.
	if Pipes.conf.delays|=|"" set Pipes.conf.delays 5
	// The maximum number of threads Pipes will make to try and keep running (including the initial thread), setting this to less than 1 will disable making new threads
	if Pipes.conf.maxthreads|=|"" set Pipes.conf.maxthreads 10
	// Whether or not to show a warning after the first thread has been created
	if Pipes.conf.showthreadwarning|=|"" set Pipes.conf.showthreadwarning true
	// The length of each tick in milliseconds
	if Pipes.conf.ticklength|=|"" set Pipes.conf.ticklength 100
	// The length of each step in milliseconds
	if Pipes.conf.steplength|=|"" set Pipes.conf.steplength 0
	// Whether debug logging and stepping is enabled, uses more actions but shows useful information if you run /oss #Pipes:debug [NOT FUNCTIONAL YET]
	if Pipes.conf.debug|=|"" set Pipes.conf.debug false
	// Whether simaltaneous pipestone lines can be triggered by message blocks [NOT FUNCTIONAL YET]
	if Pipes.conf.mbrepeatable|=|"" set Pipes.conf.mbrepeatable true
	// The maximum number of times pipes will attempt to mark a MB to restart itself when it runs out of threads [NOT FUNCTIONAL YET]
	if Pipes.conf.maxrevives|=|"" set Pipes.conf.maxrevives 0
	// Whether or not to show a warning after the first revive has occurred [NOT FUNCTIONAL YET]
	if Pipes.conf.showrevivewarning|=|"" set Pipes.conf.showrevivewarning true
	// The XYZ coordinates of the message block to mark when attempting to revive the script [NOT FUNCTIONAL YET]
	if Pipes.conf.revivecoords|=|"" set Pipes.conf.revivecoords 0 0 0
quit

// runs the pipes at the message block
#Pipes:messageblock
// (message block) (no arguments)
	allowmbrepeat
	set coords {MBCoords}
jump #Pipes:run

// runs the pipes at the click event
#Pipes:clickevent
// (clickevent block) (no arguments)
	set coords {click.coords}
jump #Pipes:run

#Pipes:run
// coords
	ifnot Pipes.setup call #Pipes:setup
	// if in the middle of a tick throw the input out
	if Pipes.doingthings quit
	set Pipes.temp {epochMS}
	setsub {Pipes.conf.ticklength}
	setsub {Pipes.conf.ticklength}
	if Pipes.temp|<|{Pipes.laststart} quit
	set Pipes.laststart {epochMS}
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
// in
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
	set Pipes.doingthings true
	set Pipes.inprogress true
	set Pipes.index 0
	set Pipes.validlines false
	#Pipes:lineloop
	// (no arguments)
		// spin up a new thread if action count is running high
		if actionCount|>|50000 jump #Pipes:failsafe|#Pipes:lineloop
		if Pipes.conf.steplength|>|0 delay {Pipes.conf.steplength}
		setadd Pipes.index 1
		if Pipes.line{Pipes.index}.ceased jump #Pipes:skip
		set Pipes.validlines true
		// unwrap once
		set id {Pipes.line{Pipes.index}.id}
		// if pipes move in pipe direction
		if id|=|{Pipes.id.pipe-UD} jump #Pipes:{Pipes.line{Pipes.index}.dir}
		if id|=|{Pipes.id.pipe-WE} jump #Pipes:{Pipes.line{Pipes.index}.dir}
		if id|=|{Pipes.id.pipe-NS} jump #Pipes:{Pipes.line{Pipes.index}.dir}
		// if box then do box
		if id|=|{Pipes.id.box} jump #Pipes:box
		// if delay do delay
		set Pipes.temp {Pipes.id.delay}
		setadd Pipes.temp {Pipes.conf.delays}
		if id|<|{Pipes.id.delay} jump #Pipes:attemptgizmo
		if id|>=|{Pipes.temp} jump #Pipes:attemptgizmo
		jump #Pipes:delay
		#Pipes:attemptgizmo
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
		if Pipes.index|<|Pipes.lines jump #Pipes:lineloop
	if Pipes.validlines jump #Pipes:doalllines
	// erase everything
	resetdata packages Pipes.line*
	resetdata packages Pipes.gizmo*
	resetdata packages Pipes.box*
	// loop increment tick and delay 100ms until maxticks hit
	#Pipes:tickloop
		if Pipes.lines|>|0 jump #Pipes:doalllines
		setadd Pipes.tick 1
		if Pipes.tick|>|Pipes.maxtick jump #Pipes:cleanup
		set Pipes.doingthings false
		delay {Pipes.conf.ticklength}
		set Pipes.doingthings true
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
		// oh god did i cause a memory leak??????
		resetdata packages Pipes.delay{Pipes.tick}*
	jump #Pipes:doalllines
	// cleanup
	#Pipes:cleanup
	resetdata packages Pipes.delay*
	resetdata packages Pipes.line*
	resetdata packages Pipes.gizmo*
	resetdata packages Pipes.box*
	if Pipes.threads|>|0 msg &eUsed {Pipes.threads} thread(s) and {actionCount} actions.
	set Pipes.threads 0
	set Pipes.inprogress false
	set Pipes.doingthings false
terminate

#Pipes:failsafe
// (no arguments)
	if Pipes.conf.maxthreads|<=|1 msg &cError: actions exceeded 50k ({actionCount}), pipes cannot complete, aborting...
	if Pipes.conf.maxthreads|<=|1 jump #Pipes:cleanup
	ifnot Pipes.conf.showthreadwarning jump #Pipes:skipwarning
	if Pipes.threads|=|0 msg &eWarning: actions exceeded 50k ({actionCount}), using threads to complete...
	#Pipes:skipwarning
	setadd Pipes.threads 1
	if Pipes.threads|>=|{Pipes.conf.maxthreads} msg &cError: threads exceeded the maximum of {Pipes.conf.maxthreads} total, pipes cannot complete, aborting...
	if Pipes.threads|>=|{Pipes.conf.maxthreads} jump #Pipes:cleanup
	newthread {runArg1}
terminate

#Pipes:X+
// (no arguments)
	setadd Pipes.line{Pipes.index}.X 1
	set Pipes.line{Pipes.index}.dir X+
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:X-
// (no arguments)
	setsub Pipes.line{Pipes.index}.X 1
	set Pipes.line{Pipes.index}.dir X-
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Y+
// (no arguments)
	setadd Pipes.line{Pipes.index}.Y 1
	set Pipes.line{Pipes.index}.dir Y+
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Y-
// (no arguments)
	setsub Pipes.line{Pipes.index}.Y 1
	set Pipes.line{Pipes.index}.dir Y-
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Z+
// (no arguments)
	setadd Pipes.line{Pipes.index}.Z 1
	set Pipes.line{Pipes.index}.dir Z+
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:Z-
// (no arguments)
	setsub Pipes.line{Pipes.index}.Z 1
	set Pipes.line{Pipes.index}.dir Z-
	setblockid Pipes.line{Pipes.index}.id {Pipes.line{Pipes.index}.X} {Pipes.line{Pipes.index}.Y} {Pipes.line{Pipes.index}.Z}
	if Pipes.index|<|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:terminate
call #Pipes:cleanup
terminate

#Pipes:delay
// (no arguments)
	set Pipes.temp {id}
	setsub Pipes.temp {Pipes.id.delay}
	setadd Pipes.temp 1
	// set generic packages
	set X {Pipes.line{Pipes.index}.X}
	set Y {Pipes.line{Pipes.index}.Y}
	set Z {Pipes.line{Pipes.index}.Z}
	// cease the line
	set Pipes.line{Pipes.index}.ceased true
	// prevent the same delay from being queued twice in the same tick
	if Pipes.boxdelay{X},{Y},{Z} jump #Pipes:skipdelay
	set Pipes.boxdelay{X},{Y},{Z} true
	// set dir
	set dir {Pipes.line{Pipes.index}.dir}
	// schedule the delay for the runarg
	call #Pipes:schedulebox|{Pipes.temp}
	#Pipes:skipdelay
	if Pipes.index|<|Pipes.lines jump #Pipes:lineloop
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
	if Pipes.index|<|Pipes.lines jump #Pipes:lineloop
jump #Pipes:doalllines

#Pipes:softbox
// (no arguments)
	if Pipes.box{X},{Y},{Z} quit
	set Pipes.box{X},{Y},{Z} true
	setblockid id {X} {Y} {Z}
	//
	// check X+
	setadd X 1
	setblockid X+id {X} {Y} {Z}
	if dir|=|"X-" set X+id 0
	if X+id|=|{Pipes.id.pipe-WE} call #Pipes:pushline|{X}|{Y}|{Z}|X+
	// check X-
	setsub X 2
	setblockid X-id {X} {Y} {Z}
	if dir|=|"X+" set X-id 0
	if X-id|=|{Pipes.id.pipe-WE} call #Pipes:pushline|{X}|{Y}|{Z}|X-
	// reset X
	setadd X 1
	//
	// check Z+
	setadd Z 1
	setblockid Z+id {X} {Y} {Z}
	if dir|=|"Z-" set Z+id 0
	if Z+id|=|{Pipes.id.pipe-NS} call #Pipes:pushline|{X}|{Y}|{Z}|Z+
	// check Z-
	setsub Z 2
	setblockid Z-id {X} {Y} {Z}
	if dir|=|"Z+" set Z-id 0
	if Z-id|=|{Pipes.id.pipe-NS} call #Pipes:pushline|{X}|{Y}|{Z}|Z-
	// reset Z
	setadd Z 1
	//
	// check Y+
	setadd Y 1
	setblockid Y+id {X} {Y} {Z}
	if dir|=|"Y-" set Y+id 0
	if Y+id|=|{Pipes.id.pipe-UD} call #Pipes:pushline|{X}|{Y}|{Z}|Y+
	// check Y-
	setsub Y 2
	setblockid Y-id {X} {Y} {Z}
	if dir|=|"Y+" set Y-id 0
	if Y-id|=|{Pipes.id.pipe-UD} call #Pipes:pushline|{X}|{Y}|{Z}|Y-
	// reset Y
	setadd Y 1
	if label #Pipes:box[{id}] call #Pipes:box[{id}]
quit