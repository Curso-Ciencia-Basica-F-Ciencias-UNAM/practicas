turtles-own [ fx fy ax ay vx vy x y m ]

globals [ G centro-de-masa-x centro-de-masa-y ]

to setup
  clear-all
  set G 1
  set-default-shape turtles "circle"

  if cuerpo1? [
    create-turtles 1 [
      set m m1
      set x x1
      set y y1
      set vx vx1
      set vy vy1
      set size s1
  ]]

  if cuerpo2? [
    create-turtles 1 [
      set m m2
      set x x2
      set y y2
      set vx vx2
      set vy vy2
      set size s2
  ]]

  if cuerpo3? [
    create-turtles 1 [
      set m m3
      set x x3
      set y y3
      set vx vx3
      set vy vy3
      set size s3
  ]]

  ask turtles [ ajustar-posicion ]

  reset-ticks
end

to go
  ask turtles [ set fx 0 set fy 0 ]
  ask turtles [ actualizar-fuerza ]
  ask turtles [ actualizar-aceleracion ]
  ask turtles [ actualizar-velocidad ]
  ask turtles [ actualizar-posicion ]

  difuminar-trazo
  if recentrar? [ recentrar ]

;  if ticks mod 200 = 0 [ export-view ( word ("imgs/euler-caos/img-") ( agregar-ceros (word ticks "") 6) (".png" )) ]

  tick
end

to actualizar-fuerza
  ask other turtles [ sumame-a-tu-fuerza myself ]
end

to sumame-a-tu-fuerza [ otro-cuerpo ]
  let xd x - [ x ] of otro-cuerpo
  let yd y - [ y ] of otro-cuerpo
  let r sqrt (( xd ^ 2 ) + (yd ^ 2))
  let theta asin ( abs( yd ) / r )
  let f ( G * m * [ m ] of otro-cuerpo ) / ( r ^ 2 )

  ifelse xd > 0
  [ set fx fx - cos theta * f ]
  [ set fx fx + cos theta * f ]
  ifelse yd > 0
  [ set fy fy - sin theta * f ]
  [ set fy fy + sin theta * f ]
end

to actualizar-aceleracion
  set ax fx / m
  set ay fy / m
end

to actualizar-velocidad
  set vx vx + ( ax * delta-t )
  set vy vy + ( ay * delta-t )
end

to actualizar-posicion
  set x x + ( vx * delta-t )
  set y y + ( vy * delta-t )

  ajustar-posicion
end

to ajustar-posicion
  ifelse
  x * k <= max-pxcor and x * k >= min-pxcor and
  y * k <= max-pycor and y * k >= min-pycor
  [ setxy ( x * k ) ( y * k )
    show-turtle
    set pcolor color + 3

  ]
  [ hide-turtle ]
end

to recentrar
  set centro-de-masa-x sum [ m * x ] of turtles / sum [ m ] of turtles
  set centro-de-masa-y sum [ m * y ] of turtles / sum [ m ] of turtles

  ask turtles
  [ set x ( x - centro-de-masa-x )
    set y ( y - centro-de-masa-y )
    ajustar-posicion
  ]
end

to difuminar-trazo
  ask patches with [ pcolor != black ] [
    let nuevo-color pcolor - 8 * tasa-difuminar / 100
    ifelse ( shade-of? pcolor nuevo-color )
    [ set pcolor nuevo-color ]
    [ set pcolor black ]]
end


to-report agregar-ceros [ cadena numero-de-ceros  ]
  if length cadena >= numero-de-ceros [
    report cadena
  ]
  report agregar-ceros ( insert-item 0 cadena "0" ) numero-de-ceros
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
620
421
-1
-1
2.0
1
10
1
1
1
0
1
1
1
-100
100
-100
100
0
0
1
ticks
30.0

BUTTON
74
49
141
82
NIL
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
77
103
141
137
NIL
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

INPUTBOX
671
50
833
114
m1
1.0
1
0
Number

INPUTBOX
672
120
834
184
x1
0.8871256555
1
0
Number

INPUTBOX
673
192
835
256
y1
0.0
1
0
Number

INPUTBOX
676
265
838
329
vx1
0.0
1
0
Number

INPUTBOX
677
339
839
403
vy1
0.9374933545
1
0
Number

INPUTBOX
851
56
1013
120
m2
1.0
1
0
Number

INPUTBOX
848
125
1010
189
x2
-0.6530449215
1
0
Number

INPUTBOX
850
198
1012
262
y2
0.0
1
0
Number

INPUTBOX
852
267
1014
331
vx2
0.0
1
0
Number

