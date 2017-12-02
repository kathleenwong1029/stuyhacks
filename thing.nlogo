patches-own[current]
globals[direction dead winner pass1 eaten winner2 pass2]
turtles-own [falling?]
breed[things thing]
breed[monsters monster]
breed[sharks shark]

to setup
  ca
  resize-world -55 55 -25 25
  set-patch-size 9
  import-pcolors "background1.png"
  create-turtles 1
  ask turtles[set xcor -50 set ycor 19.5 set size 8 set color blue set shape "peggie"]
  ask patch -53 -7 [set pcolor 95.4]
  ask patch -30 3 [set pcolor 95.4]
end

to l
  ask turtle 0[
    set heading -90
    fd 1]
end

to r
  ask turtle 0[
    set heading 90
    fd 1]
end

to u
  ask turtle 0[
    set heading 0
    fd 1]
end

to d
  ask turtle 0[
  set heading 180
  fd 1]
end

to shiftright
  every 0.05[
  ask patches [
    set current pcolor]
  ask patches[
    if [current] of patch (pxcor - 1) (pycor) = 36.1 or pcolor = 36.1 [
    set pcolor ([current] of patch (pxcor - 1) (pycor))]]]
end

to shiftleft
  every 0.05[
    ask patches [
      set current pcolor]
    ask patches[
      if [current] of patch (pxcor + 1) (pycor) = 36.1 or pcolor = 36.1 [
        set pcolor ([current] of patch (pxcor + 1) (pycor))]]]
end

to shift
  ifelse dead != true and winner != true [every 0.1 [
  ifelse direction = 0 [shiftleft] [shiftright]]
  every 0.5 [
  ifelse direction = 0 [set direction 1] [set direction 0]]
  every 0.05 [
    fall
    win
    ask turtles [if [pcolor] of patch-here = 13 or [pcolor] of patch-here = 22.7 [set dead true die]]
  ]]
  [if dead = true [user-message (word "Oh no! You died!") stop]
    if winner = true [stop]]
end

to fall
  ask turtles [ifelse ([pcolor] of patch (xcor) (ycor - 2.5) != 36.1 and [pcolor] of patch (xcor) (ycor - 2.5) != 46.4) [set falling? true] [set falling? false]]
  ask turtles [if falling? = true [every 0.01 [set ycor (ycor - 1)]]]
end

to jumpy
  ask turtle 0 [set heading 0 fd 1.6 set heading 90 fd 3.8]
end

to gravity
  every 0.07 [ask turtle 0 [if ([pcolor] of patch (xcor) (ycor - 2.5) != 36.1 and [pcolor] of patch (xcor) (ycor - 2.5) != 46.4) [set ycor (ycor - .8)]
      if [pcolor] of patch (xcor) (ycor - 2.5) = 36.1 or [pcolor] of patch (xcor) (ycor - 2.5) = 46.4 [stop]]]
  ask turtle 0 [if [pcolor] of patch-ahead 1 = 36.1 [bk 1]]
end

to win
  if [xcor] of turtle 0 >= 50 and [xcor] of turtle 0 <= 54 and [ycor] of turtle 0 >= -17 and [ycor] of turtle 0 <= -14
  [user-message (word ("Congratulations! You passed level one! \nPassword for next level: spiffy")) fakesetup set winner true stop]
end

to check
  set pass1 user-input "Please enter the password for level 2"
  ifelse pass1 = "spiffy" [fakesetup] [setup]
end

to fakesetup
  ca
  set eaten false
  resize-world -85 25 -22 28
  import-pcolors "level2.png"
  create-things 1
  ask things [set size 10 set ycor (-20 + random(40)) set xcor -82 set shape "speggie"]
  create-monsters 1
  ask monsters [set size 25 set xcor 13 set ycor 5 set heading 0 set shape "turty"]
  create-sharks 1
  ask sharks [set size 8 set heading 135 set shape "sharky"]
end

to level2
  ifelse eaten = false and winner2 != true [every 5[
    create-sharks 1
    ask sharks[set shape "sharky" set size 8 set heading 270]
  ]
  every 0.2[
    ask sharks [left random (10) right random (10) fd 1]
  ]
  every 0.0001 [seesharks win2]]
  [if eaten = true [user-message (word "Oh no! You've been eaten by a shark!") fakesetup stop]
    if winner2 = true [stop]]
end

to seesharks
  ask things [if any? sharks in-radius 5 [set eaten true]]
end

to win2
  if [xcor] of thing 0 >= 1 and [xcor] of thing 0 <= 5 and [ycor] of thing 0 >= 1 and [ycor] of thing 0 <= 3
  [user-message (word "Congratulations! You passed level two! \nPassword for next level: marvelous") setup3 set winner2 true stop]
end

to check2
  set pass2 user-input "Please enter the password for level 3"
  ifelse pass2 = "marvelous" [setup3] [fakesetup]
end

to setup3
  ca
  import-pcolors "space.png"
  resize-world -55 55 -25 25
  create-things 1
  ask things[setxy 0 -20 set size 10 set shape "beggie"]
