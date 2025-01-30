include bravelycowering.net/files/tubes.nas

#runoffset
if type|=|766 setsub Y 1
quit

#gizmo
if id|=|764 placeblock 62 {X} {Y} {Z}
if id|=|62 placeblock 764 {X} {Y} {Z}
quit