INPUTBOX
852
339
1014
403
vy2
-1.7866975426
1
0
Number

INPUTBOX
677
409
839
473
s1
5.0
1
0
Number

INPUTBOX
852
408
1014
472
s2
5.0
1
0
Number

SWITCH
40
174
169
207
recentrar?
recentrar?
1
1
-1000

SLIDER
21
211
194
244
tasa-difuminar
tasa-difuminar
0
100
0.0
0.01
1
NIL
HORIZONTAL

BUTTON
41
266
180
300
2 orbitas iguales
set k 1\n\n;;;; cuerpo 1\nset cuerpo1? True\nset m1 200\nset x1 -40\nset y1 0\nset vx1 0\nset vy1 0\nset s1 10\n\n;;;; cuerpo 2\nset cuerpo2? True\nset m2 200\nset x2 40\nset y2 0\nset vx2 0\nset vy2 2\nset s2 10\n\n;;;; cuerpo 3\nset cuerpo3? False\n
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
61
311
151
345
sol-tierra
set k 1\n\n;;;; cuerpo 1\nset cuerpo1? True\nset m1 200\nset x1 0\nset y1 0\nset vx1 0\nset vy1 0\nset s1 20\n\n;;;; cuerpo 2\nset cuerpo2? True\nset m2 1\nset x2 60\nset y2 0\nset vx2 0\nset vy2 2\nset s2 5\n\n;;;;; cuerpo 3\nset cuerpo3? False
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
1019
56
1181
120
m3
1.0
1
0
Number

INPUTBOX
1024
130
1186
194
x3
-0.234080734
1
0
Number

INPUTBOX
1020
204
1182
268
y3
0.0
1
0
Number

INPUTBOX
1025
275
1187
339
vx3
0.0
1
0
Number

INPUTBOX
1029
347
1191
411
vy3
0.849204188
1
0
Number

INPUTBOX
1025
422
1187
486
s3
5.0
1
0
Number

SWITCH
672
10
792
43
cuerpo1?
cuerpo1?
0
1
-1000

SWITCH
854
10
974
43
cuerpo2?
cuerpo2?
0
1
-1000

SWITCH
1018
14
1138
47
cuerpo3?
cuerpo3?
0
1
-1000

BUTTON
43
354
167
388
sol-tierra-luna
set k 1\n\n;;; cuerpo 1\nset cuerpo1? True \nset m1 199 \nset vx1 0 \nset vy1 0 \nset x1 0  \nset y1 0\nset s1 20 \n;;; cuerpo 2\nset cuerpo2? True \nset m2 1\nset vx2 0 \nset vy2 1.6 \nset x2 60  \nset y2 0\nset s2 5\n;;; cuerpo 3\nset cuerpo3? True\nset m3 0.5\nset vx3 0 \nset vy3 2 \nset x3 65  \nset y3 0\nset s3 2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
506
426
668
490
k
100.0
1
0
Number

BUTTON
48
425
127
459
figura8
set k 40\n\n;;; cuerpo 1\nset cuerpo1? True\nset m1 1\nset x1 -1\nset y1 0\nset vx1 0.347111\nset vy1 0.532728\nset s1 5\n\n;;; cuerpo 2\nset cuerpo2? True\nset m2 1\nset x2 1\nset y2 0\nset vx2 0.347111\nset vy2 0.532728\nset s2 5\n\n;;; cuerpo 3\nset cuerpo3? True\nset m3 1\nset x3 0\nset y3 0\nset vx3 -0.694222\nset vy3 -1.065456\nset s3 5
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
48
458
112
492
BA2
set k 40\n\n;;; cuerpo 1\nset cuerpo1? True\nset m1 1\nset x1 0.3361300950\nset y1 0\nset vx1 0\nset vy1 1.5324315370\nset s1 5\n\n;;; cuerpo 2\nset cuerpo2? True\nset m2 1\nset x2 0.7699893804\nset y2 0\nset vx2 0\nset vy2 -0.6287350978\nset s2 5\n\n;;; cuerpo 3\nset cuerpo3? True\nset m3 1\nset x3 -1.1061194753\nset y3 0\nset vx3 0\nset vy3 -0.9036964391\nset s3 5
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
321
434
483
498
delta-t
1.0E-4
1
0
Number

