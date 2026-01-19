#Binary:goto
	// X|Y|Z|axis
	set Binary.X {runArg1}
	set Binary.Y {runArg2}
	set Binary.Z {runArg3}
	set Binary.dir {runArg4}
quit

// #Binary:read|package
// #Binary:write|value

#Binary:readchar
	setblockid {runArg1} {Bianry.X} {Bianry.Y} {Bianry.Z}
	call #Binary:byte->char|{runArg1}
	setadd {Binary.dir} 1
quit

#Binary:writechar
	set Binary.temp {runArg1}
	call #Binary:char->byte|Binary.temp
	placeblock {runArg1} {Bianry.X} {Bianry.Y} {Bianry.Z}
	setadd {Binary.dir} 1
quit

#Binary:readbyte
	setblockid {runArg1} {Bianry.X} {Bianry.Y} {Bianry.Z}
	setmod {runArg1} 256
	setadd {Binary.dir} 1
quit

#Binary:readsignedbyte
	setblockid {runArg1} {Bianry.X} {Bianry.Y} {Bianry.Z}
	setmod {runArg1} 256
	setadd {Binary.dir} 1
	if {runArg1}|>|127 setsub {runArg1} 256
quit

#Binary:writebyte
	setmod runArg1 256
	placeblock {runArg1} {Bianry.X} {Bianry.Y} {Bianry.Z}
	setadd {Binary.dir} 1
quit

#Binary:readshort
	setblockid {runArg1} {Bianry.X} {Bianry.Y} {Bianry.Z}
	setmod {runArg1} 256
	setadd {Binary.dir} 1
	setblockid Binary.temp {Bianry.X} {Bianry.Y} {Bianry.Z}
	setmod Binary.temp 256
	setmul {runArg1} 256
	setadd {runArg1} {Binary.temp}
	setadd {Binary.dir} 1
quit

#Binary:readsignedshort
	setblockid {runArg1} {Bianry.X} {Bianry.Y} {Bianry.Z}
	setmod {runArg1} 256
	setadd {Binary.dir} 1
	setblockid Binary.temp {Bianry.X} {Bianry.Y} {Bianry.Z}
	setmod Binary.temp 256
	setmul {runArg1} 256
	setadd {runArg1} {Binary.temp}
	setadd {Binary.dir} 1
	if {runArg1}|>|32767 setsub {runArg1} 65536
quit

#Binary:writeshort
	set Binary.temp {runArg1}
	setmod Binary.temp 256
	placeblock {Binary.temp} {Bianry.X} {Bianry.Y} {Bianry.Z}
	setadd {Binary.dir} 1
	setdiv runArg1 256
	setrounddown runArg1
	set Binary.temp {runArg1}
	setmod Binary.temp 256
	placeblock {Binary.temp} {Bianry.X} {Bianry.Y} {Bianry.Z}
	setadd {Binary.dir} 1
quit

#Binary:byte->char
	set {runArg1} {Binary.char[{{runArg1}}]}
	if {runArg1}|="" error Invalid byte
quit

#Binary:char->byte
	set {runArg1} {Binary.byte[{{runArg1}}]}
	if Binary.byte[{{runArg1}}]|=|" " set {runArg1} {Binary.space}
	if {runArg1}|="" error Invalid char
quit