end

to ballwithpeg
  every .2[fd 1]
end
@#$#@#$#@
GRAPHICS-WINDOW
192
21
1201
511
55
25
9.0
1
10
1
1
1
0
1
1
1
-55
55
-25
25
0
0
1
ticks
30.0

BUTTON
38
75
146
108
set up level one
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
6
476
61
509
left
l
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
129
476
184
509
right
r
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
68
432
123
465
up
u
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
68
476
123
509
down
d
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
61
113
124
146
go!
shift
T
1
T
OBSERVER
NIL
U
NIL
NIL
1

BUTTON
36
173
142
206
set up level two
check
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
63
365
126
398
jump
jumpy
NIL
1
T
OBSERVER
NIL
J
NIL
NIL
1

BUTTON
58
214
127
247
go!
level2
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
30
275
149
308
set up level three
check2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
53
155
203
173
-------------
11
0.0
1

TEXTBOX
52
254
202
272
-------------
11
0.0
1

TEXTBOX
13
16
183
72
welcome to the best game ever! for instructions, please head on over to the info tab! enjoy!!
11
95.0
1

@#$#@#$#@
## WHAT IS THIS?

This is the most important game you'll ever play.

## LEVEL ONE

In Level One, your goal is to get to the treasure chest on the lower right corner of the screen!
You can use the J key to jump, the A key to go left, and the D key to go right.
You can't fall into the lava!

## LEVEL TWO

In Level Two, your goal is to get to the turtle's mouth!
You can use the A key to go left, the D key to go right, the W key to go up, and the S key to go down.
Don't get eaten by a shark!

## LEVEL THREE

