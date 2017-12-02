; Peter Brooks, Stuyvesant H.S., 11/18/07 - 10/26/08

globals [
  drawing-turtle
  drawing-color
  button-was-down?
  last-major-color
  shade-colors
  state
  background
  mycolor1
  mycolor2
  patch-position
  patch-color
]

patches-own [painted-color]

turtles-own [t-type t-who]

to setup
  ca
  ask patches [set painted-color black]
  set button-was-down? false
  set last-major-color 5
  set drawing-color white
  set background black
  set mycolor1 blue
  set mycolor2 green
  set state "nothing"

  let mx max-pxcor - min-pxcor + 1
  let my max-pycor - min-pycor + 1
  let msg (word "1. The window now has " mx  " x "  my  " patches.  If that's not what you want, now is the time to change it " )
  set msg (word msg  "by pressing the Settings button, and then when done, pressing the Setup button again.")
  user-message msg
end

to go
  show-patch-position

  if state = 0
  [  setup ]

  if state = "nothing"
  [  goto-paint-state ]

  if state = "paint-state"
  [  if mouse-inside?
     [  ask turtle drawing-turtle [setxy mouse-xcor mouse-ycor]
        if mouse-down?
        [  ask patch round mouse-xcor round mouse-ycor
           [  set pcolor drawing-color
              set painted-color drawing-color
           ]
        ]
     ]
  ]

  if state = "choose-color-state"
  [  if mouse-inside?
     [  ask turtle drawing-turtle
        [  setxy mouse-xcor mouse-ycor ]
        if mouse-down? and not button-was-down?
        [  ask turtle drawing-turtle
           [  let who-clicked find-nearest-turtle
              if who-clicked != -1
              [  let the-type [t-type] of turtle who-clicked
                 if the-type = "major"
                 [  set last-major-color [color] of turtle who-clicked
                    create-shades
                    set drawing-color last-major-color
                    ask turtle drawing-turtle [set color drawing-color]
                    ;set [color] of turtle drawing-turtle drawing-color
                 ]
                 if the-type = "shade"
                 [  set drawing-color [color] of turtle who-clicked
                    ask turtle drawing-turtle [set color drawing-color]
                    ;set [color] of turtle drawing-turtle drawing-color
                 ]
                 if the-type = "background"
                 [  ask turtles with [t-type = "background"]
                    [  set color drawing-color]
                    set background drawing-color
                 ]
                 if the-type = "1"
                 [  ask turtles with [t-type = "1"]
                    [  set color drawing-color ]
                    set mycolor1 drawing-color
                 ]
                 if the-type = "2"
                 [  ask turtles with [t-type = "2"]
                    [  set color drawing-color ]
                    set mycolor2 drawing-color
                 ]
              ]
           ]
        ]
     ]
  ]
  set button-was-down? mouse-down?
end

to goto-paint-state
  if state != "paint-state"
  [  set state "paint-state"
     ct
     ask patches [set pcolor painted-color]
     crt 1
     [  set drawing-turtle who
        set shape "circle 2"
        set size .8
        set color drawing-color
     ]
     set button-was-down? mouse-down?
  ]
end

to set-background
  if state = "paint-state"
  [  ask patches
    [  set pcolor background
       set painted-color background
    ]
  ]
end

to set-color [which]
  if state = "paint-state"
  [  if which = "background" [set drawing-color background]
     if which = "under-mouse" and mouse-inside?
     [  set drawing-color [pcolor] of patch round mouse-xcor round mouse-ycor ]
     if which = "1" [set drawing-color mycolor1]
     if which = "2" [set drawing-color mycolor2]
     ask turtle drawing-turtle [set color drawing-color]
     ;set [color] of turtle drawing-turtle drawing-color
  ]
end

to goto-choose-color-state
  if state != "choose-color-state"
  [  set state "choose-color-state"
     ask patches [set pcolor black]
     ct

     ; ------------- setup the major color chooser
     let major-color-frac .7
     let major-color-side major-color-frac * world-height / 14
     crt 14
     [  set size major-color-side
        set shape "full square"
        set t-type "major"
     ]
     let min-who min [who] of turtles with [t-type = "major"]
     ask turtles with [t-type = "major"]
     [  set t-who (who - min-who)
        set color 5 + t-who * 10
        set xcor max-pxcor + .5 - .5 * major-color-side
        set ycor max-pycor + .5 - .5 * (1 - major-color-frac) * world-height - .5 - t-who * major-color-side
     ]
     crt 1
     [  set color black
        setxy ([xcor] of turtle min-who) ([ycor] of turtle min-who) + major-color-side
        set label "Choose major color"
        set t-type "label"
     ]

     ; ---------------  set up shade chooser
     set shade-colors 30
     let shade-side  world-width / shade-colors
     crt shade-colors
     [  set size shade-side
        set shape "full square"
        set t-type "shade"
     ]
     set min-who min [who] of turtles with [t-type = "shade"]
     ask turtles with [t-type = "shade"]
     [  set t-who (who - min-who)
        setxy (min-pxcor - .5 + ((t-who + .5) * shade-side)) (min-pycor - .5 + (.5 * shade-side))
      ]
     create-shades
     crt 1
     [  set color black
        setxy (min-pxcor + .5 * world-width) min-pycor + 1.5 * shade-side
        set label "Choose shade"
        set t-type "label"
     ]

     ; -------------- set up the Background, My Color 1 and My Color 2 color boxes
     setup-colorbox "Background" 0.08 .1 background "background"
     setup-colorbox "My Color 1" 0.08 0 mycolor1 "1"
     setup-colorbox "My Color 2" 0.08 -.1 mycolor2 "2"

     ; ---------------  set up choosing turtle
     crt 1
     [  set t-type "choosing"
        set drawing-turtle who
        ifelse shade-side < major-color-side
        [  set size .8 * shade-side ]
        [  set size .8 * major-color-side ]
        set shape "drawing point"
        set color last-major-color
     ]
   ]