#Binary:setup
	// sets up the char and byte dictionaries as well as the space and default vars. 514 actions
	set Binary.X 0
	set Binary.Y 0
	set Binary.Z 0
	set Binary.dir X
	set Binary.empty
	set Binary.space {Binary.empty} {Binary.empty}
	set Binary.byte[☺] 1
	set Binary.char[1] ☺
	set Binary.byte[☻] 2
	set Binary.char[2] ☻
	set Binary.byte[♥] 3
	set Binary.char[3] ♥
	set Binary.byte[♦] 4
	set Binary.char[4] ♦
	set Binary.byte[♣] 5
	set Binary.char[5] ♣
	set Binary.byte[♠] 6
	set Binary.char[6] ♠
	set Binary.byte[•] 7
	set Binary.char[7] •
	set Binary.byte[◘] 8
	set Binary.char[8] ◘
	set Binary.byte[○] 9
	set Binary.char[9] ○
	set Binary.byte[◙] 10
	set Binary.char[10] ◙
	set Binary.byte[♂] 11
	set Binary.char[11] ♂
	set Binary.byte[♀] 12
	set Binary.char[12] ♀
	set Binary.byte[♪] 13
	set Binary.char[13] ♪
	set Binary.byte[♫] 14
	set Binary.char[14] ♫
	set Binary.byte[☼] 15
	set Binary.char[15] ☼
	set Binary.byte[►] 16
	set Binary.char[16] ►
	set Binary.byte[◄] 17
	set Binary.char[17] ◄
	set Binary.byte[↕] 18
	set Binary.char[18] ↕
	set Binary.byte[‼] 19
	set Binary.char[19] ‼
	set Binary.byte[¶] 20
	set Binary.char[20] ¶
	set Binary.byte[§] 21
	set Binary.char[21] §
	set Binary.byte[▬] 22
	set Binary.char[22] ▬
	set Binary.byte[↨] 23
	set Binary.char[23] ↨
	set Binary.byte[↑] 24
	set Binary.char[24] ↑
	set Binary.byte[↓] 25
	set Binary.char[25] ↓
	set Binary.byte[→] 26
	set Binary.char[26] →
	set Binary.byte[←] 27
	set Binary.char[27] ←
	set Binary.byte[∟] 28
	set Binary.char[28] ∟
	set Binary.byte[↔] 29
	set Binary.char[29] ↔
	set Binary.byte[▲] 30
	set Binary.char[30] ▲
	set Binary.byte[▼] 31
	set Binary.char[31] ▼
	set Binary.char[32] {Binary.space}
	set Binary.byte[!] 33
	set Binary.char[33] !
	set Binary.byte["] 34
	set Binary.char[34] "
	set Binary.byte[#] 35
	set Binary.char[35] #
	set Binary.byte[$] 36
	set Binary.char[36] $
	set Binary.byte[%] 37
	set Binary.char[37] %
	set Binary.byte[&] 38
	set Binary.char[38] &
	set Binary.byte['] 39
	set Binary.char[39] '
	set Binary.byte[(] 40
	set Binary.char[40] (
	set Binary.byte[)] 41
	set Binary.char[41] )
	set Binary.byte[*] 42
	set Binary.char[42] *
	set Binary.byte[+] 43
	set Binary.char[43] +
	set Binary.byte[,] 44
	set Binary.char[44] ,
	set Binary.byte[-] 45
	set Binary.char[45] -
	set Binary.byte[.] 46
	set Binary.char[46] .
	set Binary.byte[/] 47
	set Binary.char[47] /
	set Binary.byte[0] 48
	set Binary.char[48] 0
	set Binary.byte[1] 49
	set Binary.char[49] 1
	set Binary.byte[2] 50
	set Binary.char[50] 2
	set Binary.byte[3] 51
	set Binary.char[51] 3
	set Binary.byte[4] 52
	set Binary.char[52] 4
	set Binary.byte[5] 53
	set Binary.char[53] 5
	set Binary.byte[6] 54
	set Binary.char[54] 6
	set Binary.byte[7] 55
	set Binary.char[55] 7
	set Binary.byte[8] 56
	set Binary.char[56] 8
	set Binary.byte[9] 57
	set Binary.char[57] 9
	set Binary.byte[:] 58
	set Binary.char[58] :
	set Binary.byte[;] 59
	set Binary.char[59] ;
	set Binary.byte[<] 60
	set Binary.char[60] <
	set Binary.byte[=] 61
	set Binary.char[61] =
	set Binary.byte[>] 62
	set Binary.char[62] >
	set Binary.byte[?] 63
	set Binary.char[63] ?
	set Binary.byte[@] 64
	set Binary.char[64] @
	set Binary.byte[A] 65
	set Binary.char[65] A
	set Binary.byte[B] 66
	set Binary.char[66] B
	set Binary.byte[C] 67
	set Binary.char[67] C
	set Binary.byte[D] 68
	set Binary.char[68] D
	set Binary.byte[E] 69
	set Binary.char[69] E
	set Binary.byte[F] 70
	set Binary.char[70] F
	set Binary.byte[G] 71
	set Binary.char[71] G
	set Binary.byte[H] 72
	set Binary.char[72] H
	set Binary.byte[I] 73
	set Binary.char[73] I
	set Binary.byte[J] 74
	set Binary.char[74] J
	set Binary.byte[K] 75
	set Binary.char[75] K
	set Binary.byte[L] 76
	set Binary.char[76] L
	set Binary.byte[M] 77
	set Binary.char[77] M
	set Binary.byte[N] 78
	set Binary.char[78] N
	set Binary.byte[O] 79
	set Binary.char[79] O
	set Binary.byte[P] 80
	set Binary.char[80] P
	set Binary.byte[Q] 81
	set Binary.char[81] Q
	set Binary.byte[R] 82
	set Binary.char[82] R
	set Binary.byte[S] 83
	set Binary.char[83] S
	set Binary.byte[T] 84
	set Binary.char[84] T
	set Binary.byte[U] 85
	set Binary.char[85] U
	set Binary.byte[V] 86
	set Binary.char[86] V
	set Binary.byte[W] 87
	set Binary.char[87] W
	set Binary.byte[X] 88
	set Binary.char[88] X
	set Binary.byte[Y] 89
	set Binary.char[89] Y
	set Binary.byte[Z] 90
	set Binary.char[90] Z
	set Binary.byte[[] 91
	set Binary.char[91] [
	set Binary.byte[\] 92
	set Binary.char[92] \
	set Binary.byte[]] 93
	set Binary.char[93] ]
	set Binary.byte[^] 94
	set Binary.char[94] ^
	set Binary.byte[_] 95
	set Binary.char[95] _
	set Binary.byte[`] 96
	set Binary.char[96] `
	set Binary.byte[a] 97
	set Binary.char[97] a
	set Binary.byte[b] 98
	set Binary.char[98] b
	set Binary.byte[c] 99
	set Binary.char[99] c
	set Binary.byte[d] 100
	set Binary.char[100] d
	set Binary.byte[e] 101
	set Binary.char[101] e
	set Binary.byte[f] 102
	set Binary.char[102] f
	set Binary.byte[g] 103
	set Binary.char[103] g
	set Binary.byte[h] 104
	set Binary.char[104] h
	set Binary.byte[i] 105
	set Binary.char[105] i
	set Binary.byte[j] 106
	set Binary.char[106] j
	set Binary.byte[k] 107
	set Binary.char[107] k
	set Binary.byte[l] 108
	set Binary.char[108] l
	set Binary.byte[m] 119
	set Binary.char[119] m
	set Binary.byte[n] 110
	set Binary.char[110] n
	set Binary.byte[o] 111
	set Binary.char[111] o
	set Binary.byte[p] 112
	set Binary.char[112] p
	set Binary.byte[q] 113
	set Binary.char[113] q
	set Binary.byte[r] 114
	set Binary.char[114] r
	set Binary.byte[s] 115
	set Binary.char[115] s
	set Binary.byte[t] 116
	set Binary.char[116] t
	set Binary.byte[u] 117
	set Binary.char[117] u
	set Binary.byte[v] 118
	set Binary.char[118] v
	set Binary.byte[w] 119
	set Binary.char[119] w
	set Binary.byte[x] 120
	set Binary.char[120] x
	set Binary.byte[y] 121
	set Binary.char[121] y
	set Binary.byte[z] 122
	set Binary.char[122] z
	set Binary.byte[{] 123
	set Binary.char[123] {
	set Binary.byte[|] 124
	set Binary.char[124] |
	set Binary.byte[}] 125
	set Binary.char[125] }
	set Binary.byte[~] 126
	set Binary.char[126] ~
	set Binary.byte[⌂] 127
	set Binary.char[127] ⌂
	set Binary.byte[Ç] 128
	set Binary.char[128] Ç
	set Binary.byte[ü] 129
	set Binary.char[129] ü
	set Binary.byte[é] 130
	set Binary.char[130] é
	set Binary.byte[â] 131
	set Binary.char[131] â
	set Binary.byte[ä] 132
	set Binary.char[132] ä
	set Binary.byte[à] 133
	set Binary.char[133] à
	set Binary.byte[å] 134
	set Binary.char[134] å
	set Binary.byte[ç] 135
	set Binary.char[135] ç
	set Binary.byte[ê] 136
	set Binary.char[136] ê
	set Binary.byte[ë] 137
	set Binary.char[137] ë
	set Binary.byte[è] 138
	set Binary.char[138] è
	set Binary.byte[ï] 139
	set Binary.char[139] ï
	set Binary.byte[î] 140
	set Binary.char[140] î
	set Binary.byte[ì] 141
	set Binary.char[141] ì
	set Binary.byte[Ä] 142
	set Binary.char[142] Ä
	set Binary.byte[Å] 143
	set Binary.char[143] Å
	set Binary.byte[É] 144
	set Binary.char[144] É
	set Binary.byte[æ] 145
	set Binary.char[145] æ
	set Binary.byte[Æ] 146
	set Binary.char[146] Æ
	set Binary.byte[ô] 147
	set Binary.char[147] ô
	set Binary.byte[ö] 148
	set Binary.char[148] ö
	set Binary.byte[ò] 149
	set Binary.char[149] ò
	set Binary.byte[û] 150
	set Binary.char[150] û
	set Binary.byte[ù] 151
	set Binary.char[151] ù
	set Binary.byte[ÿ] 152
	set Binary.char[152] ÿ
	set Binary.byte[Ö] 153
	set Binary.char[153] Ö
	set Binary.byte[Ü] 154
	set Binary.char[154] Ü
	set Binary.byte[¢] 155
	set Binary.char[155] ¢
	set Binary.byte[£] 156
	set Binary.char[156] £
	set Binary.byte[¥] 157
	set Binary.char[157] ¥
	set Binary.byte[₧] 158
	set Binary.char[158] ₧
	set Binary.byte[ƒ] 159
	set Binary.char[159] ƒ
	set Binary.byte[á] 160
	set Binary.char[160] á
	set Binary.byte[í] 161
	set Binary.char[161] í
	set Binary.byte[ó] 162
	set Binary.char[162] ó
	set Binary.byte[ú] 163
	set Binary.char[163] ú
	set Binary.byte[ñ] 164
	set Binary.char[164] ñ
	set Binary.byte[Ñ] 165
	set Binary.char[165] Ñ
	set Binary.byte[ª] 166
	set Binary.char[166] ª
	set Binary.byte[º] 167
	set Binary.char[167] º
	set Binary.byte[¿] 168
	set Binary.char[168] ¿
	set Binary.byte[⌐] 169
	set Binary.char[169] ⌐
	set Binary.byte[¬] 170
	set Binary.char[170] ¬
	set Binary.byte[½] 171
	set Binary.char[171] ½
	set Binary.byte[¼] 172
	set Binary.char[172] ¼
	set Binary.byte[¡] 173
	set Binary.char[173] ¡
	set Binary.byte[«] 174
	set Binary.char[174] «
	set Binary.byte[»] 175
	set Binary.char[175] »
	set Binary.byte[░] 176
	set Binary.char[176] ░
	set Binary.byte[▒] 177
	set Binary.char[177] ▒
	set Binary.byte[▓] 178
	set Binary.char[178] ▓
	set Binary.byte[│] 179
	set Binary.char[179] │
	set Binary.byte[┤] 180
	set Binary.char[180] ┤
	set Binary.byte[╡] 181
	set Binary.char[181] ╡
	set Binary.byte[╢] 182
	set Binary.char[182] ╢
	set Binary.byte[╖] 183
	set Binary.char[183] ╖
	set Binary.byte[╕] 184
	set Binary.char[184] ╕
	set Binary.byte[╣] 185
	set Binary.char[185] ╣
	set Binary.byte[║] 186
	set Binary.char[186] ║
	set Binary.byte[╗] 187
	set Binary.char[187] ╗
	set Binary.byte[╝] 188
	set Binary.char[188] ╝
	set Binary.byte[╜] 189
	set Binary.char[189] ╜
	set Binary.byte[╛] 190
	set Binary.char[190] ╛
	set Binary.byte[┐] 191
	set Binary.char[191] ┐
	set Binary.byte[└] 192
	set Binary.char[192] └
	set Binary.byte[┴] 193
	set Binary.char[193] ┴
	set Binary.byte[┬] 194
	set Binary.char[194] ┬
	set Binary.byte[├] 195
	set Binary.char[195] ├
	set Binary.byte[─] 196
	set Binary.char[196] ─
	set Binary.byte[┼] 197
	set Binary.char[197] ┼
	set Binary.byte[╞] 198
	set Binary.char[198] ╞
	set Binary.byte[╟] 199
	set Binary.char[199] ╟
	set Binary.byte[╚] 200
	set Binary.char[200] ╚
	set Binary.byte[╔] 201
	set Binary.char[201] ╔
	set Binary.byte[╩] 202
	set Binary.char[202] ╩
	set Binary.byte[╦] 203
	set Binary.char[203] ╦
	set Binary.byte[╠] 204
	set Binary.char[204] ╠
	set Binary.byte[═] 205
	set Binary.char[205] ═
	set Binary.byte[╬] 206
	set Binary.char[206] ╬
	set Binary.byte[╧] 207
	set Binary.char[207] ╧
	set Binary.byte[╨] 208
	set Binary.char[208] ╨
	set Binary.byte[╤] 209
	set Binary.char[209] ╤
	set Binary.byte[╥] 210
	set Binary.char[210] ╥
	set Binary.byte[╙] 211
	set Binary.char[211] ╙
	set Binary.byte[╘] 212
	set Binary.char[212] ╘
	set Binary.byte[╒] 213
	set Binary.char[213] ╒
	set Binary.byte[╓] 214
	set Binary.char[214] ╓
	set Binary.byte[╫] 215
	set Binary.char[215] ╫
	set Binary.byte[╪] 216
	set Binary.char[216] ╪
	set Binary.byte[┘] 217
	set Binary.char[217] ┘
	set Binary.byte[┌] 218
	set Binary.char[218] ┌
	set Binary.byte[█] 219
	set Binary.char[219] █
	set Binary.byte[▄] 220
	set Binary.char[220] ▄
	set Binary.byte[▌] 221
	set Binary.char[221] ▌
	set Binary.byte[▐] 222
	set Binary.char[222] ▐
	set Binary.byte[▀] 223
	set Binary.char[223] ▀
	set Binary.byte[α] 224
	set Binary.char[224] α
	set Binary.byte[ß] 225
	set Binary.char[225] ß
	set Binary.byte[Γ] 226
	set Binary.char[226] Γ
	set Binary.byte[π] 227
	set Binary.char[227] π
	set Binary.byte[Σ] 228
	set Binary.char[228] Σ
	set Binary.byte[σ] 229
	set Binary.char[229] σ
	set Binary.byte[µ] 230
	set Binary.char[230] µ
	set Binary.byte[τ] 231
	set Binary.char[231] τ
	set Binary.byte[Φ] 232
	set Binary.char[232] Φ
	set Binary.byte[Θ] 233
	set Binary.char[233] Θ
	set Binary.byte[Ω] 234
	set Binary.char[234] Ω
	set Binary.byte[δ] 235
	set Binary.char[235] δ
	set Binary.byte[∞] 236
	set Binary.char[236] ∞
	set Binary.byte[φ] 237
	set Binary.char[237] φ
	set Binary.byte[ε] 238
	set Binary.char[238] ε
	set Binary.byte[∩] 239
	set Binary.char[239] ∩
	set Binary.byte[≡] 240
	set Binary.char[240] ≡
	set Binary.byte[±] 241
	set Binary.char[241] ±
	set Binary.byte[≥] 242
	set Binary.char[242] ≥
	set Binary.byte[≤] 243
	set Binary.char[243] ≤
	set Binary.byte[⌠] 244
	set Binary.char[244] ⌠
	set Binary.byte[⌡] 245
	set Binary.char[245] ⌡
	set Binary.byte[÷] 246
	set Binary.char[246] ÷
	set Binary.byte[≈] 247
	set Binary.char[247] ≈
	set Binary.byte[°] 248
	set Binary.char[248] °
	set Binary.byte[∙] 249
	set Binary.char[249] ∙
	set Binary.byte[·] 250
	set Binary.char[250] ·
	set Binary.byte[√] 251
	set Binary.char[251] √
	set Binary.byte[ⁿ] 252
	set Binary.char[252] ⁿ
	set Binary.byte[²] 253
	set Binary.char[253] ²
	set Binary.byte[■] 254
	set Binary.char[254] ■
	set Binary.byte[ ] 255
	set Binary.char[255]  
quit