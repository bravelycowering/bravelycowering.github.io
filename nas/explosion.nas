#explode
	effect explosion {MBX} {MBY} {MBZ} 0 0 0
	setsplit PlayerCoordsDecimal " "
	set dx {MBX}
	setsub dx {PlayerCoordsDecimal[0]}
	set dy {MBY}
	setsub dy {PlayerCoordsDecimal[1]}
	set dz {MBZ}
	setsub dz {PlayerCoordsDecimal[2]}
	boost {dx} {dy} {dz} 1 1 1
quit