using local_packages

#d[5]
#d[17]
#d[18]
#d[20]
#d[46]
#d[64]
#d[69]
#d[70]
#d[154]
#d[155]
#d[763]
#d[766]
#d[767]

#onJoin
	clickevent sync register #click
	set particle[5] explosionsteamsmall
	set particle[17] explosionsteamsmall
	set particle[18] leafgreenprecise
	set particle[20] sparkle
	set particle[46] explosionsmall
	set particle[64] explosionsteamsmall
	set particle[69] explosionsteamsmall
	set particle[70] explosionsteamsmall
	set particle[154] sparkle
	set particle[155] sparkle
	set particle[763] blood
	set particle[766] sparkle
	set particle[767] electric
quit

#getblock
	set {runArg1} {world[{runArg2},{runArg3},{runArg4}]}
	if {runArg1}|=|"" setblockid {runArg1} {runArg2} {runArg3} {runArg4}
quit

#setblock
	tempblock {runArg1} {runArg2} {runArg3} {runArg4}
	set world[{runArg2},{runArg3},{runArg4}] {runArg1}
quit

#resetlevel
	menumsg bigannounce &fResetting...
	menumsg smallannounce &fThis may take a bit, so there's a progress bar in the level.
	tempchunk 1 63 127 126 63 127 1 65 127
	tempchunk 0 0 0 127 127 127 0 0 0
	resetdata packages world[*]
	menumsg bigannounce
	menumsg smallannounce
quit

#click
	if label #click:{click.button}[{PlayerHeldBlock}] jump #click:{click.button}[{PlayerHeldBlock}]
	if label #click:{click.button} jump #click:{click.button}
quit

#click:Left
	set coords {click.coords}
	setsplit coords " "
	set x {coords[0]}
	set y {coords[1]}
	set z {coords[2]}
	call #getblock|id|{x}|{y}|{z}
	if id|=|46 effect fireprecise {x} {y} {z} 0 0 0
	if id|=|46 call #setblock|0|{x}|{y}|{z}
quit

#click:Right[46]
	// get place block coordinates
	set coords {click.coords}
	setsplit coords " "
	set x {coords[0]}
	set y {coords[1]}
	set z {coords[2]}
	call #getblock|id|{coords[0]}|{coords[1]}|{coords[2]}
	if id|=|46 jump #explode|{x}|{y}|{z}
	ifnot id|=|42 msg &cYou can only place TNT on &fIron&c!
	ifnot id|=|42 quit
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsZ" setsub z 1
	call #getblock|id|{x}|{y}|{z}
	if id|=|0 call #setblock|46|{x}|{y}|{z}
quit

#click:Right
	// get place block coordinates
	set coords {click.coords}
	setsplit coords " "
	set x {coords[0]}
	set y {coords[1]}
	set z {coords[2]}
	call #getblock|id|{coords[0]}|{coords[1]}|{coords[2]}
	if id|=|46 jump #explode|{x}|{y}|{z}
quit

#setatan2
// &angle, x, y
	if runArg2|=|0 jump #setatan2=0
	set {runArg1} {runArg3}
	setdiv {runArg1} {runArg2}
	setarctan {runArg1} {{runArg1}}
	if runArg2|<|0 jump #setatan2<0
quit
	#setatan2<0
	if runArg3|>=|0 setadd {runArg1} {PI}
	if runArg3|<|0 setsub {runArg1} {PI}
quit
	#setatan2=0
	if runArg3|>|0 setdegtorad {runArg1} 90
	if runArg3|<|0 setdegtorad {runArg1} -90
	// should technically be undefined, we are going to set it to 0 instead
	if runArg3|=|0 set {runArg1} 0
quit

#explode
	if exploding quit
	set exploding true
	// save the runargs
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	// find the distance between the middle of the tnt block and the middle of the player on all axes
	setsplit PlayerCoordsDecimal " "
	set dx {PlayerCoordsDecimal[0]}
	setsub dx {x}
	if x|=|PlayerX set dx 0
	set dy {PlayerCoordsDecimal[1]}
	setsub dy {y}
	setadd dy 0.5
	set dz {PlayerCoordsDecimal[2]}
	setsub dz {z}
	if z|=|PlayerZ set dz 0
	// calculate the distance
	set dx2 {dx}
	setpow dx2 2
	set dy2 {dy}
	setpow dy2 2
	set dz2 {dz}
	setpow dz2 2
	set distance {dx2}
	setadd distance {dy2}
	setadd distance {dz2}
	setsqrt distance {distance}
	// normalize the vector fuck you
	setdiv dx {distance}
	setdiv dy {distance}
	setdiv dz {distance}
	// calculate the velocity based on distance
	set velocity {distance}
	setmul velocity -1
	setadd velocity 5
	setmul velocity 2
	if distance|>|5 set velocity 0
	// set new dir vector
	setmul dx {velocity}
	setmul dy {velocity}
	setmul dz {velocity}
	// finally, do the explosion velocity
	boost {dx} {dy} {dz} 0 0 0
	call #setblock|0|{x}|{y}|{z}
	effect explosion {x} {y} {z} 0 0 0 false
	cs pos {x} {y} {z} explode:choose(12)
	// setup for loop (this whole loop is hardcoded)
		setadd x -3
		setadd y -3
		setadd z -3
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
		if label #d[{id}] call #setblock|0|{x}|{y}|{z}
	set exploding false
	msg actionCount: {actionCount}
quit