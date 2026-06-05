using local_packages
using quit_resets_runargs
using no_runarg_underscore_conversion
using allow_include
using cef

// everything here will be annotated with the method of calling it, for example:
// call #Namespace:funcname|arg1|{arg2}|{arg3}
// arguments in {braces} require a direct value to be passed, otherwise a package name is expected

////////////////////////////////////////////////////////////////
//                        Uniqe Sets                          //
////////////////////////////////////////////////////////////////

// call #Set:add|set|{value}
#Set:add
	set l_check @!::{runArg2}
	if {runArg1}|has|l_check quit
	set {runArg1} {{runArg1}}{l_check}
quit

// call #Set:remove|set|{value}
#Set:remove
	set l_check @!::{runArg2}
	ifnot {runArg1}|has|l_check quit
	set l_set {{runArg1}}
	setsplit l_set {l_check}
	set {runArg1} {l_set[0]}{l_set[1]}
quit

// call #Set:sethas|return|set|{value}
#Set:sethas
	set l_check @!::{runArg3}
	if {runArg2}|has|l_check set {runArg1} true
	else set {runArg1} false
quit

////////////////////////////////////////////////////////////////
//                      Struct Packing                        //
////////////////////////////////////////////////////////////////

// call #Struct:pack|struct|{format}
#Struct:pack
	set l_format {runArg2}
	setsplit l_format ;
	set {runArg1}
	set l_i 0
	#Struct:pack.loop
		set {runArg1} {{runArg1}}{l_format[{l_i}]}:={{l_format[{l_i}]}};
		setadd l_i 1
	if l_i|<|l_format.Length jump #Struct:pack.loop
quit

// call #Struct:unpack|struct
#Struct:unpack
	set l_struct {{runArg1}}
	setsplit l_struct ;
	set l_i 0
	#Struct:unpack.loop
		setsplit l_struct[{l_i}] :=
		set {l_struct[{l_i}][0]} {l_struct[{l_i}][1]}
		setadd l_i 1
	if l_i|<|l_format.Length jump #Struct:unpack.loop
quit

////////////////////////////////////////////////////////////////
//                       Items System                         //
////////////////////////////////////////////////////////////////

// call #Item:setup
#Item:setup
	set Item:items
	set Item:toName[q] Q
	set Item:toName[w] W
	set Item:toName[e] E
	set Item:toName[r] R
	set Item:toName[t] T
	set Item:toName[y] Y
	set Item:toName[u] U
	set Item:toName[i] I
	set Item:toName[o] O
	set Item:toName[p] P
	set Item:toName[a] A
	set Item:toName[s] S
	set Item:toName[d] D
	set Item:toName[f] F
	set Item:toName[g] G
	set Item:toName[h] H
	set Item:toName[j] J
	set Item:toName[k] K
	set Item:toName[l] L
	set Item:toName[z] Z
	set Item:toName[x] X
	set Item:toName[c] C
	set Item:toName[v] V
	set Item:toName[b] B
	set Item:toName[n] N
	set Item:toName[m] M
quit

// call #Item:give|{ID}
#Item:give
	set l_item @!::{runArg1}
	if Item:items|has|l_item msg &7You already found: &a{runArg1}&7!
	else msg &7You found an item: &a{runArg1}&7!
	ifnot Item:itemsCmdTip|=|"" msg &7Check what items you have with &a{Item:itemsCmdTip}&7.
	if Item:items|has|l_item quit
	set Item:items {Item:items}{l_item}
quit

#Item:items
	msg &efucking ill make it look nice later idc rn
	msg {Item:items}
quit