BUTTON
143
431
209
465
euler
;;; parametros generales\nset delta-t 0.01\nset k 50\n\n;;; cuerpo 1\nset cuerpo1? True \nset m1 1 \nset vx1 0\nset vy1 ( - 1 )\nset x1 -1\nset y1 0\nset s1 5\n;;; cuerpo 2\nset cuerpo2? True \nset m2 1\nset vx2 0 \nset vy2 0\nset x2 0\nset y2 0\nset s2 5\n;;; cuerpo 3\nset cuerpo3? True\nset m3 1\nset vx3 0 \nset vy3 1\nset x3 1\nset y3 0\nset s3 5
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
209
432
291
466
larange
;;; parametros generales\nset delta-t 0.001\nset k 30\nlet v 0.5\n\n;;; cuerpo 1\nset cuerpo1? True \nset m1 1 \nset vx1 v\nset vy1 0\nset x1 0\nset y1 1\nset s1 5\n;;; cuerpo 2\nset cuerpo2? True \nset m2 1\nset vx2 ( - v * sin 30 )\nset vy2 ( - v * cos 30 )\nset x2  ( ( sqrt 3 ) / 2 )\nset y2  (- 1 / 2)\nset s2 5\n;;; cuerpo 3\nset cuerpo3? True\nset m3 1\nset vx3 (- v * sin 30)\nset vy3 (  v * cos 30)\nset x3  (- ( sqrt 3 ) / 2)\nset y3  (- 1 / 2)\nset s3 5
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
150
477
216
510
BA15
;;; parametros generales\nset g 1\nset delta-t 0.001\nset k 20\n\n;;; cuerpo 1\nset cuerpo1? True \nset m1 1 \nset vx1 0\nset vy1 0.8042120498\nset x1 -1.1889693067\nset y1 0\nset s1 5\n;;; cuerpo 2\nset cuerpo2? True \nset m2 1\nset vx2 0 \nset vy2 0.0212794833\nset x2 3.8201881837\nset y2 0\nset s2 5\n;;; cuerpo 3\nset cuerpo3? True\nset m3 1\nset vx3 0 \nset vy3 -0.8254915331\nset x3 -2.6312188770\nset y3 0\nset s3 5
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
1242
250
1328
283
Henon 7
;;; parametros generales\nset delta-t 0.001        \nset k 40              \n\n;;; cuerpo 1\nset cuerpo1? True\nset m1 1\nset vx1 0       \nset vy1 2.7626477723            \nset x1 -0.8961968933             \nset y1 0              \nset s1 5\n\n;;; cuerpo 2\nset cuerpo2? True\nset m2 1\nset vx2 0          \nset vy2 0.1880576473            \nset x2 1.9096454316              \nset y2 0              \nset s2 5\n\n;;; cuerpo 3\nset cuerpo3? True\nset m3 1\nset vx3 0           \nset vy3 -2.9507054196           \nset x3 -1.0134485383              \nset y3 0              \nset s3 5
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
1238
327
1355
360
Broucke A 15
       ;; <- poner valor\nset k 20               ;; <- poner valor\nset delta-t 0.0001\n;;; cuerpo 1\nset cuerpo1? True\nset m1 1\nset vx1 0              ;; <- poner valor\nset vy1 0.8285556923             ;; <- poner valor\nset x1 -0.8965015243             ;; <- poner valor\nset y1 0              ;; <- poner valor\nset s1 5\n;;; cuerpo 2\nset cuerpo2? True \nset m2 1\nset vx2 0              ;; <- poner valor\nset vy2 -0.0056478094             ;; <- poner valor\nset x2 3.2352526189               ;; <- poner valor\nset y2 0              ;; <- poner valor\nset s2 5\n;;; cuerpo 3\nset cuerpo3? True\nset m3 1\nset vx3 0             ;; <- poner valor\nset vy3 -0.8229078829             ;; <- poner valor\nset x3 -2.3387510946             ;; <- poner valor\nset y3 0              ;; <- poner valor\nset s3 5
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
1241
374
1354
407
BUTTERFLY I
set k 90\n\nset delta-t 0.0002333\n\n\n;;; cuerpo 1\n\nset cuerpo1? True\n\nset m1 1\n\nset x1 -1\n\nset y1 0\n\nset vx1 0.306893\n\nset vy1 0.125507\n\nset s1 5\n\n\n;;; cuerpo 2\n\nset cuerpo2? True\n\nset m2 1\n\nset x2 1\n\nset y2 0\n\nset vx2 0.306893\n\nset vy2 0.125507\n\nset s2 5\n\n\n;;; cuerpo 3\n\nset cuerpo3? True\n\nset m3 1\n\nset x3 0\n\nset y3 0\n\nset vx3 -0.613786\n\nset vy3 -0.251014\n\nset s3 5
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
1243
421
1324
454
MOTH I
;;; parametros generales\nset delta-t 0.001\nset k 50\n\n;;; cuerpo 1\nset cuerpo1? True \nset m1 1 \nset vx1 0.464445\nset vy1 0.39606\nset x1 -1\nset y1 0\nset s1 5\n\n;;; cuerpo 2\nset cuerpo2? True \nset m2 1\nset vx2 0.464445\nset vy2 0.39606\nset x2 1\nset y2 0\nset s2 5\n\n;;; cuerpo 3\nset cuerpo3? True\nset m3 1\nset vx3 -0.92889\nset vy3 -0.79212\nset x3 0\nset y3 0\nset s3 5
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
1419
258
1514
291
Dragonfly
;; parametros generales\n\nset delta-t 0.0001        \n\nset k 40               \n\n\n;;; cuerpo 1\n\nset cuerpo1? True\n\nset m1 1\n\nset vx1 0.080584           \n\nset vy1 0.588836           \n\nset x1 -1           \n\nset y1 0     \n\nset s1 5\n\n;;; cuerpo 2\n\nset cuerpo2? True \n\nset m2 1\n\nset vx2 0.080584          \n\nset vy2 0.588836          \n\nset x2 1             \n\nset y2 0            \n\nset s2 5\n\n;;; cuerpo 3\n\nset cuerpo3? True\n\nset m3 1\n\nset vx3 -0.161168           \n\nset vy3 -1.177672        \n\nset x3 0          \n\nset y3 0      \n\nset s3 5\n\n\n
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
1418
328
1550
361
Draongfly II.6.A
set delta-t  0.001    \nset k  50             \n\n;;; cuerpo 1\nset cuerpo1? True\nset m1 1\nset vx1 0.186238      \nset vy1 0.578714      \nset x1 -1             \nset y1  0             \nset s1 7\n;;; cuerpo 2\nset cuerpo2? True \nset m2 1\nset vx2 0.186238           \nset vy2 0.578714             \nset x2 1              \nset y2 0              \nset s2 7\n;;; cuerpo 3\nset cuerpo3? True\nset m3 1\nset vx3 -0.372476             \nset vy3 -1.157428             \nset x3 0             \nset y3 0              \nset s3 7
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
1418
371
1535
404
 BUMBLEBEE
