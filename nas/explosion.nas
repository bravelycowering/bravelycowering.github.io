#onJoin
	clickevent sync register #click
quit

#explode
	effect explosion {MBX} {MBY} {MBZ} 0 0 0
	setsplit PlayerCoordsDecimal " "
	set dx {PlayerCoordsDecimal[0]}
	setsub dx {MBX}
	set dy {PlayerCoordsDecimal[1]}
	setsub dy {MBY}
	set dz {PlayerCoordsDecimal[2]}
	setsub dz {MBZ}
	boost {dx} {dy} {dz} 1 1 1
quit

#click
	if click.button|=|"Right" jump #dash
quit

#dash
	setdirvector vel.x vel.y vel.z {click.yaw} {click.pitch}
	setmul vel.x 5
	setmul vel.y 5
	setmul vel.z 5
	boost {vel.x} {vel.y} {vel.z} 0 1 0
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