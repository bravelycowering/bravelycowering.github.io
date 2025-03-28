#hidegui
gui hotbar false
gui hand false
quit

#showgui
gui hotbar true
gui hand true
quit

#type
set speaker {runArg1}
set targetText {runArg2}
set text
msg &a{speaker}: &f{targetText}
setsplit targetText
set i 0
#sayLoop
set text {text}{targetText[{i}]}
set length {targetText.Length}
cpemsg smallannounce {text}
setadd i 1
delay 50
if i|<|length jump #sayLoop
quit

#say
call #type|{runArg1}|{runArg2}
delay 3000
cpemsg smallannounce
quit

#os3_setup
if setup quit
reach 4
set setup true
gui hotbar false
cmd hold 0 false
quit

#os3_givedevice
if device quit
tempblock 0 {MBX} {MBY} {MBZ}
msg &aYou got the Strange Device!
msg &fPress &aQ&f or &aE&f to use the Strange Device.
set device true
set below false
cmd hold 755 false
definehotkey usedevice|Q
definehotkey usedevice|E
quit

#os3_usedevice
ifnot device quit
call #os3_useteleport
quit

#os3_walldevice
set PX {MBX}
set PY {MBY}
set PZ {MBZ}
effect electric {PX} {PY} {PZ} 0 0 0 true
if below setadd PY 32
ifnot below setsub PY 32
effect electric {PX} {PY} {PZ} 0 0 0 false
call #os3_useteleport
quit

#os3_useteleport
// player coords
set PX {PlayerX}
set PY {PlayerY}
set PZ {PlayerZ}
// tp
if below cmd reltp 0 32 0
ifnot below cmd reltp 0 -32 0
// effect
effect electric {PX} {PY} {PZ} 0 0 0 true
if below setadd PY 32
ifnot below setsub PY 32
effect electric {PX} {PY} {PZ} 0 0 0 true
// invert below
if below jump #os3_useteleport2
set below true
quit
#os3_useteleport2
set below false
quit

#os3_opendoor
set X {runArg1}
set Y {runArg2}
set Z {runArg3}
setsub Z 1
tempblock 0 {X} {Y} {Z}
setadd Z 1
tempblock 0 {X} {Y} {Z}
setadd Z 1
tempblock 0 {X} {Y} {Z}
setsub Z 2
setadd Y 1
delay 200
tempblock 0 {X} {Y} {Z}
setadd Z 1
tempblock 0 {X} {Y} {Z}
setadd Z 1
tempblock 0 {X} {Y} {Z}
setsub Z 2
setadd Y 1
delay 200
tempblock 0 {X} {Y} {Z}
setadd Z 1
tempblock 0 {X} {Y} {Z}
setadd Z 1
tempblock 0 {X} {Y} {Z}
setsub Z 2
quit

#os3_closedoor
set X {runArg1}
set Y {runArg2}
set Z {runArg3}
setsub Z 1
setadd Y 2
tempblock 767 {X} {Y} {Z}
setadd Z 1
tempblock 767 {X} {Y} {Z}
setadd Z 1
tempblock 767 {X} {Y} {Z}
setsub Z 2
setsub Y 1
delay 200
tempblock 767 {X} {Y} {Z}
setadd Z 1
tempblock 767 {X} {Y} {Z}
setadd Z 1
tempblock 767 {X} {Y} {Z}
setsub Z 2
setsub Y 1
delay 200
tempblock 767 {X} {Y} {Z}
setadd Z 1
tempblock 767 {X} {Y} {Z}
setadd Z 1
tempblock 767 {X} {Y} {Z}
setsub Z 2
quit

#os3_carver
if carver jump #os3_carver2
msg &fCarver: &aEnabled
set carver true
clickevent sync register #os3_click
quit
#os3_carver2
msg &fCarver: &cDisabled
set carver false
clickevent sync unregister
quit

#os3_click
if click.button|=|"Left" call #os3_carve
if click.button|=|"Right" call #os3_paint
quit

#os3_carve
set coords {click.coords}
setsplit coords " "
if below setadd coords[1] 32
placeblock 0 {coords[0]} {coords[1]} {coords[2]}
setsub coords[1] 32
placeblock 0 {coords[0]} {coords[1]} {coords[2]}
quit

#os3_paint
set coords {click.coords}
setsplit coords " "
if below setadd coords[1] 32
placeblock 238 {coords[0]} {coords[1]} {coords[2]}
setsub coords[1] 32
placeblock 42 {coords[0]} {coords[1]} {coords[2]}
quit

#os3_c1
if c1 quit
call #os3_closedoor|67|38|64
call #say|Speaker|explains the plot
call #say|Speaker|wants me dead wants me to rot
call #os3_opendoor|75|38|64
call #say|Speaker|First, to make sure you are in good physical condition...
call #say|Speaker|Please complete the following parkour to move to the next room.
set c1 true
quit

#os3_c2
if c2 quit
call #type|Speaker|Great job!
delay 1250
call #say|Speaker|These messages are prerecorded, so I cannot actually see you.
call #say|Speaker|If you did not do a great job, please ignore my last statement.
call #os3_opendoor|92|40|64
call #say|Speaker|Please walk to the next room.
set c2 true
quit

#os3_c3
if c3 quit
call #say|Speaker|something something time travel is possible
call #say|Speaker|Yup, that's right. It's now possible to skip ahead in time.
call #os3_opendoor|112|45|64
set c3 true
call #say|Speaker|In front of you, you should see a computer terminal.
call #say|Speaker|Go ahead and punch it to time travel.
call #say|Speaker|Yup, just punch it full force. We made sure it could take it.
quit

#os4_setup
if setup quit
set times 0
set setup true
call #hidegui
freeze
call #say|&[ave|Hello!_Welcome_to_my_map.
call #say|&[ave|A_lot_of_people_have_complained_recently...
call #say|&[ave|that_the_maps_that_I_make_are_too_hard...
call #say|&[ave|Well,_that_changes_today!
unfreeze
call #say|&[ave|All_you_have_to_do_is_walk_forward.
quit

#os4_starthallway
call #say|&[ave|And_now,_you_see_that_room_at_the_end?
call #say|&[ave|Walk_all_the_way_over_there.
quit

#os4_endhallway
call #type|&[ave|And_that's_it!_You_win!
delay 500
cpemsg bigannounce &aYOU WIN!
delay 2000
call #say|&[ave|I knew you had it in you.
quit

#input
if runArg1|=|"usedevice" jump #os3_usedevice
quit