#onJoin
	// box dimensions
	set minX 24
	set minY 32
	set minZ 24
	set maxX 39
	set maxY 47
	set maxZ 39
quit

#update
	// loop through literally every block
	set gZ {minZ}
	#Z-loop
		set gX {minX}
		#X-loop
			set gY {minY}
			#Y-loop
				setblockid gid {gX} {gY} {gZ}
				ifnot label #update[{gid}] placeblock 0 {gX} {gY} {gZ}
				if label #update[{gid}] call #updateblock
				setadd gY 1
			if gY|<=|{maxY} jump #Y-loop
			setadd gX 1
		if gX|<=|{maxX} jump #X-loop
		setadd gZ 1
	if gZ|<=|{maxZ} jump #Z-loop
	msg &aCompleted in {actionCount} actions!
quit

#failsafe
	newthread #Y-loop
terminate

#changeblock
	placeblock 0 {gX} {gY} {gZ}
	placeblock {gid} {X} {Y} {Z}
quit

#updateblock
	set X {gX}
	set Y {gY}
	set Z {gZ}
	jump #update[{gid}]
quit

// snow
#update[140]
	setsub Y 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #changeblock
	setadd X 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #changeblock
	setsub X 2
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #changeblock
	setadd X 1
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #changeblock
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #changeblock
quit

// stone
#update[1]
	setsub Y 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #changeblock
quit

// water
#update[9]
	setrandrange DX -1 1
	setrandrange DZ -1 1
	setsub Y 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #changeblock
	if id|=|9 setadd Y 1
	setadd X {DX}
	setadd Z {DZ}
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #changeblock
quit