;;; parametros generales\n\nset delta-t 0.0001\n\nset k 50\n\n\n;;; cuerpo 1\n\nset cuerpo1? True \n\nset m1 1 \n\nset vx1 0.184279\n\nset vy1 0.587188\n\nset x1 ( -1)\n\nset y1 0\n\nset s1 5\n\n;;; cuerpo 2\n\nset cuerpo2? True \n\nset m2 1\n\nset vx2 0.184279 \n\nset vy2 0.587188\n\nset x2 1\n\nset y2 0\n\nset s2 5\n\n;;; cuerpo 3\n\nset cuerpo3? True\n\nset m3 1\n\nset vx3 (-0.368558) \n\nset vy3 (-1.174376)\n\nset x3 0\n\nset y3 0\n\nset s3 5
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
1435
435
1512
468
IVa.4.A
;;; parametros generales\n\nset delta-t 0.001         \n\nset k 70               \n\n\n;;; cuerpo 1\n\nset cuerpo1? True\n\nset m1 1\n\nset vx1 0.439166           \n\nset vy1 0.452968           \n\nset x1 -1              \n\nset y1 0             \n\nset s1 5\n\n;;; cuerpo 2\n\nset cuerpo2? True \n\nset m2 1\n\nset vx2 0.439166              \n\nset vy2 0.452968            \n\nset x2 1              \n\nset y2 0              \n\nset s2 5\n\n;;; cuerpo 3\n\nset cuerpo3? True\n\nset m3 1\n\nset vx3 -0.878332           \n\nset vy3 -0.905936            \n\nset x3 0              \n\nset y3 0              \n\nset s3 5
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
1412
161
1520
194
Broucke R 8
;;;; parametros generales\n\nset k 100\n\nset delta-t 0.0001\n\n\n;;; cuerpo 1\n\nset cuerpo1? True\n\nset m1 1\n\nset x1 0.8871256555\n\nset y1 0\n\nset vx1 0\n\nset vy1 0.9374933545\n\nset s1 5\n\n\n;;; cuerpo 2\n\nset cuerpo2? True\n\nset m2 1\n\nset x2 -0.6530449215\n\nset y2 0\n\nset vx2 0\n\nset vy2 -1.7866975426\n\nset s2 5\n\n\n;;; cuerpo 3\n\nset cuerpo3? True\n\nset m3 1\n\nset x3 -0.2340807340\n\nset y3 0\n\nset vx3 0\n\nset vy3 0.8492041880\n\nset s3 5
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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
NetLogo 6.3.0
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
