#onJoin
	// hide the mb
	tempblock 0 127 127 127
	// give the option to boot
	replysilent 1|Boot|#setup
quit

#setup
	gui hotbar hide
	gui hand hide
	resetdata packages
	motd -hax +speed +fly +respawn
	reach 0
	freeze
	// set char dictionary
	cpemsg bigannounce Setting character dictionary...
	cpemsg announce This may take a while...
	call #chardict
	// set sprite dictionary
	cpemsg bigannounce Setting sprite dictionary...
	cpemsg announce This may take a while...
	call #sprites
	// create the standing platform
	tempblock 751 64 59 78
	// clear the colors, leave black to be the screen
	cpemsg bigannounce Tempchunking...
	cpemsg announce This may take a while...
	tempchunk 0 0 33 127 127 63 0 0 1
	// teleport to it
	cmd tp 64 60 78 0 0
	// hide the mb
	tempblock 0 127 127 127
	cpemsg bigannounce
	cpemsg announce
	cpemsg smallannounce &aDone!
	unfreeze
quit

#input
	if runArg1|=|"" quit
	if runArg2|=|"" set input {runArg1}
	else set input {runArg1} {runArg2}
quit

// screen drawing stuff

#sprites
	// row 1
	set sprite[A].X 0
	set sprite[A].Y 120
	set sprite[B].X 4
	set sprite[B].Y 120
	set sprite[C].X 8
	set sprite[C].Y 120
	set sprite[D].X 12
	set sprite[D].Y 120
	set sprite[E].X 16
	set sprite[E].Y 120
	set sprite[F].X 20
	set sprite[F].Y 120
	set sprite[G].X 24
	set sprite[G].Y 120
	set sprite[H].X 28
	set sprite[H].Y 120
	set sprite[I].X 32
	set sprite[I].Y 120
	set sprite[J].X 36
	set sprite[J].Y 120
	set sprite[K].X 40
	set sprite[K].Y 120
	set sprite[L].X 44
	set sprite[L].Y 120
	set sprite[M].X 48
	set sprite[M].Y 120
	set sprite[N].X 52
	set sprite[N].Y 120
	set sprite[O].X 56
	set sprite[O].Y 120
	set sprite[P].X 60
	set sprite[P].Y 120
	set sprite[Q].X 64
	set sprite[Q].Y 120
	set sprite[R].X 68
	set sprite[R].Y 120
	set sprite[S].X 72
	set sprite[S].Y 120
	set sprite[T].X 76
	set sprite[T].Y 120
	set sprite[U].X 80
	set sprite[U].Y 120
	set sprite[V].X 84
	set sprite[V].Y 120
	set sprite[W].X 88
	set sprite[W].Y 120
	set sprite[X].X 92
	set sprite[X].Y 120
	set sprite[Y].X 96
	set sprite[Y].Y 120
	set sprite[Z].X 100
	set sprite[Z].Y 120
	set sprite[0].X 104
	set sprite[0].Y 120
	set sprite[1].X 108
	set sprite[1].Y 120
	set sprite[2].X 112
	set sprite[2].Y 120
	set sprite[3].X 116
	set sprite[3].Y 120
	set sprite[4].X 120
	set sprite[4].Y 120
	set sprite[-].X 124
	set sprite[-].Y 120
	// row 2
	set sprite[a].X 0
	set sprite[a].Y 112
	set sprite[b].X 4
	set sprite[b].Y 112
	set sprite[c].X 8
	set sprite[c].Y 112
	set sprite[d].X 12
	set sprite[d].Y 112
	set sprite[e].X 16
	set sprite[e].Y 112
	set sprite[f].X 20
	set sprite[f].Y 112
	set sprite[g].X 24
	set sprite[g].Y 112
	set sprite[h].X 28
	set sprite[h].Y 112
	set sprite[i].X 32
	set sprite[i].Y 112
	set sprite[j].X 36
	set sprite[j].Y 112
	set sprite[k].X 40
	set sprite[k].Y 112
	set sprite[l].X 44
	set sprite[l].Y 112
	set sprite[m].X 48
	set sprite[m].Y 112
	set sprite[n].X 52
	set sprite[n].Y 112
	set sprite[o].X 56
	set sprite[o].Y 112
	set sprite[p].X 60
	set sprite[p].Y 112
	set sprite[q].X 64
	set sprite[q].Y 112
	set sprite[r].X 68
	set sprite[r].Y 112
	set sprite[s].X 72
	set sprite[s].Y 112
	set sprite[t].X 76
	set sprite[t].Y 112
	set sprite[u].X 80
	set sprite[u].Y 112
	set sprite[v].X 84
	set sprite[v].Y 112
	set sprite[w].X 88
	set sprite[w].Y 112
	set sprite[x].X 92
	set sprite[x].Y 112
	set sprite[y].X 96
	set sprite[y].Y 112
	set sprite[z].X 100
	set sprite[z].Y 112
	set sprite[5].X 104
	set sprite[5].Y 112
	set sprite[6].X 108
	set sprite[6].Y 112
	set sprite[7].X 112
	set sprite[7].Y 112
	set sprite[8].X 116
	set sprite[8].Y 112
	set sprite[9].X 120
	set sprite[9].Y 112
	set sprite[+].X 124
	set sprite[+].Y 112
	// row 3
	set sprite[.].X 0
	set sprite[.].Y 104
	set sprite[,].X 4
	set sprite[,].Y 104
	set sprite[:].X 8
	set sprite[:].Y 104
	set sprite[;].X 12
	set sprite[;].Y 104
	set sprite["].X 16
	set sprite["].Y 104
	set sprite['].X 20
	set sprite['].Y 104
	set sprite[_].X 24
	set sprite[_].Y 104
	set sprite[=].X 28
	set sprite[=].Y 104
	set sprite[|].X 32
	set sprite[|].Y 104
	set sprite[(].X 36
	set sprite[(].Y 104
	set sprite[)].X 40
	set sprite[)].Y 104
	set sprite[[].X 44
	set sprite[[].Y 104
	set sprite[]].X 48
	set sprite[]].Y 104
	set sprite[{].X 52
	set sprite[{].Y 104
	set sprite[}].X 56
	set sprite[}].Y 104
	set sprite[<].X 60
	set sprite[<].Y 104
	set sprite[>].X 64
	set sprite[>].Y 104
	set sprite[?].X 68
	set sprite[?].Y 104
	set sprite[!].X 72
	set sprite[!].Y 104
	set sprite[*].X 76
	set sprite[*].Y 104
	set sprite[`].X 80
	set sprite[`].Y 104
	set sprite[~].X 84
	set sprite[~].Y 104
	set sprite[@].X 88
	set sprite[@].Y 104
	set sprite[#].X 92
	set sprite[#].Y 104
	set sprite[$].X 96
	set sprite[$].Y 104
	set sprite[/].X 100
	set sprite[/].Y 104
	set sprite[\].X 104
	set sprite[\].Y 104
	set sprite[%].X 108
	set sprite[%].Y 104
	set sprite[^].X 112
	set sprite[^].Y 104
	set sprite[&].X 116
	set sprite[&].Y 104
	set sprite[►].X 120
	set sprite[►].Y 104
	set sprite[◄].X 124
	set sprite[◄].Y 104
quit

#fill
// X Y X2 Y2 color
	tempchunk {runArg1} {runArg2} {runArg5} {runArg3} {runArg4} {runArg5} {runArg1} {runArg2} 0
quit

#copychar
// sX sY X Y
	set sX2 {runArg1}
	set sY2 {runArg2}
	setadd sX2 3
	setadd sY2 7
	tempchunk {runArg1} {runArg2} 17 {sX2} {sY2} 17 {runArg3} {runArg4} 0 false false
quit

// mb loop stuff

#resume
jump {resume}

// binary stuff

#setchar
	set {runArg1} {ascii.char[{{runArg1}}]}
quit

#setbyte
	set {runArg1} {ascii.byte[{{runArg1}}]}
	if {runArg1}|=|"" set {runArg1} {}
quit

#chardict
	set space {} {}
	set ascii.byte[☺] 1
	set ascii.char[1] ☺
	set ascii.byte[☻] 2
	set ascii.char[2] ☻
	set ascii.byte[♥] 3
	set ascii.char[3] ♥
	set ascii.byte[♦] 4
	set ascii.char[4] ♦
	set ascii.byte[♣] 5
	set ascii.char[5] ♣
	set ascii.byte[♠] 6
	set ascii.char[6] ♠
	set ascii.byte[•] 7
	set ascii.char[7] •
	set ascii.byte[◘] 8
	set ascii.char[8] ◘
	set ascii.byte[○] 9
	set ascii.char[9] ○
	set ascii.byte[◙] 10
	set ascii.char[10] ◙
	set ascii.byte[♂] 11
	set ascii.char[11] ♂
	set ascii.byte[♀] 12
	set ascii.char[12] ♀
	set ascii.byte[♪] 13
	set ascii.char[13] ♪
	set ascii.byte[♫] 14
	set ascii.char[14] ♫
	set ascii.byte[☼] 15
	set ascii.char[15] ☼
	set ascii.byte[►] 16
	set ascii.char[16] ►
	set ascii.byte[◄] 17
	set ascii.char[17] ◄
	set ascii.byte[↕] 18
	set ascii.char[18] ↕
	set ascii.byte[‼] 19
	set ascii.char[19] ‼
	set ascii.byte[¶] 20
	set ascii.char[20] ¶
	set ascii.byte[§] 21
	set ascii.char[21] §
	set ascii.byte[▬] 22
	set ascii.char[22] ▬
	set ascii.byte[↨] 23
	set ascii.char[23] ↨
	set ascii.byte[↑] 24
	set ascii.char[24] ↑
	set ascii.byte[↓] 25
	set ascii.char[25] ↓
	set ascii.byte[→] 26
	set ascii.char[26] →
	set ascii.byte[←] 27
	set ascii.char[27] ←
	set ascii.byte[∟] 28
	set ascii.char[28] ∟
	set ascii.byte[↔] 29
	set ascii.char[29] ↔
	set ascii.byte[▲] 30
	set ascii.char[30] ▲
	set ascii.byte[▼] 31
	set ascii.char[31] ▼
	set ascii.char[32] {space}
	set ascii.byte[!] 33
	set ascii.char[33] !
	set ascii.byte["] 34
	set ascii.char[34] "
	set ascii.byte[#] 35
	set ascii.char[35] #
	set ascii.byte[$] 36
	set ascii.char[36] $
	set ascii.byte[%] 37
	set ascii.char[37] %
	set ascii.byte[&] 38
	set ascii.char[38] &
	set ascii.byte['] 39
	set ascii.char[39] '
	set ascii.byte[(] 40
	set ascii.char[40] (
	set ascii.byte[)] 41
	set ascii.char[41] )
	set ascii.byte[*] 42
	set ascii.char[42] *
	set ascii.byte[+] 43
	set ascii.char[43] +
	set ascii.byte[,] 44
	set ascii.char[44] ,
	set ascii.byte[-] 45
	set ascii.char[45] -
	set ascii.byte[.] 46
	set ascii.char[46] .
	set ascii.byte[/] 47
	set ascii.char[47] /
	set ascii.byte[0] 48
	set ascii.char[48] 0
	set ascii.byte[1] 49
	set ascii.char[49] 1
	set ascii.byte[2] 50
	set ascii.char[50] 2
	set ascii.byte[3] 51
	set ascii.char[51] 3
	set ascii.byte[4] 52
	set ascii.char[52] 4
	set ascii.byte[5] 53
	set ascii.char[53] 5
	set ascii.byte[6] 54
	set ascii.char[54] 6
	set ascii.byte[7] 55
	set ascii.char[55] 7
	set ascii.byte[8] 56
	set ascii.char[56] 8
	set ascii.byte[9] 57
	set ascii.char[57] 9
	set ascii.byte[:] 58
	set ascii.char[58] :
	set ascii.byte[;] 59
	set ascii.char[59] ;
	set ascii.byte[<] 60
	set ascii.char[60] <
	set ascii.byte[=] 61
	set ascii.char[61] =
	set ascii.byte[>] 62
	set ascii.char[62] >
	set ascii.byte[?] 63
	set ascii.char[63] ?
	set ascii.byte[@] 64
	set ascii.char[64] @
	set ascii.byte[A] 65
	set ascii.char[65] A
	set ascii.byte[B] 66
	set ascii.char[66] B
	set ascii.byte[C] 67
	set ascii.char[67] C
	set ascii.byte[D] 68
	set ascii.char[68] D
	set ascii.byte[E] 69
	set ascii.char[69] E
	set ascii.byte[F] 70
	set ascii.char[70] F
	set ascii.byte[G] 71
	set ascii.char[71] G
	set ascii.byte[H] 72
	set ascii.char[72] H
	set ascii.byte[I] 73
	set ascii.char[73] I
	set ascii.byte[J] 74
	set ascii.char[74] J
	set ascii.byte[K] 75
	set ascii.char[75] K
	set ascii.byte[L] 76
	set ascii.char[76] L
	set ascii.byte[M] 77
	set ascii.char[77] M
	set ascii.byte[N] 78
	set ascii.char[78] N
	set ascii.byte[O] 79
	set ascii.char[79] O
	set ascii.byte[P] 80
	set ascii.char[80] P
	set ascii.byte[Q] 81
	set ascii.char[81] Q
	set ascii.byte[R] 82
	set ascii.char[82] R
	set ascii.byte[S] 83
	set ascii.char[83] S
	set ascii.byte[T] 84
	set ascii.char[84] T
	set ascii.byte[U] 85
	set ascii.char[85] U
	set ascii.byte[V] 86
	set ascii.char[86] V
	set ascii.byte[W] 87
	set ascii.char[87] W
	set ascii.byte[X] 88
	set ascii.char[88] X
	set ascii.byte[Y] 89
	set ascii.char[89] Y
	set ascii.byte[Z] 90
	set ascii.char[90] Z
	set ascii.byte[[] 91
	set ascii.char[91] [
	set ascii.byte[\] 92
	set ascii.char[92] \
	set ascii.byte[]] 93
	set ascii.char[93] ]
	set ascii.byte[^] 94
	set ascii.char[94] ^
	set ascii.byte[_] 95
	set ascii.char[95] _
	set ascii.byte[`] 96
	set ascii.char[96] `
	set ascii.byte[a] 97
	set ascii.char[97] a
	set ascii.byte[b] 98
	set ascii.char[98] b
	set ascii.byte[c] 99
	set ascii.char[99] c
	set ascii.byte[d] 100
	set ascii.char[100] d
	set ascii.byte[e] 101
	set ascii.char[101] e
	set ascii.byte[f] 102
	set ascii.char[102] f
	set ascii.byte[g] 103
	set ascii.char[103] g
	set ascii.byte[h] 104
	set ascii.char[104] h
	set ascii.byte[i] 105
	set ascii.char[105] i
	set ascii.byte[j] 106
	set ascii.char[106] j
	set ascii.byte[k] 107
	set ascii.char[107] k
	set ascii.byte[l] 108
	set ascii.char[108] l
	set ascii.byte[m] 119
	set ascii.char[119] m
	set ascii.byte[n] 110
	set ascii.char[110] n
	set ascii.byte[o] 111
	set ascii.char[111] o
	set ascii.byte[p] 112
	set ascii.char[112] p
	set ascii.byte[q] 113
	set ascii.char[113] q
	set ascii.byte[r] 114
	set ascii.char[114] r
	set ascii.byte[s] 115
	set ascii.char[115] s
	set ascii.byte[t] 116
	set ascii.char[116] t
	set ascii.byte[u] 117
	set ascii.char[117] u
	set ascii.byte[v] 118
	set ascii.char[118] v
	set ascii.byte[w] 119
	set ascii.char[119] w
	set ascii.byte[x] 120
	set ascii.char[120] x
	set ascii.byte[y] 121
	set ascii.char[121] y
	set ascii.byte[z] 122
	set ascii.char[122] z
	set ascii.byte[{] 123
	set ascii.char[123] {
	set ascii.byte[|] 124
	set ascii.char[124] |
	set ascii.byte[}] 125
	set ascii.char[125] }
	set ascii.byte[~] 126
	set ascii.char[126] ~
	set ascii.byte[⌂] 127
	set ascii.char[127] ⌂
	set ascii.byte[Ç] 128
	set ascii.char[128] Ç
	set ascii.byte[ü] 129
	set ascii.char[129] ü
	set ascii.byte[é] 130
	set ascii.char[130] é
	set ascii.byte[â] 131
	set ascii.char[131] â
	set ascii.byte[ä] 132
	set ascii.char[132] ä
	set ascii.byte[à] 133
	set ascii.char[133] à
	set ascii.byte[å] 134
	set ascii.char[134] å
	set ascii.byte[ç] 135
	set ascii.char[135] ç
	set ascii.byte[ê] 136
	set ascii.char[136] ê
	set ascii.byte[ë] 137
	set ascii.char[137] ë
	set ascii.byte[è] 138
	set ascii.char[138] è
	set ascii.byte[ï] 139
	set ascii.char[139] ï
	set ascii.byte[î] 140
	set ascii.char[140] î
	set ascii.byte[ì] 141
	set ascii.char[141] ì
	set ascii.byte[Ä] 142
	set ascii.char[142] Ä
	set ascii.byte[Å] 143
	set ascii.char[143] Å
	set ascii.byte[É] 144
	set ascii.char[144] É
	set ascii.byte[æ] 145
	set ascii.char[145] æ
	set ascii.byte[Æ] 146
	set ascii.char[146] Æ
	set ascii.byte[ô] 147
	set ascii.char[147] ô
	set ascii.byte[ö] 148
	set ascii.char[148] ö
	set ascii.byte[ò] 149
	set ascii.char[149] ò
	set ascii.byte[û] 150
	set ascii.char[150] û
	set ascii.byte[ù] 151
	set ascii.char[151] ù
	set ascii.byte[ÿ] 152
	set ascii.char[152] ÿ
	set ascii.byte[Ö] 153
	set ascii.char[153] Ö
	set ascii.byte[Ü] 154
	set ascii.char[154] Ü
	set ascii.byte[¢] 155
	set ascii.char[155] ¢
	set ascii.byte[£] 156
	set ascii.char[156] £
	set ascii.byte[¥] 157
	set ascii.char[157] ¥
	set ascii.byte[₧] 158
	set ascii.char[158] ₧
	set ascii.byte[ƒ] 159
	set ascii.char[159] ƒ
	set ascii.byte[á] 160
	set ascii.char[160] á
	set ascii.byte[í] 161
	set ascii.char[161] í
	set ascii.byte[ó] 162
	set ascii.char[162] ó
	set ascii.byte[ú] 163
	set ascii.char[163] ú
	set ascii.byte[ñ] 164
	set ascii.char[164] ñ
	set ascii.byte[Ñ] 165
	set ascii.char[165] Ñ
	set ascii.byte[ª] 166
	set ascii.char[166] ª
	set ascii.byte[º] 167
	set ascii.char[167] º
	set ascii.byte[¿] 168
	set ascii.char[168] ¿
	set ascii.byte[⌐] 169
	set ascii.char[169] ⌐
	set ascii.byte[¬] 170
	set ascii.char[170] ¬
	set ascii.byte[½] 171
	set ascii.char[171] ½
	set ascii.byte[¼] 172
	set ascii.char[172] ¼
	set ascii.byte[¡] 173
	set ascii.char[173] ¡
	set ascii.byte[«] 174
	set ascii.char[174] «
	set ascii.byte[»] 175
	set ascii.char[175] »
	set ascii.byte[░] 176
	set ascii.char[176] ░
	set ascii.byte[▒] 177
	set ascii.char[177] ▒
	set ascii.byte[▓] 178
	set ascii.char[178] ▓
	set ascii.byte[│] 179
	set ascii.char[179] │
	set ascii.byte[┤] 180
	set ascii.char[180] ┤
	set ascii.byte[╡] 181
	set ascii.char[181] ╡
	set ascii.byte[╢] 182
	set ascii.char[182] ╢
	set ascii.byte[╖] 183
	set ascii.char[183] ╖
	set ascii.byte[╕] 184
	set ascii.char[184] ╕
	set ascii.byte[╣] 185
	set ascii.char[185] ╣
	set ascii.byte[║] 186
	set ascii.char[186] ║
	set ascii.byte[╗] 187
	set ascii.char[187] ╗
	set ascii.byte[╝] 188
	set ascii.char[188] ╝
	set ascii.byte[╜] 189
	set ascii.char[189] ╜
	set ascii.byte[╛] 190
	set ascii.char[190] ╛
	set ascii.byte[┐] 191
	set ascii.char[191] ┐
	set ascii.byte[└] 192
	set ascii.char[192] └
	set ascii.byte[┴] 193
	set ascii.char[193] ┴
	set ascii.byte[┬] 194
	set ascii.char[194] ┬
	set ascii.byte[├] 195
	set ascii.char[195] ├
	set ascii.byte[─] 196
	set ascii.char[196] ─
	set ascii.byte[┼] 197
	set ascii.char[197] ┼
	set ascii.byte[╞] 198
	set ascii.char[198] ╞
	set ascii.byte[╟] 199
	set ascii.char[199] ╟
	set ascii.byte[╚] 200
	set ascii.char[200] ╚
	set ascii.byte[╔] 201
	set ascii.char[201] ╔
	set ascii.byte[╩] 202
	set ascii.char[202] ╩
	set ascii.byte[╦] 203
	set ascii.char[203] ╦
	set ascii.byte[╠] 204
	set ascii.char[204] ╠
	set ascii.byte[═] 205
	set ascii.char[205] ═
	set ascii.byte[╬] 206
	set ascii.char[206] ╬
	set ascii.byte[╧] 207
	set ascii.char[207] ╧
	set ascii.byte[╨] 208
	set ascii.char[208] ╨
	set ascii.byte[╤] 209
	set ascii.char[209] ╤
	set ascii.byte[╥] 210
	set ascii.char[210] ╥
	set ascii.byte[╙] 211
	set ascii.char[211] ╙
	set ascii.byte[╘] 212
	set ascii.char[212] ╘
	set ascii.byte[╒] 213
	set ascii.char[213] ╒
	set ascii.byte[╓] 214
	set ascii.char[214] ╓
	set ascii.byte[╫] 215
	set ascii.char[215] ╫
	set ascii.byte[╪] 216
	set ascii.char[216] ╪
	set ascii.byte[┘] 217
	set ascii.char[217] ┘
	set ascii.byte[┌] 218
	set ascii.char[218] ┌
	set ascii.byte[█] 219
	set ascii.char[219] █
	set ascii.byte[▄] 220
	set ascii.char[220] ▄
	set ascii.byte[▌] 221
	set ascii.char[221] ▌
	set ascii.byte[▐] 222
	set ascii.char[222] ▐
	set ascii.byte[▀] 223
	set ascii.char[223] ▀
	set ascii.byte[α] 224
	set ascii.char[224] α
	set ascii.byte[ß] 225
	set ascii.char[225] ß
	set ascii.byte[Γ] 226
	set ascii.char[226] Γ
	set ascii.byte[π] 227
	set ascii.char[227] π
	set ascii.byte[Σ] 228
	set ascii.char[228] Σ
	set ascii.byte[σ] 229
	set ascii.char[229] σ
	set ascii.byte[µ] 230
	set ascii.char[230] µ
	set ascii.byte[τ] 231
	set ascii.char[231] τ
	set ascii.byte[Φ] 232
	set ascii.char[232] Φ
	set ascii.byte[Θ] 233
	set ascii.char[233] Θ
	set ascii.byte[Ω] 234
	set ascii.char[234] Ω
	set ascii.byte[δ] 235
	set ascii.char[235] δ
	set ascii.byte[∞] 236
	set ascii.char[236] ∞
	set ascii.byte[φ] 237
	set ascii.char[237] φ
	set ascii.byte[ε] 238
	set ascii.char[238] ε
	set ascii.byte[∩] 239
	set ascii.char[239] ∩
	set ascii.byte[≡] 240
	set ascii.char[240] ≡
	set ascii.byte[±] 241
	set ascii.char[241] ±
	set ascii.byte[≥] 242
	set ascii.char[242] ≥
	set ascii.byte[≤] 243
	set ascii.char[243] ≤
	set ascii.byte[⌠] 244
	set ascii.char[244] ⌠
	set ascii.byte[⌡] 245
	set ascii.char[245] ⌡
	set ascii.byte[÷] 246
	set ascii.char[246] ÷
	set ascii.byte[≈] 247
	set ascii.char[247] ≈
	set ascii.byte[°] 248
	set ascii.char[248] °
	set ascii.byte[∙] 249
	set ascii.char[249] ∙
	set ascii.byte[·] 250
	set ascii.char[250] ·
	set ascii.byte[√] 251
	set ascii.char[251] √
	set ascii.byte[ⁿ] 252
	set ascii.char[252] ⁿ
	set ascii.byte[²] 253
	set ascii.char[253] ²
	set ascii.byte[■] 254
	set ascii.char[254] ■
	set ascii.byte[ ] 255
	set ascii.char[255]  
quit