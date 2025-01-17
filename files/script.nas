#hidegui
gui hotbar false
gui hand false
quit

#showgui
gui hotbar true
gui hand true
quit

#say
set speaker {runArg1}
set targetText {runArg2}
set text
msg &a{speaker}: &f{targetText}
setsplit targetText
set i 0
#sayLoop
set text {text}{targetText[{i}]}
set length {targetText.Length}
cpemsg smallannounce &a{speaker}: &f{text}
setadd i 1
delay 50
if i|<|length jump #sayLoop
delay 3000
cpemsg smallannounce
quit

#os2_setspawn
// setspawn 59 2 123 0 0
setdeathspawn 59 2 123 0 0
quit

#os2_setup
if setup quit
set setup true
boost 0 2 0 1 1 1 1000 0
msg &eWARNING!&c This map REQUIRES smooth lighting and fancy lighting mode to work properly.
// randomize the first set of pillars
setrandrange rand 1 2
if rand|=|1 call #os2_swappillar1
setrandrange rand 1 2
if rand|=|1 call #os2_swappillar2
setrandrange rand 1 2
if rand|=|1 call #os2_swappillar3
// randomize the maze
setrandrange rand 1 2
if rand|=|1 call #os2_swapmaze1
setrandrange rand 1 2
if rand|=|1 call #os2_swapmaze2
setrandrange rand 1 2
if rand|=|1 call #os2_swapmaze3
// randomize the second set of pillars
setrandrange rand 1 2
if rand|=|1 call #os2_swappillar4
setrandrange rand 1 2
if rand|=|1 call #os2_swappillar5
setrandrange rand 1 2
if rand|=|1 call #os2_swappillar6
setrandrange rand 1 2
if rand|=|1 call #os2_swappillar7
// randomize last pillar before harder mode
setrandrange rand 1 2
if rand|=|1 call #os2_swappillar8
quit

#os2_swappillar1
tempchunk 59 12 53 59 16 54 62 12 53
tempchunk 62 12 53 62 16 54 59 12 53
quit

#os2_swappillar2
tempchunk 59 12 51 59 16 52 62 12 51
tempchunk 62 12 51 62 16 52 59 12 51
quit

#os2_swappillar3
tempchunk 59 12 49 59 16 50 62 12 49
tempchunk 62 12 49 62 16 50 59 12 49
quit

#os2_swapmaze1
tempchunk 59 16 40 59 16 42 62 16 40
tempchunk 62 16 40 62 16 42 59 16 40
quit

#os2_swapmaze2
tempchunk 59 16 37 59 16 40 62 16 37
tempchunk 62 16 37 62 16 40 59 16 37
quit

#os2_swapmaze3
tempchunk 59 16 35 59 16 37 62 16 35
tempchunk 62 16 35 62 16 37 59 16 35
quit

#os2_swappillar4
tempchunk 59 12 30 59 16 30 62 12 30
tempchunk 62 12 30 62 16 30 59 12 30
quit

#os2_swappillar5
tempchunk 59 12 27 59 16 27 62 12 27
tempchunk 62 12 27 62 16 27 59 12 27
quit

#os2_swappillar6
tempchunk 53 12 27 53 16 27 56 12 27
tempchunk 56 12 27 56 16 27 53 12 27
quit

#os2_swappillar7
tempchunk 47 12 27 47 16 27 50 12 27
tempchunk 50 12 27 50 16 27 47 12 27
quit

#os2_swappillar8
tempchunk 47 12 20 47 16 20 50 12 20
tempchunk 50 12 20 50 16 20 47 12 20
quit

#os3_setup
if setup quit
set setup true
gui hotbar false
cmd hold 0 false
quit

#os3_givedevice
tempblock 0 {MBX} {MBY} {MBZ}
if device quit
set device true
set below false
cmd hold 755 false
definehotkey usedevice|Q
quit

#os3_usedevice
// tpp initial
ifnot device quit
if below cmd tpp ~ ~1024 ~
ifnot below cmd tpp ~ ~-1024 ~
// check if X
set X {PlayerX}
setsub X 1
setblockid block {X} {PlayerY} {PlayerZ}
if block|=|0 cmd tpp ~1 ~ ~
// check if Z
set Z {PlayerZ}
setsub Z 1
setblockid block {PlayerX} {PlayerY} {Z}
if block|=|0 cmd tpp ~ ~ ~1
// invert below
if below jump #os3_usedevice2
set below true
quit
#os3_usedevice2
set below false
quit

#input
if runArg1|=|"usedevice" jump #os3_usedevice
quit