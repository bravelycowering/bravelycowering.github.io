#explode
	effect explosion {MBX} {MBY} {MBZ} 0 0 0
	setsplit PlayerCoordsDecimal " "
	set dx {PlayerCoordsDecimal[0]}
	setsub dx {MBX}
	set dy {PlayerCoordsDecimal[1]}
	setsub dy {MBY}
	set dz {PlayerCoordsDecimal[2]}
	setsub dz {MBZ}
	boost {dx} {dy} {dz} 0 0 0
quit