end

to create-shades
  ask turtles with [t-type = "shade"]
  [  set color (last-major-color - 5) + (9.9 * t-who / (shade-colors - 1)) ]
end


to setup-colorbox [the-label width center the-color the-t-type]
  let x min-pxcor - .5 + .5 * world-width
  let y min-pycor - .5 + .5 * world-height + center * world-height
  crt 1
  [  set shape "full square 2"
     set size width * world-width
     set color the-color
     setxy x y
     set t-type the-t-type
  ]
  crt 1
  [  setxy (x - world-width * width) y
     set color black
     set label the-label
  ]
end

to-report find-nearest-turtle
  let x [xcor] of turtle drawing-turtle
  let y [ycor] of turtle drawing-turtle
  let color-turtles turtles with [t-type = "major" or t-type = "shade" or t-type = "background" or t-type = "1" or t-type = "2"]
  let min-dist min [distancexy x y] of color-turtles
  let turtle-min one-of color-turtles with [distancexy x y <= min-dist]
  if turtle-min != nobody
  [  if min-dist < (.5 * [size] of turtle-min)
     [  report [who] of turtle-min ]
  ]
  report -1
end

to load-file
  goto-paint-state
  user-message "The file must have format: JPG, GIF, PNG or BMP"
  let filename user-file
  if filename != false
  [  import-pcolors filename
     ask patches [set painted-color pcolor]
  ]
end

to save-to-file
  goto-paint-state
  user-message "The filename you choose must have the suffix: .PNG"
  let filename user-new-file
  if filename != false
  [  export-view filename ]
end

to show-patch-position
  if mouse-inside?
  [  let x round mouse-xcor
     let y round mouse-ycor
     ifelse state = "paint-state"
     [  set patch-position (word x  ", "  y)
        set patch-color [pcolor] of patch x y
     ]
     [  set patch-position ""
        set patch-color ""
     ]
  ]
end


@#$#@#$#@
GRAPHICS-WINDOW
291
11
730
471
16
16
13.0
1
12
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

TEXTBOX
60
10
217
31
The Patch Painter
17
13.0
0

BUTTON
7
48
71
81
NIL
Setup
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
151
104
256
137
Choose Color
goto-choose-color-state
NIL
1
T
OBSERVER
NIL
C
NIL
NIL
1

BUTTON
7
104
113
137
Paint Patches
goto-paint-state
NIL
1
T
OBSERVER
NIL
Z
NIL
NIL
1

BUTTON
82
48
145
81
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
130
118
145
136
or
11
0.0
0

BUTTON
6
423
88
456
Load file
load-file
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
103
423
197
456
Save to file
save-to-file
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
163
265
234
298
MyColor 1
set-color \"1\"
NIL
1
T
OBSERVER
NIL
1
NIL
NIL
1

BUTTON
163
307
233
340
MyColor 2
set-color \"2\"
NIL
1
T
OBSERVER
NIL
2
NIL
NIL
1

BUTTON
10
175
160
208
Color the Background
set-background
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
20
241
152
259
Set drawing color to...
11
0.0
0

BUTTON
8
264
151
297
Color now under mouse
set-color \"under-mouse\"
NIL
1
T
OBSERVER
NIL
M
NIL
NIL
1

BUTTON
7
306
152
339
Background color
set-color \"background\"
NIL
1
T
OBSERVER
NIL
B
NIL
NIL
1

MONITOR
14
352
99
397
Patch position
patch-position
0
1
11

MONITOR
119
351
193
396
Patch color
patch-color
3
1
11

@#$#@#$#@
## VERSION

1.1 (11/20/07): Fixed set-background to retain background color
1.0 (11/18/07): First release

## WHAT IS IT?

This is a paint program to create/modify a background pattern of patch colors.  Once such a pattern is created, it can be saved to a file and then later imported (using import-pcolors) into another NetLogo program.

## HOW TO USE IT

First: the default resolution of the screen is 35 x 35.  However, this can be changed by pressing the "Edit" button at the top of the visual area.  DO THIS FIRST!  Remember also to change the Patch Size (in pixels) so that the visual area will still fit onto the monitor.

Then press "Setup" and "Go".  Leave the Go button pressed while you go about your business, including loading and saving files.

After creating the coloring of the patches that you want, save the file.  You may thereaftrer load that saved file into another NetLogo project using the import-pcolors command.

## FILE TYPES

You can load any ordinary picture file of the following type: .JPG, .PNG, .GIF, .BMP.  However, when you press the "Save to file" button and save the file, ALWAYS give it a name with the suffix: .PNG.

## HOW TO LOAD THE PICTURE FILE

Let's suppose that you're finished with painting your scene and you've saved it in a file called _fred.png_.  You can, in the future, load that picture scene into another model using the NetLogo command:

**import-pcolors "fred.png"**

## CREDITS

Developed by Peter Brooks, Instructor, Stuyvesant High School, 2007
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
14
Circle -7500403 true false 0 0 300
Circle -16777216 true true 30 30 240

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

drawing point
true
0
Circle -1 true false -1 -1 301
Circle -16777216 true false 14 14 272
Circle -7500403 true true 29 29 242

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

full square
false
0
Rectangle -7500403 true true 0 0 300 300

full square 2
false
14
Rectangle -7500403 true false 0 0 300 300
Rectangle -16777216 true true 15 15 285 285

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

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3
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
