using local_packages

#MOVABLE[141]
#MOVABLE[142]
#MOVABLE[143]
#MOVABLE[602]
#MOVABLE[603]

#SWAPPABLE[0]

#HEAVY[216]
#HEAVY[217]
#HEAVY[218]
#HEAVY[219]

#FALLS[141]
#FALLS[142]
#FALLS[143]
#FALLS[602]
#FALLS[603]

// #Set:add({set}, value)
#Set:add
	set l_check @!::{runArg2}
	if {runArg1}|has|l_check quit
	set {runArg1} {{runArg1}}{l_check}
quit

// #Set:sethas({result}, {set}, value)
#Set:sethas
	set l_check @!::{runArg3}
	if {runArg2}|has|l_check set {runArg1} true
	else set {runArg1} false
quit

#onJoin
	clickevent sync register #onClick
	// set push constants
	set PUSH[AwayX] -1 0 0
	set PUSH[TowardsX] 1 0 0
	set PUSH[AwayZ] 0 0 -1
	set PUSH[TowardsZ] 0 0 1
	// set pull constants
	set PULL[AwayX] 1 0 0
	set PULL[TowardsX] -1 0 0
	set PULL[AwayZ] 0 0 1
	set PULL[TowardsZ] 0 0 -1
	// set direction faces
	set DIRFACE[0] AwayZ
	set DIRFACE[1] TowardsX
	set DIRFACE[2] TowardsZ
	set DIRFACE[3] AwayX
	// set movable transforms
	set TRANSFORM[143][AwayX] 602
	set TRANSFORM[143][TowardsX] 602
	set TRANSFORM[143][AwayZ] 603
	set TRANSFORM[143][TowardsZ] 603
	set TRANSFORM[602][AwayX] 143
	set TRANSFORM[602][TowardsX] 143
	set TRANSFORM[603][AwayZ] 143
	set TRANSFORM[603][TowardsZ] 143
quit

#onClick
	setblockid clickedID {click.coords}
	if label #onClickBlock[{clickedID}] jump #onClickBlock[{clickedID}]
jump #on{click.button}Click

// chests
#onClickBlock[216]
#onClickBlock[217]
#onClickBlock[218]
#onClickBlock[219]
	tempblock 624 {click.coords}
	set coords {click.coords}
	setsplit coords " "
	setadd coords[1] 1
	effect coin {coords[0]} {coords[1]} {coords[2]} 0 1 0
quit

#onLeftClick
	if label #MOVABLE[{clickedID}] jump #onMoveClick|PUSH
quit

#onRightClick
	if label #MOVABLE[{clickedID}] jump #onMoveClick|PULL
quit

#onMoveClick
	set face {click.face}
	ifnot face|=|"AwayY" jump #ifnot_face_is_AwayY__end
		set dir {PlayerYaw}
		setdiv dir 90
		setround dir
		setmod dir 4
		set face {DIRFACE[{dir}]}
	#ifnot_face_is_AwayY__end
	set moveby {{runArg1}[{face}]}
	setblockid myID {click.coords}
	set potentialTransform {TRANSFORM[{myID}][{face}]}
	cs me wood stepleft
	ifnot potentialTransform|=|"" set myID {potentialTransform}
	ifnot moveby|=|"" jump #tryMoveBy|{myID}|{click.coords}|{moveby}
quit

#onMiddleClick

quit

#tryMoveBy
	set moveto {runArg2}
	set moveby {runArg3}
	setsplit moveto " "
	setsplit moveby " "
	setadd moveto[0] {moveby[0]}
	setadd moveto[1] {moveby[1]}
	setadd moveto[2] {moveby[2]}
jump #tryMove|{runArg1}|{runArg2}|{moveto[0]} {moveto[1]} {moveto[2]}

#tryMove
	set myID {runArg1}
	set coords {runArg2}
	setsplit coords " "
	setadd coords[1] 1
	setblockid above {coords[0]} {coords[1]} {coords[2]}
	if label #HEAVY[{above}] quit
	if label #FALLS[{above}] quit
	setblockid movetoID {runArg3}
	ifnot label #SWAPPABLE[{movetoID}] quit
	set floorcoords {runArg3}
	setsplit floorcoords " "
	setsub floorcoords[1] 1
	setblockid floorID {floorcoords[0]} {floorcoords[1]} {floorcoords[2]}
	if label #SWAPPABLE[{floorID}] quit
	placeblock {movetoID} {runArg2}
	placeblock {myID} {runArg3}
quit
