include os/bravelycowering+

#runoffset
if id|=|766 setsub Y 1
quit

#gizmo
// LEDS
if id|=|765 placeblock 215 {X} {Y} {Z}
if id|=|215 placeblock 765 {X} {Y} {Z}
// Lamps
if id|=|764 placeblock 62 {X} {Y} {Z}
if id|=|62 placeblock 764 {X} {Y} {Z}
// Message Blocks
if id|=|36 cmd m {X} {Y} {Z}
// Signs
if id|=|171 cmd m {X} {Y} {Z}
quit