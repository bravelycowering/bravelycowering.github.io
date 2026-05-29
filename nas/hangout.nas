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
#HEAVY[656]
#HEAVY[759]

#FALLS[141]
#FALLS[142]
#FALLS[143]
#FALLS[602]
#FALLS[603]

#UNSTABLE[9]
#UNSTABLE[11]
#UNSTABLE[461]

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
	set coins 0
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
	// set movement statistics
	set MOVESTAT[141] bench
	set MOVESTAT[142] crate
	set MOVESTAT[143] barrel
	set MOVESTAT[602] barrel
	set MOVESTAT[603] barrel
	// set movable transforms
	set TRANSFORM[143][AwayX] 602
	set TRANSFORM[143][TowardsX] 602
	set TRANSFORM[143][AwayZ] 603
	set TRANSFORM[143][TowardsZ] 603
	set TRANSFORM[602][AwayX] 143
	set TRANSFORM[602][TowardsX] 143
	set TRANSFORM[603][AwayZ] 143
	set TRANSFORM[603][TowardsZ] 143
	// set statistics
	set statistics.moved.barrel 0
	set statistics.moved.crate 0
	set statistics.moved.bench 0
	set statistics.chests 0
	set statistics.interact.door 0
	set statistics.interact.lantern 0
	set statistics.interact.computer 0
	// set help texts
	set HELP.ICON &r(&fi&r)&7
	set HELP.GENERIC.MOVE This type of block is movable. Right click to push, left click to pull.
	set HELP.BLOCK[141] {HELP.GENERIC.MOVE}
	set HELP.BLOCK[142] {HELP.GENERIC.MOVE}
	set HELP.BLOCK[143] {HELP.GENERIC.MOVE}
	set HELP.BLOCK[602] {HELP.GENERIC.MOVE}
	set HELP.BLOCK[603] {HELP.GENERIC.MOVE}
quit

#showStats
	if coins|=|1 set coinword coin
	else set coinword coins
	msg &uYou have &f{coins}&6 imaginary {coinword}&u.
	msg &uHere's some stats:
	msg &u  - Computers read:&a {statistics.interact.computer}
	msg &u  - Barrels rolled:&a {statistics.moved.barrel}
	msg &u  - Crates moved:&a {statistics.moved.crate}
	msg &u  - Benches misplaced:&a {statistics.moved.bench}
	msg &u  - Chests discovered:&a {statistics.chests}
	msg &u  - Doors knocked:&a {statistics.interact.door}
quit

#onClick
	setblockid clickedID {click.coords}
	if click.button|=|"Middle" jump #onMiddleClick
	if label #onClickBlock[{clickedID}] jump #onClickBlock[{clickedID}]
jump #on{click.button}Click

// chests
#onClickBlock[216]
#onClickBlock[217]
#onClickBlock[218]
#onClickBlock[219]
	if chest_{click.coordsX}_{click.coordsY}_{click.coordsZ} quit
	setadd statistics.chests 1
	set chest_{click.coordsX}_{click.coordsY}_{click.coordsZ} true
	tempblock 624 {click.coords}
	set coords {click.coords}
	setsplit coords " "
	setadd coords[1] 0.75
	effect coin {coords[0]} {coords[1]} {coords[2]} 0 -2 0
	setrandrange variant 2 13
	cs pos {click.coords} wood:choose({variant}):volume(2)
	msg You just found &f1 &6imaginary coin&7!
	setadd coins 1
quit

#onClickBlock[762]
	cs pos {click.coords} computercalculatefinish
	setadd statistics.interact.computer 1
	cmd msgme &fThe computer says:&u jokerdril
	jump #showStats
quit

#onClickBlock[656]
	placeblock 759 {click.coords}
	cs pos {click.coords} click:choose(3)
	setadd statistics.interact.lantern 1
quit

#onClickBlock[759]
	placeblock 656 {click.coords}
	cs pos {click.coords} click:choose(3):pitch(1.5)
	setadd statistics.interact.lantern 1
quit

#onClickBlock[755]
#onClickBlock[756]
#onClickBlock[757]
#onClickBlock[758]
	setsub clickedID 4
	placeblock {clickedID} {click.coords}
	cs pos {click.coords} click:choose(3)
quit

#onClickBlock[751]
#onClickBlock[752]
#onClickBlock[753]
#onClickBlock[754]
	setadd clickedID 4
	placeblock {clickedID} {click.coords}
	cs pos {click.coords} click:choose(3):pitch(1.5)
quit

#onClickBlock[55]
#onClickBlock[760]
#onClickBlock[761]
	cs pos {click.coords} knocking
	setadd statistics.interact.door 1
quit

#onLeftClick
	if label #MOVABLE[{clickedID}] jump #onMoveClick|PULL
quit

#onRightClick
	if label #MOVABLE[{clickedID}] jump #onMoveClick|PUSH
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
	cs pos {click.coords} wood stepleft:volume(2)
	ifnot potentialTransform|=|"" set myID {potentialTransform}
	ifnot moveby|=|"" jump #tryMoveBy|{myID}|{click.coords}|{moveby}
quit

#onMiddleClick
	if HELP.BLOCK[{clickedID}]|=|"" msg No help/tip is available for this block.
	else msg {HELP.ICON} {HELP.BLOCK[{clickedID}]}
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
	if label #UNSTABLE[{floorID}] quit
	placeblock {movetoID} {runArg2}
	placeblock {myID} {runArg3}
	ifnot MOVESTAT[{myID}]|=|"" setadd statistics.moved.{MOVESTAT[{myID}]} 1
quit
