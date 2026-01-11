#onJoin
	clickevent sync register #click
quit

#explode
	placeblock 0 {runArg1} {runArg2} {runArg3}
	effect explosion {runArg1} {runArg2} {runArg3} 0 0 0
	setsplit PlayerCoordsDecimal " "
	set dx {PlayerCoordsDecimal[0]}
	setsub dx {runArg1}
	set dy {PlayerCoordsDecimal[1]}
	setsub dy {runArg2}
	set dz {PlayerCoordsDecimal[2]}
	setsub dz {runArg3}
	boost {dx} {dy} {dz} 1 1 1
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
	set {runArg1} {runArg3}
	setdiv {runArg1} {runArg2}
	setarctan {runArg1} {{runArg1}}
	if runArg2|<|0 jump #setatan2<0
	if runArg2|<|0 jump #setatan2=0
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