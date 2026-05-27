#MOVABLE[143]
#MOVABLE[602]
#MOVABLE[603]

#SWAPPABLE[0]

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
jump #on{click.button}Click

#onLeftClick
	if label #MOVABLE[{clickedID}] jump #onMoveClick|PUSH
quit

#onRightClick
	if label #MOVABLE[{clickedID}] jump #onMoveClick|PULL
quit

#onMoveClick
	set moveby {{runArg1}[{click.face}]}
	setblockid myID {click.coords}
	set potentialTransform {TRANSFORM[{myID}][{click.face}]}
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
	setblockid movetoID {runArg3}
	ifnot label #SWAPPABLE[{movetoID}] quit
	placeblock {movetoID} {runArg2}
	placeblock {myID} {runArg3}
quit
