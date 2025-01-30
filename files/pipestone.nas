using allow_include

// runs the pipestone at the message block
#Pipes.messageblock
// (message block) (no arguments)
	allowmbrepeat
	set line 0
	set X {MBX}
	set Y {MBY}
	set Z {MBZ}
	set dir ?
	setblockid id {MBCoords}
	// prerun
	if label #Pipes.prerun call #Pipes.prerun
	// adds the lines
	call #softbox
	ifnot inprogress jump #doalllines
quit

// keep in mind, lines are 1-indexed
#pushline
// X, Y, Z, Direction
	ifnot line{lines}.ceased setadd lines 1
	set line{lines}.X {runArg1}
	set line{lines}.Y {runArg2}
	set line{lines}.Z {runArg3}
	setblockid line{lines}.id {runArg1} {runArg2} {runArg3}
	set line{lines}.dir {runArg4}
	set line{lines}.ceased false
quit

#doalllines
// (no arguments)
	set inprogress true
	set line 0
	set validlines false
	#lineloop
	// (no arguments)
		setadd line 1
		if line{line}.ceased jump #skip
		set validlines true
		// if pipes move in pipe direction
		if line{line}.id|=|550 jump #pipe:{line{line}.dir}
		if line{line}.id|=|551 jump #pipe:{line{line}.dir}
		if line{line}.id|=|552 jump #pipe:{line{line}.dir}
		// if box then do box
		if line{line}.id|=|238 jump #box
		// not a box or a pipe so set packages
		set X {line{line}.X}
		set Y {line{line}.Y}
		set Z {line{line}.Z}
		set dir {line{line}.dir}
		set id {line{line}.id}
		// cease line
		set line{line}.ceased true
		// and call gizmo if its not been called yet
		if temp:gizmo{X},{Y},{Z} jump #skip
		set temp:gizmo{X},{Y},{Z} true
		if label #Pipes.gizmo call #Pipes.gizmo
		#skip
		if line|<=|lines jump #lineloop
	if validlines jump #doalllines
	resetdata packages
quit

#pipe:X+
// (no arguments)
	setadd line{line}.X 1
	set line{line}.dir X+
	setblockid line{line}.id {line{line}.X} {line{line}.Y} {line{line}.Z}
	if line|<=|lines jump #lineloop
jump #doalllines

#pipe:X-
// (no arguments)
	setsub line{line}.X 1
	set line{line}.dir X-
	setblockid line{line}.id {line{line}.X} {line{line}.Y} {line{line}.Z}
	if line|<=|lines jump #lineloop
jump #doalllines

#pipe:Y+
// (no arguments)
	setadd line{line}.Y 1
	set line{line}.dir Y+
	setblockid line{line}.id {line{line}.X} {line{line}.Y} {line{line}.Z}
	if line|<=|lines jump #lineloop
jump #doalllines

#pipe:Y-
// (no arguments)
	setsub line{line}.Y 1
	set line{line}.dir Y-
	setblockid line{line}.id {line{line}.X} {line{line}.Y} {line{line}.Z}
	if line|<=|lines jump #lineloop
jump #doalllines

#pipe:Z+
// (no arguments)
	setadd line{line}.Z 1
	set line{line}.dir Z+
	setblockid line{line}.id {line{line}.X} {line{line}.Y} {line{line}.Z}
	if line|<=|lines jump #lineloop
jump #doalllines

#pipe:Z-
// (no arguments)
	setsub line{line}.Z 1
	set line{line}.dir Z-
	setblockid line{line}.id {line{line}.X} {line{line}.Y} {line{line}.Z}
	if line|<=|lines jump #lineloop
jump #doalllines

#box
// (no arguments)
	// set generic packages
	set X {line{line}.X}
	set Y {line{line}.Y}
	set Z {line{line}.Z}
	set dir {line{line}.dir}
	set id {line{line}.id}
	// cease the line
	set line{line}.ceased true
	jump #softbox
quit

#softbox
// (no arguments)
	if temp:box{X},{Y},{Z} quit
	set temp:box{X},{Y},{Z} true
	//
	// check X+
	setadd X 1
	setblockid id {X} {Y} {Z}
	if dir|=|"X-" set id 0
	if id|=|551 call #pushline|{X}|{Y}|{Z}|X+
	// check X-
	setsub X 2
	setblockid id {X} {Y} {Z}
	if dir|=|"X+" set id 0
	if id|=|551 call #pushline|{X}|{Y}|{Z}|X-
	// reset X
	setadd X 1
	//
	// check Z+
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if dir|=|"Z-" set id 0
	if id|=|552 call #pushline|{X}|{Y}|{Z}|Z+
	// check Z-
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if dir|=|"Z+" set id 0
	if id|=|552 call #pushline|{X}|{Y}|{Z}|Z-
	// reset Z
	setadd Z 1
	//
	// check Y+
	setadd Y 1
	setblockid id {X} {Y} {Z}
	if dir|=|"Y-" set id 0
	if id|=|550 call #pushline|{X}|{Y}|{Z}|Y+
	// check Y-
	setsub Y 2
	setblockid id {X} {Y} {Z}
	if dir|=|"Y+" set id 0
	if id|=|550 call #pushline|{X}|{Y}|{Z}|Y-
	// reset Y
	setadd Y 1
	if line|<=|lines jump #lineloop
jump #doalllines