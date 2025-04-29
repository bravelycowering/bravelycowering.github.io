#click
	set coords {click.coords}
	msg {click.coords}
	setsplit coords " "
	if click.button|=|"Left" jump #mine|{coords[0]}|{coords[1]}|{coords[2]}
	if click.button|=|"Right" jump #place|{coords[0]}|{coords[1]}|{coords[2]}
	if click.button|=|"Middle" jump #pick|{coords[0]}|{coords[1]}|{coords[2]}
quit

#mine
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	tempblock 0 {x} {y} {z}
quit

#place
	set x {runArg1}
	set y {runArg2}
	set z {runArg3}
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"TowardsZ" setsub z 1
	tempblock 1 {x} {y} {z}
quit

#pick
	call #getblock|{runArg1}|{runArg2}|{runArg3}
	cmd hold {id}
quit

#getblock
	set id {block_{runArg1}_{runArg2}_{runArg3}}
	if id|=|"" setblockid id {runArg1} {runArg2} {runArg3}
quit

#onJoin
	clickevent sync register #click
quit