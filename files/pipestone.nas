using allow_include

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
	ifnot Pipes.inprogress jump #Pipes:doalllines
quit

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
	ifnot Pipes.inprogress jump #Pipes:doalllines
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
		setadd Pipes.index 1
		if Pipes.line{Pipes.index}.ceased jump #Pipes:skip
		set Pipes.validlines true
		// if pipes move in pipe direction
		if Pipes.line{Pipes.index}.id|=|550 jump #Pipes:{Pipes.line{Pipes.index}.dir}
		if Pipes.line{Pipes.index}.id|=|551 jump #Pipes:{Pipes.line{Pipes.index}.dir}
		if Pipes.line{Pipes.index}.id|=|552 jump #Pipes:{Pipes.line{Pipes.index}.dir}
		// if box then do box
		if Pipes.line{Pipes.index}.id|=|238 jump #Pipes:box
		// not a box or a pipe so set packages
		set X {Pipes.line{Pipes.index}.X}
		set Y {Pipes.line{Pipes.index}.Y}
		set Z {Pipes.line{Pipes.index}.Z}
		set dir {Pipes.line{Pipes.index}.dir}
		set id {Pipes.line{Pipes.index}.id}
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
	resetdata packages Pipes.*
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