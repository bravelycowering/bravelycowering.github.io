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
	jump #click:Right
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
	ifnot hastnt cmd holdsilent 46
	ifnot hastnt set hastnt true
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
	setrandlist explodesound 3|12|13|14|22|23|24
	cs pos {x} {y} {z} explode:choose({explodesound})
	// setup for loop (this whole loop is hardcoded)
		setadd x -3
		setadd y -3
		setadd z -3
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot label #d[{id}] jump #exp0
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp0
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp1
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp1
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp2
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp2
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp3
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp3
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp4
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp4
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp5
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp5
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot label #d[{id}] jump #exp6
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp6
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp7
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp7
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp8
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp8
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp9
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp9
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp10
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp10
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp11
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp11
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp12
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp12
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp13
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp13
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp14
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp14
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp15
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp15
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp16
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp16
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp17
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp17
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp18
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp18
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp19
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp19
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp20
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp20
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp21
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp21
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp22
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp22
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp23
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp23
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp24
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp24
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp25
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp25
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp26
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp26
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp27
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp27
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp28
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp28
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp29
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp29
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp30
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp30
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp31
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp31
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp32
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp32
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp33
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp33
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp34
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp34
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp35
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp35
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp36
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp36
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp37
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp37
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp38
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp38
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp39
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp39
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp40
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp40
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp41
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp41
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot label #d[{id}] jump #exp42
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp42
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp43
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp43
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp44
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp44
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp45
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp45
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp46
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp46
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp47
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp47
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot label #d[{id}] jump #exp48
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp48
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp49
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp49
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp50
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp50
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp51
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp51
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp52
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp52
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp53
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp53
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp54
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp54
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp55
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp55
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp56
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp56
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp57
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp57
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp58
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp58
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp59
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp59
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp60
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp60
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp61
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp61
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp62
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp62
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp63
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp63
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp64
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp64
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp65
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp65
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp66
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp66
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp67
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp67
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp68
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp68
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp69
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp69
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp70
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp70
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp71
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp71
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp72
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp72
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp73
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp73
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp74
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp74
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp75
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp75
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp76
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp76
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp77
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp77
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp78
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp78
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp79
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp79
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp80
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp80
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp81
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp81
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp82
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp82
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp83
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp83
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp84
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp84
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp85
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp85
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp86
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp86
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp87
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp87
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp88
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp88
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp89
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp89
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp90
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp90
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp91
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp91
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp92
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp92
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp93
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp93
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp94
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp94
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp95
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp95
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp96
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp96
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp97
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp97
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp98
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp98
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp99
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp99
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp100
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp100
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp101
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp101
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp102
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp102
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp103
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp103
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp104
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp104
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp105
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp105
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp106
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp106
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp107
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp107
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp108
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp108
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp109
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp109
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp110
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp110
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp111
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp111
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp112
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp112
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp113
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp113
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp114
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp114
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp115
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp115
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp116
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp116
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp117
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp117
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp118
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp118
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp119
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp119
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp120
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp120
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp121
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp121
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp122
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp122
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp123
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp123
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp124
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp124
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp125
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp125
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp126
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp126
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp127
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp127
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp128
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp128
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp129
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp129
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp130
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp130
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp131
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp131
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp132
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp132
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp133
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp133
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp134
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp134
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp135
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp135
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp136
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp136
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp137
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp137
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp138
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp138
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp139
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp139
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp140
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp140
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp141
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp141
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp142
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp142
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp143
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp143
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp144
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp144
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp145
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp145
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp146
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp146
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp147
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp147
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp148
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp148
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp149
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp149
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp150
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp150
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp151
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp151
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp152
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp152
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp153
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp153
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp154
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp154
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp155
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp155
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp156
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp156
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp157
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp157
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp158
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp158
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp159
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp159
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp160
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp160
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp161
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp161
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp162
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp162
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp163
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp163
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp164
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp164
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp165
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp165
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp166
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp166
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp167
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp167
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp168
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp168
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp169
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp169
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp170
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp170
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp171
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp171
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp172
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp172
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp173
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp173
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp174
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp174
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp175
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp175
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp176
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp176
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp177
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp177
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp178
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp178
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp179
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp179
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp180
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp180
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp181
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp181
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp182
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp182
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp183
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp183
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp184
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp184
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp185
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp185
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp186
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp186
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp187
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp187
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp188
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp188
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp189
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp189
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp190
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp190
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp191
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp191
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp192
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp192
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp193
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp193
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp194
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp194
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp195
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp195
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp196
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp196
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp197
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp197
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp198
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp198
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp199
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp199
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp200
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp200
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp201
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp201
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp202
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp202
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp203
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp203
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp204
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp204
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp205
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp205
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp206
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp206
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp207
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp207
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp208
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp208
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp209
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp209
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp210
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp210
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp211
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp211
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp212
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp212
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp213
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp213
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp214
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp214
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp215
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp215
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp216
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp216
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp217
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp217
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp218
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp218
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp219
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp219
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp220
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp220
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp221
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp221
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp222
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp222
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp223
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp223
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp224
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp224
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp225
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp225
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp226
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp226
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp227
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp227
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp228
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp228
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp229
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp229
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp230
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp230
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp231
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp231
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp232
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp232
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp233
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp233
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp234
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp234
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp235
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp235
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp236
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp236
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp237
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp237
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp238
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp238
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp239
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp239
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp240
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp240
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp241
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp241
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp242
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp242
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp243
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp243
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp244
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp244
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp245
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp245
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp246
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp246
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp247
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp247
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp248
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp248
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp249
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp249
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp250
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp250
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp251
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp251
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp252
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp252
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp253
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp253
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp254
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp254
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp255
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp255
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp256
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp256
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp257
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp257
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp258
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp258
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp259
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp259
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp260
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp260
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp261
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp261
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp262
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp262
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp263
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp263
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp264
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp264
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp265
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp265
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp266
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp266
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp267
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp267
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp268
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp268
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp269
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp269
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp270
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp270
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp271
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp271
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp272
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp272
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp273
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp273
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp274
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp274
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp275
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp275
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp276
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp276
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp277
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp277
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp278
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp278
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp279
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp279
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp280
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp280
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp281
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp281
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp282
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp282
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp283
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp283
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp284
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp284
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		ifnot label #d[{id}] jump #exp285
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp285
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp286
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp286
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp287
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp287
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp288
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp288
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp289
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp289
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp290
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp290
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp291
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp291
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp292
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp292
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp293
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp293
		setadd x 1
		setadd y -6
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot label #d[{id}] jump #exp294
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp294
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp295
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp295
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp296
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp296
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp297
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp297
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp298
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp298
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp299
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp299
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot label #d[{id}] jump #exp300
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp300
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp301
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp301
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp302
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp302
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp303
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp303
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp304
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp304
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp305
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp305
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp306
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp306
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp307
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp307
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp308
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp308
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp309
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp309
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp310
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp310
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp311
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp311
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp312
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp312
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp313
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp313
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp314
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp314
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp315
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp315
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp316
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp316
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp317
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp317
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp318
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp318
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp319
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp319
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp320
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp320
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp321
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp321
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp322
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp322
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp323
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp323
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp324
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp324
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp325
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp325
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp326
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp326
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp327
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp327
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp328
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp328
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp329
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp329
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp330
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp330
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp331
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp331
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp332
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp332
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp333
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp333
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7
		ifnot label #d[{id}] jump #exp334
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp334
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp335
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp335
		setadd y 1
		setadd z -6
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot label #d[{id}] jump #exp336
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp336
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp337
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp337
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp338
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp338
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp339
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp339
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp340
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp340
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7
		ifnot label #d[{id}] jump #exp341
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp341
		setadd z 1
		set id {world[{x},{y},{z}]}
		if id|=|"" setblockid id {x} {y} {z}
		setrandlist id {id}|7|7|7
		ifnot label #d[{id}] jump #exp342
			ifnot particle[{id}]|=|"" effect {particle[{id}]} {x} {y} {z} 0 0 0
			tempblock 0 {x} {y} {z}
			set world[{x},{y},{z}] 0
		#exp342
	set exploding false
	msg actionCount: {actionCount}
quit