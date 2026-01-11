#onJoin
	clickevent sync register #click
quit

#explode
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	placeblock 0 {x} {y} {z}
	effect explosion {x} {y} {z} 0 0 0 true
	setsplit PlayerCoordsDecimal " "
	// adjust tnt explotion coords
	setadd x 0.5
	setsub y 0.5
	setadd z 0.5
	// find the distance between the middle of the tnt block and the middle of the player on all axes
	set dx {PlayerCoordsDecimal[0]}
	setsub dx {x}
	set dy {PlayerCoordsDecimal[1]}
	setsub dy {y}
	set dz {PlayerCoordsDecimal[2]}
	setsub dz {z}
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
	// calculate the pitch
	set pitch 0
	setsub pitch {dy}
	setarcsin pitch {pitch}
	setradtodeg pitch {pitch}
	call #setatan2|yaw|{dx}|{dz}
	setradtodeg yaw {yaw}
	// calculate the velocity based on distance
	set velocity {distance}
	setdiv velocity 5
	setmul velocity -1
	setadd velocity 1
	setpow velocity 2
	setmul velocity 8
	if distance|>|5 set velocity 0
	// set new dir vector
	setdirvector vel.x vel.y vel.z {yaw} {pitch}
	setmul vel.x {velocity}
	setmul vel.y {velocity}
	setmul vel.z {velocity}
	// finally, do the explosion
	boost {vel.x} {vel.y} {vel.z} 0 0 0
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
	setblockid id {x} {y} {z}
	if id|=|46 jump #explode|{x}|{y}|{z}
quit

#click:Right[46]
	// get place block coordinates
	set coords {click.coords}
	setsplit coords " "
	set x {coords[0]}
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"TowardsX" setsub x 1
	set y {coords[1]}
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"TowardsY" setsub y 1
	set z {coords[2]}
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsZ" setsub z 1
	setblockid id {x} {y} {z}
	if id|=|0 placeblock 46 {x} {y} {z}
quit

#click:Right
	setdirvector vel.x vel.y vel.z {click.yaw} {click.pitch}
	setmul vel.x 5
	setmul vel.y 5
	setmul vel.z 5
	set vel.ymode 1
	if vel.y|<|0 set vel.ymode 0
	boost {vel.x} {vel.y} {vel.z} 0 {vel.ymode} 0
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