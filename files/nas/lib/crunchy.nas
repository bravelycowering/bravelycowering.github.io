using allow_include

#Crunchy
	ifnot Crunchy.config|=|"" quit
	set Crunchy.config {runArg1}
	setsplit Crunchy.config ,
	set i 0
	#Crunchy:_setuploop
		setsplit Crunchy.config[{i}] =
		set Crunchy.blocks[{Crunchy.config[{i}][0]}] {Crunchy.config[{i}][1]}
		setadd i 1
	ifnot Crunchy.config[{i}]|=|"" jump #Crunchy:_setuploop
#Crunchy:_reloop
	cmd oss #Crunchy:_loop repeatable
terminate

#Crunchy:_loop
	setblockid Crunchy.ID {PlayerCoords}
	ifnot Crunchy.blocks[{Crunchy.ID}]|=|"" tempblock {Crunchy.blocks[{Crunchy.ID}]} {PlayerCoords} true
	delay 100
	if actionCount|>=|50000 jump #Crunchy:_reloop
jump #Crunchy:_loop