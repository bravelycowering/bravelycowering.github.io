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
				set X {gX}
				set Y {gY}
				set Z {gZ}
				setblockid gid {X} {Y} {Z}
				ifnot label #update[{gid}] placeblock 0 {X} {Y} {Z}
				if label #update[{gid}] call #update[{gid}]
				setadd gY 1
			if gY|<=|{maxY} jump #Y-loop
			setadd gX 1
		if gX|<=|{maxX} jump #X-loop
		setadd gZ 1
	if gZ|<=|{maxZ} jump #Z-loop
quit

#changeblock
	placeblock 0 {gX} {gY} {gZ}
	placeblock {gid} {X} {Y} {Z}
quit

// snow
#update[140]
	setsub Y 1
	setblockid id {X} {Y} {Z}
	if id|=|0 jump #changeblock
quit