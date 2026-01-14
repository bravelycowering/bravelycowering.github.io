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
#d[159]
#d[763]
#d[765]
#d[766]
#d[767]

#p[42]
#p[744]
#p[745]
#p[746]
#p[747]
#p[748]
#p[749]
#p[750]
#p[751]

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
	set particle[159] explosionsteamsmall
	set particle[763] blood
	set particle[765]
	set particle[766] sparkle
	set particle[767] electric
quit

#hax
	cmd maphack {runArg1}
	ifnot runArg1|=|"off" motd jumpheight=2.2 horspeed=2 -push model=humanoid
	else motd -hax +thirdperson jumpheight=2.2 horspeed=2 -push model=humanoid
	set runArg1
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

	// get place block coordinates
	set coords {click.coords}
	setsplit coords " "
	set x {coords[0]}
	set y {coords[1]}
	set z {coords[2]}
	call #getblock|id|{coords[0]}|{coords[1]}|{coords[2]}
	if id|=|46 jump #explode|{x}|{y}|{z}
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
	ifnot label #p[{id}] cpemsg smallannounce &cYou can only place TNT on &fIron&c!
	ifnot label #p[{id}] quit
	if click.face|=|"AwayX" setadd x 1
	if click.face|=|"TowardsX" setsub x 1
	if click.face|=|"AwayY" setadd y 1
	if click.face|=|"TowardsY" setsub y 1
	if click.face|=|"AwayZ" setadd z 1
	if click.face|=|"TowardsZ" setsub z 1
	call #getblock|id|{x}|{y}|{z}
	if id|=|0 call #setblock|46|{x}|{y}|{z}
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
	set l_x {runArg1}
	set l_y {runArg2}
	set l_z {runArg3}
	// find the distance between the middle of the tnt block and the middle of the player on all axes
	setsplit PlayerCoordsDecimal " "
	set l_dx {PlayerCoordsDecimal[0]}
	set l_dy {PlayerCoordsDecimal[1]}
	set l_dz {PlayerCoordsDecimal[2]}
	setsub l_dx {l_x}
	if l_x|=|PlayerX set l_dx 0
	setsub l_dy {l_y}
	setadd l_dy 0.5
	setsub l_dz {l_z}
	if l_z|=|PlayerZ set l_dz 0
	// calculate the distance
	set l_dx2 {l_dx}
	setpow l_dx2 2
	set l_dy2 {l_dy}
	setpow l_dy2 2
	set l_dz2 {l_dz}
	setpow l_dz2 2
	set l_distance {l_dx2}
	setadd l_distance {l_dy2}
	setadd l_distance {l_dz2}
	setsqrt l_distance {l_distance}
	// normalize the vector fuck you
	setdiv l_dx {l_distance}
	setdiv l_dy {l_distance}
	setdiv l_dz {l_distance}
	// calculate the velocity based on distance
	set l_velocity {l_distance}
	setmul l_velocity -1
	setadd l_velocity 5
	setmul l_velocity 2
	if l_distance|>|5 set l_velocity 0
	// set new dir vector
	setmul l_dx {l_velocity}
	setmul l_dy {l_velocity}
	setmul l_dz {l_velocity}
	// finally, do the explosion velocity
	boost {l_dx} {l_dy} {l_dz} 0 0 0
	effect explosion {l_x} {l_y} {l_z} 0 0 0 false
	setrandlist l_explodesound 3|12|13|14|22|23|24
	cs pos {l_x} {l_y} {l_z} explode:choose({l_explodesound})
	// inlined call to #setblock
	tempblock 0 {l_x} {l_y} {l_z}
	set world[{l_x},{l_y},{l_z}] 0
	// setup for loop (this whole loop is hardcoded)
		setadd l_x -3
		setadd l_y -3
		setadd l_z -3
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7|7
		ifnot label #d[{l_id}] jump #exp0
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp0
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp1
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp1
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp2
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp2
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp3
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp3
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp4
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp4
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp5
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp5
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7|7
		ifnot label #d[{l_id}] jump #exp6
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp6
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp7
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp7
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp8
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp8
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp9
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp9
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp10
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp10
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp11
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp11
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp12
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp12
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp13
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp13
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp14
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp14
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp15
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp15
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp16
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp16
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp17
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp17
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp18
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp18
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp19
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp19
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp20
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp20
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp21
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp21
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp22
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp22
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp23
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp23
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp24
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp24
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp25
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp25
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp26
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp26
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp27
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp27
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp28
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp28
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp29
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp29
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp30
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp30
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp31
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp31
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp32
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp32
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp33
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp33
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp34
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp34
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp35
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp35
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp36
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp36
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp37
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp37
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp38
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp38
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp39
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp39
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp40
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp40
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp41
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp41
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7|7
		ifnot label #d[{l_id}] jump #exp42
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp42
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp43
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp43
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp44
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp44
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp45
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp45
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp46
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp46
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp47
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp47
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7|7
		ifnot label #d[{l_id}] jump #exp48
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp48
		setadd l_x 1
		setadd l_y -6
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp49
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp49
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp50
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp50
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp51
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp51
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp52
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp52
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp53
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp53
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp54
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp54
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp55
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp55
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp56
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp56
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp57
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp57
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp58
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp58
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp59
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp59
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp60
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp60
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp61
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp61
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp62
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp62
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp63
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp63
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp64
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp64
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp65
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp65
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp66
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp66
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp67
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp67
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp68
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp68
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp69
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp69
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp70
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp70
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp71
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp71
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp72
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp72
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp73
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp73
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp74
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp74
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp75
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp75
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp76
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp76
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp77
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp77
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp78
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp78
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp79
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp79
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp80
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp80
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp81
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp81
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp82
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp82
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp83
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp83
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp84
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp84
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp85
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp85
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp86
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp86
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp87
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp87
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp88
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp88
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp89
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp89
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp90
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp90
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp91
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp91
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp92
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp92
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp93
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp93
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp94
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp94
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp95
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp95
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp96
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp96
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp97
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp97
		setadd l_x 1
		setadd l_y -6
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp98
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp98
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp99
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp99
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp100
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp100
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp101
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp101
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp102
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp102
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp103
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp103
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp104
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp104
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp105
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp105
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp106
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp106
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp107
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp107
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp108
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp108
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp109
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp109
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp110
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp110
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp111
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp111
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp112
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp112
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp113
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp113
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp114
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp114
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp115
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp115
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp116
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp116
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp117
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp117
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp118
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp118
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp119
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp119
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp120
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp120
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp121
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp121
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp122
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp122
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp123
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp123
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp124
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp124
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp125
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp125
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp126
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp126
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp127
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp127
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp128
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp128
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp129
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp129
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp130
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp130
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp131
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp131
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp132
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp132
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp133
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp133
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp134
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp134
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp135
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp135
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp136
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp136
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp137
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp137
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp138
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp138
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp139
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp139
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp140
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp140
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp141
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp141
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp142
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp142
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp143
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp143
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp144
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp144
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp145
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp145
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp146
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp146
		setadd l_x 1
		setadd l_y -6
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp147
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp147
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp148
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp148
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp149
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp149
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp150
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp150
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp151
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp151
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp152
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp152
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp153
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp153
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp154
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp154
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp155
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp155
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp156
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp156
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp157
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp157
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp158
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp158
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp159
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp159
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp160
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp160
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp161
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp161
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp162
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp162
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp163
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp163
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp164
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp164
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp165
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp165
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp166
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp166
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp167
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp167
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp168
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp168
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp169
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp169
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp170
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp170
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp171
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp171
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp172
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp172
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp173
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp173
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp174
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp174
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp175
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp175
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp176
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp176
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp177
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp177
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp178
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp178
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp179
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp179
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp180
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp180
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp181
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp181
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp182
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp182
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp183
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp183
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp184
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp184
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp185
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp185
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp186
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp186
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp187
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp187
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp188
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp188
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp189
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp189
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp190
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp190
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp191
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp191
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp192
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp192
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp193
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp193
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp194
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp194
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp195
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp195
		setadd l_x 1
		setadd l_y -6
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp196
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp196
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp197
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp197
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp198
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp198
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp199
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp199
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp200
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp200
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp201
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp201
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp202
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp202
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp203
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp203
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp204
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp204
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp205
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp205
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp206
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp206
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp207
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp207
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp208
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp208
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp209
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp209
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp210
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp210
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp211
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp211
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp212
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp212
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp213
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp213
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp214
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp214
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp215
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp215
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp216
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp216
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp217
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp217
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp218
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp218
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp219
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp219
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp220
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp220
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp221
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp221
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp222
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp222
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp223
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp223
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp224
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp224
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp225
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp225
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp226
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp226
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp227
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp227
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp228
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp228
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp229
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp229
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp230
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp230
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp231
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp231
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp232
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp232
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp233
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp233
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp234
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp234
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp235
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp235
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp236
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp236
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp237
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp237
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp238
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp238
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp239
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp239
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp240
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp240
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp241
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp241
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp242
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp242
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp243
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp243
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp244
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp244
		setadd l_x 1
		setadd l_y -6
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp245
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp245
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp246
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp246
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp247
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp247
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp248
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp248
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp249
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp249
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp250
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp250
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp251
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp251
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp252
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp252
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp253
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp253
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp254
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp254
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp255
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp255
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp256
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp256
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp257
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp257
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp258
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp258
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp259
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp259
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp260
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp260
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp261
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp261
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp262
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp262
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp263
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp263
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp264
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp264
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp265
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp265
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp266
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp266
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp267
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp267
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp268
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp268
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp269
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp269
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp270
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp270
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp271
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp271
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp272
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp272
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp273
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp273
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp274
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp274
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp275
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp275
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp276
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp276
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp277
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp277
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp278
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp278
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp279
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp279
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp280
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp280
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp281
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp281
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp282
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp282
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp283
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp283
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp284
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp284
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		ifnot label #d[{l_id}] jump #exp285
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp285
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp286
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp286
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp287
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp287
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp288
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp288
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp289
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp289
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp290
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp290
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp291
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp291
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp292
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp292
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp293
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp293
		setadd l_x 1
		setadd l_y -6
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7|7
		ifnot label #d[{l_id}] jump #exp294
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp294
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp295
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp295
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp296
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp296
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp297
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp297
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp298
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp298
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp299
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp299
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7|7
		ifnot label #d[{l_id}] jump #exp300
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp300
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp301
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp301
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp302
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp302
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp303
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp303
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp304
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp304
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp305
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp305
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp306
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp306
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp307
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp307
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp308
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp308
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp309
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp309
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp310
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp310
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp311
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp311
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp312
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp312
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp313
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp313
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp314
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp314
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp315
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp315
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp316
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp316
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp317
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp317
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp318
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp318
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp319
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp319
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp320
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp320
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp321
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp321
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp322
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp322
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp323
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp323
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp324
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp324
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp325
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp325
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp326
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp326
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp327
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp327
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp328
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp328
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp329
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp329
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp330
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp330
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp331
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp331
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp332
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp332
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp333
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp333
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7
		ifnot label #d[{l_id}] jump #exp334
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp334
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp335
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp335
		setadd l_y 1
		setadd l_z -6
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7|7
		ifnot label #d[{l_id}] jump #exp336
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp336
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp337
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp337
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp338
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp338
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp339
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp339
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp340
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp340
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7
		ifnot label #d[{l_id}] jump #exp341
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp341
		setadd l_z 1
		set l_id {world[{l_x},{l_y},{l_z}]}
		if l_id|=|"" setblockid l_id {l_x} {l_y} {l_z}
		setrandlist l_id {l_id}|7|7|7
		ifnot label #d[{l_id}] jump #exp342
			ifnot particle[{l_id}]|=|"" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0
			tempblock 0 {l_x} {l_y} {l_z}
			set world[{l_x},{l_y},{l_z}] 0
		#exp342
	set exploding false
quit