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
	set moveby {runArg1}[{click.face}]
	ifnot moveby|=|"" jump #tryMoveBy|{click.coords}|{{moveby}}
quit

#onMiddleClick

quit

#tryMoveBy
	set moveto {runArg1}
	set moveby {runArg2}
	setsplit moveto " "
	setsplit moveby " "
	setadd moveto[0] {moveby[0]}
	setadd moveto[1] {moveby[1]}
	setadd moveto[2] {moveby[2]}
jump #tryMove|{runArg1}|{moveto[0]} {moveto[1]} {moveto[2]}

#tryMove
	setblockid myID {runArg1}
	setblockid movetoID {runArg2}
	ifnot label #SWAPPABLE[{movetoID}] quit
	placeblock {movetoID} {runArg1}
	placeblock {myID} {runArg2}
quit
