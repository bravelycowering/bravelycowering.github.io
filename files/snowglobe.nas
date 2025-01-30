#onJoin
	// box dimensions
	set minX 24
	set minY 32
	set minZ 24
	set maxX 39
	set maxY 47
	set maxZ 39
quit

// crush saplings
#crush:6

// swap snow with water
#swap[140]:9
// swap snow with air
#swap[140]:0

// swap stone with water
#swap[1]:9
// swap stone with air
#swap[1]:0

// swap water with lava
#swap[9]:11
// swap water with air
#swap[9]:0

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
	if label #crush:{id} set id 0
	placeblock {id} {gX} {gY} {gZ}
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
	if label #swap[{gid}]:{id} jump #changeblock
	setadd X 1
	setblockid id {X} {Y} {Z}
	if label #swap[{gid}]:{id} jump #changeblock
	setsub X 2
	setblockid id {X} {Y} {Z}
	if label #swap[{gid}]:{id} jump #changeblock
	setadd X 1
	setadd Z 1
	setblockid id {X} {Y} {Z}
	if label #swap[{gid}]:{id} jump #changeblock
	setsub Z 2
	setblockid id {X} {Y} {Z}
	if label #swap[{gid}]:{id} jump #changeblock
quit

// stone
#update[1]
	setsub Y 1
	setblockid id {X} {Y} {Z}
	if label #swap[{gid}]:{id} #changeblock
quit

// water
#update[9]
	set myid {gid}
	setrandrange DX -1 1
	setrandrange DZ -1 1
	setsub Y 1
	setblockid id {X} {Y} {Z}
	if id|=|11 set gid 1
	if label #swap[{myid}]:{id} jump #changeblock
	if id|=|9 setadd Y 1
	setadd X {DX}
	setadd Z {DZ}
	setblockid id {X} {Y} {Z}
	if id|=|11 set gid 1
	if label #swap[{myid}]:{id} jump #changeblock
quit