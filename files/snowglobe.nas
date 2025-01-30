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
	set gZ {maxZ}
	#Z-loop
		set gX {maxX}
		#X-loop
			set gY {maxY}
			#Y-loop
				set X {gX}
				set Y {gY}
				set Z {gZ}
				setblockid gid {X} {Y} {Z}
				if label #update[{gid}] call #update[{gid}]
				setsub gY 1
			if gY|>=|{minY} jump #Y-loop
			setsub gX 1
		if gX|>=|{minX} jump #X-loop
		setsub gZ 1
	if gZ|>=|{minZ} jump #Z-loop
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