(suggested things for the user to notice while running the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

this dumbass kathleen
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

balloon
true
0
Line -1 false 150 135 150 255
Circle -13791810 true false 105 45 90
Polygon -13791810 true false 159 100 132 139 169 139 150 110

beggie
false
0
Polygon -16777216 false false 89 150 137 168 183 160 213 142 229 170 216 193 202 212 165 225 152 225 132 225 116 220 106 214 95 202 76 170
Circle -955883 true false 109 41 82
Circle -13791810 true false 75 75 152
Circle -1 true false 106 134 91
Circle -16777216 true false 104 107 6
Circle -16777216 true false 187 106 6
Polygon -1184463 true false 135 130 163 129 150 150
Polygon -955883 true false 110 214 95 226 109 223 109 237 117 226 124 234 122 218
Polygon -955883 true false 194 212 209 224 195 221 195 235 187 224 180 232 182 216
Polygon -955883 true false 109 85 136 98 162 99 190 84 171 64 129 70
Polygon -13791810 true false 108 86 122 84 137 42 120 48 110 65
Polygon -13840069 true false 135 43 148 39 142 63 141 83 123 83
Polygon -2064490 true false 147 39 156 40 157 82 142 83 141 64
Polygon -2674135 true false 157 40 171 45 171 66 171 83 157 81
Polygon -1184463 true false 172 46 181 55 182 80 170 82
Polygon -8630108 true false 182 79 192 79 190 64 181 53
Polygon -13791810 true false 91 119 67 146 56 194 81 165
Polygon -13791810 true false 211 120 236 140 247 188 222 159
Line -1 false 252 66 240 173
Circle -2064490 true false 216 6 77
Polygon -1 true false 226 131 236 141 246 187 224 162 218 143 220 127
Polygon -1 true false 75 137 65 147 58 192 77 168 83 149 75 133
Polygon -1 true false 74 141 107 161 190 157 214 146 221 129 228 165 216 196 202 213 189 217 173 225 148 225 127 225 107 213 105 211 93 205 89 195 85 188 78 173 76 172 74 149
Polygon -16777216 false false 222 125 212 144 226 166 245 186 237 140
Polygon -16777216 false false 76 134 89 151 75 173 56 193 64 147

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

peggie
false
10
Circle -955883 true false 109 41 82
Circle -13345367 true true 75 73 152
Circle -1 true false 106 134 91
Circle -16777216 true false 104 107 6
Circle -16777216 true false 187 106 6
Polygon -1184463 true false 139 129 160 129 151 146
Polygon -955883 true false 110 214 95 226 109 223 109 237 117 226 124 234 122 218
Polygon -955883 true false 194 212 209 224 195 221 195 235 187 224 180 232 182 216
Polygon -955883 true false 109 85 136 98 162 99 190 84 171 64 129 70
Polygon -13791810 true false 108 86 122 84 137 42 120 48 110 65
Polygon -13840069 true false 135 43 148 39 142 63 141 83 123 83
Polygon -2064490 true false 147 39 156 40 157 82 142 83 141 64
Polygon -2674135 true false 157 40 171 45 171 66 171 83 157 81
Polygon -1184463 true false 172 46 181 55 182 80 170 82
Polygon -8630108 true false 182 79 192 79 190 64 181 53
Polygon -13345367 true true 91 119 67 146 56 194 81 165
Polygon -13345367 true true 211 120 236 140 247 188 222 159

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sharky
false
0
Polygon -13791810 true false 21 160 7 146 24 143 -4 141 13 129 76 105 119 101 191 114 241 130 255 123 289 90 286 109 271 141 286 172 285 182 252 162 237 158 231 158 218 153 209 153 165 159 85 177
Polygon -13791810 true false 102 172 149 177 186 176 132 165
Polygon -13791810 true false 112 108 128 83 140 74 144 76 141 97 147 112
Circle -16777216 true false 47 124 8
Line -16777216 false 78 134 78 150
Line -16777216 false 83 134 83 150
Line -16777216 false 88 134 88 150
Polygon -13791810 true false 222 125 238 118 237 130
Polygon -13791810 true false 179 157 195 161 199 156 194 152

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

speggie
false
12
Circle -13791810 true false 75 73 152
Circle -1 true false 106 134 91
Polygon -1184463 true false 139 129 160 129 151 146
Polygon -955883 true false 110 214 95 226 109 223 109 237 117 226 124 234 122 218
Polygon -955883 true false 194 212 209 224 195 221 195 235 187 224 180 232 182 216
Polygon -13791810 true false 91 119 67 146 56 194 81 165
Polygon -13791810 true false 211 120 236 140 247 188 222 159
Polygon -14835848 true false 98 92 124 77 148 72 174 75 203 93 176 89 131 89 116 89
Circle -1 true false 109 96 33
Circle -16777216 true false 114 102 22
Circle -1 true false 160 95 33
Circle -16777216 true false 165 100 22
Rectangle -1 true false 140 107 163 115
Polygon -1 true false 92 101 112 107 112 117 84 108
Polygon -1 true false 209 100 189 106 189 116 217 107
Polygon -16777216 true false 78 173 124 198 190 196 227 168 215 194 194 214 172 226 147 226 128 223 113 215 98 207 84 188

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

turty
true
0
Rectangle -10899396 true false 76 140 89 177
Circle -13840069 true false 4 118 85
Polygon -13840069 true false 237 117 266 92 287 86 299 104 285 117 243 139
Polygon -13840069 true false 213 60 174 49 154 49 139 63 130 93 154 94 162 76 173 69 186 65
Polygon -13840069 true false 217 245 174 262 154 262 139 248 129 223 138 213 152 229 175 243 191 244
Polygon -13840069 true false 241 198 270 223 291 229 303 211 289 198 247 176
Polygon -13840069 true false 271 127 271 187 245 217 211 232 121 228 85 183 85 136 138 88 211 82 247 96
Polygon -6459832 true false 99 136 103 134 128 109 132 128 118 145
Polygon -6459832 true false 125 147 139 133 155 144 160 160 135 167
Polygon -6459832 true false 99 141 116 147 127 168 111 179 92 160
Polygon -6459832 true false 137 109 139 108 141 127 159 138 171 134 172 114 169 101
Polygon -6459832 true false 162 146 172 142 193 147 196 169 183 183 169 179
Polygon -6459832 true false 92 183 93 171 110 187 125 183 117 210
Polygon -6459832 true false 130 176 162 168 162 186 150 213 128 212
Polygon -6459832 true false 171 185 188 193 203 177 207 200 182 217
Polygon -6459832 true false 165 192 170 193 175 215 157 215
Polygon -6459832 true false 178 133 200 142 214 124 199 98 177 98 182 118
Polygon -6459832 true false 209 98 230 104 251 119 257 136 245 148
Polygon -6459832 true false 209 144 218 128 225 128 238 152 216 164 199 147
Polygon -6459832 true false 205 164 223 169 242 155 248 169 234 184 220 190 207 180
Polygon -6459832 true false 198 215 211 219 230 213 249 194 260 182 253 177 222 200 215 196 214 202
Polygon -6459832 true false 247 157 259 144 259 172 252 172
Circle -10899396 true false 151 58 12
Circle -10899396 true false 273 104 12
Circle -10899396 true false 277 89 12
Circle -10899396 true false 258 103 12
Circle -10899396 true false 138 90 12
Circle -10899396 true false 173 52 12
Circle -10899396 true false 139 72 12
Circle -10899396 true false 6 141 12
Circle -10899396 true false 35 135 12
Circle -10899396 true false 19 130 12
Circle -10899396 true false 183 214 12
Circle -10899396 true false 166 249 12
Circle -10899396 true false 145 238 12
Circle -10899396 true false 134 217 12
Circle -10899396 true false 164 88 12
Circle -10899396 true false 285 204 12
Circle -10899396 true false 267 202 12
Circle -10899396 true false 216 87 12
Circle -10899396 true false 191 86 12
Circle -10899396 true false 50 123 12
Circle -10899396 true false 63 132 12
Circle -10899396 true false 30 122 12
Circle -16777216 true false 50 139 10
Polygon -16777216 true false 13 169 31 160 43 161 55 174 55 186 46 195 24 200 13 190 9 182

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
