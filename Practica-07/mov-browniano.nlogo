;; radio y masa se hacen propiedades de tortugas
;; en lugar de variables globales
turtles-own [ pos-x pos-y vel-x vel-y vel radio masa ]

;; se borran todas las variables globales
;; para calcular las propiedades macroscópicas
;; de los gases
globals [ delta-t ]

to setup
  clear-all

  set delta-t 0.01

  set-default-shape turtles "circle"

  ;; se crea la partícula A
  create-turtles 1 [
    set color white
    actualizar-valores
    set heading random 360
    set vel 0
    set vel-x 0
    set vel-y 0
    set pos-x 0
    set pos-y 0
    setxy pos-x pos-y
    pendown
  ]

  ;; se crean el resto de partículas
  create-turtles num-particulas - 1 [
    set color gray - 3
    actualizar-valores
    set heading random 360
    set vel random-float max-vel-inicial
    set vel-x vel * cos ( 90 - heading )
    set vel-y vel * sin ( 90 - heading )
    ;; para evitar que se sobrelapen las partículas
    ;; se define una función para posicionarlas
    posicionar-particula

    ;; se controla si se quiere que se vean o no las
    ;; partículas B
    ifelse mostrar-B? or who = 0 [ show-turtle ][ hide-turtle ]
  ]

  ;; para evitar que se sobrelapen las partículas con la partícula A
  ask turtle 0 [
    while [ any? other turtles in-radius radio ]
    [ ask other turtles in-radius radio [posicionar-particula ] ]
  ]

  reset-ticks
end

to actualizar-valores
  ifelse who = 0
  [ set radio radio-A
    set masa masa-A ]
  [ set radio radio-B
    set masa masa-B ]
  set size radio * 2
end

;; esta es una función recursiva que le busca una
;; posición a las partículas hasta que ya no se
;; sobrelapan con ninguna otra
to posicionar-particula
  set pos-x (one-of [ -1 1 ]) * (random-float max-pxcor)
  set pos-y (one-of [ -1 1 ]) * (random-float max-pycor)
  setxy pos-x pos-y
  if any? other turtles in-radius radio [ posicionar-particula ]
end

to go

  ;; se actualizan los valores de radio y masa
  ;; por si se modifican en tiempo real
  ask turtles [ actualizar-valores ]

  ask turtles [
    ifelse mostrar-B? or who = 0 [ show-turtle ][ hide-turtle ]
    ;; aquí se usa in-radius en lugar de distance ya que es más eficiente
    let particulas-colisiono sort other turtles in-radius radio with [ who > [ who ] of myself ]
    if particulas-colisiono != []
      [ foreach particulas-colisiono
        [ particula -> colisionar particula ]
      ]
  ]

  ask turtles [
    colision-pared
    actualizar-posicion ]

;    if ticks mod 2 = 0 [export-view ( word ("imgs/mov-browniano/img-") (agregar-ceros (word ticks "") 3) (".png")) ]

  tick
end

to colisionar [ otra-particula ]
  let dvx vel-x - [ vel-x ] of otra-particula
  let dvy vel-y - [ vel-y ] of otra-particula
  let drx pos-x - [ pos-x ] of otra-particula
  let dry pos-y - [ pos-y ] of otra-particula

  ;; se definen las masas
  let m1 masa
  let m2 [ masa ] of otra-particula

  ;; se agrega el término de la masa a las ecuaciones
  ;; para considerar su distinto tamaño
  set vel-x vel-x - (2 * m2 / (m1 + m2)) * ((dvx * drx + dvy * dry) / (drx ^ 2 + dry ^ 2)) * drx
  set vel-y vel-y - (2 * m2 / (m1 + m2)) * ((dvx * drx + dvy * dry) / (drx ^ 2 + dry ^ 2)) * dry

  ask otra-particula [
    set dvx (- dvx)
    set dvy (- dvy)
    set drx (- drx)
    set dry (- dry)
    set vel-x vel-x - (2 * m1 / (m1 + m2)) * ((dvx * drx + dvy * dry) / (drx ^ 2 + dry ^ 2)) * drx
    set vel-y vel-y - (2 * m1 / (m1 + m2)) * ((dvx * drx + dvy * dry) / (drx ^ 2 + dry ^ 2)) * dry
  ]
end

to colision-pared
  let proxima-pos-x pos-x + vel-x * delta-t
  let proxima-pos-y pos-y + vel-y * delta-t

  if abs proxima-pos-x >= max-pxcor
  [ set vel-x ( - vel-x ) ]

  if abs proxima-pos-y >= max-pycor
  [ set vel-y ( - vel-y ) ]

  set vel sqrt ( vel-x ^ 2 +  vel-y ^ 2 )
end

to actualizar-posicion
  set pos-x pos-x + vel-x * delta-t
  set pos-y pos-y + vel-y * delta-t
  setxy pos-x pos-y
end

to-report agregar-ceros [ cadena numero-ceros ]
  if length cadena >= numero-ceros [
    report cadena
  ]
  report agregar-ceros ( insert-item 0 cadena "0" ) numero-ceros
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
647
448
-1
-1
13.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
60
46
128
80
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
62
98
126
132
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

SLIDER
12
158
185
191
num-particulas
num-particulas
1
3000
3000.0
1
1
NIL
HORIZONTAL

SLIDER
13
195
186
228
max-vel-inicial
max-vel-inicial
0
100
50.0
1
1
NIL
HORIZONTAL

PLOT
646
298
894
448
velocidad
vel
frecuencia
0.0
200.0
0.0
10.0
true
false
"set-plot-x-range 0 2 * max-vel-inicial" ""
PENS
"default" 1.0 1 -16777216 true "" "histogram [ vel ] of turtles "

SLIDER
12
235
186
268
radio-A
radio-A
0
2
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
12
270
185
303
radio-B
radio-B
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
13
312
186
345
masa-A
masa-A
0.1
10
1.0
.1
1
NIL
HORIZONTAL

SLIDER
13
348
186
381
masa-B
masa-B
0.1
5
0.1
.1
1
NIL
HORIZONTAL

PLOT
647
10
895
160
pos x
tiempo
pos x
0.0
10.0
-16.0
16.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot [ pos-x ] of turtle 0"
"pen-1" 1.0 0 -7500403 true "" "plot 0"

PLOT
646
160
894
300
pos y
tiempo
pos y
0.0
10.0
-16.0
16.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot [pos-y] of turtle 0"
"pen-1" 1.0 0 -7500403 true "" "plot 0"

SWITCH
27
397
158
430
mostrar-B?
mostrar-B?
0
1
-1000

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
<experiments>
  <experiment name="presion-volumen" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="400"/>
    <metric>presion</metric>
    <metric>temperatura</metric>
    <metric>volumen</metric>
    <enumeratedValueSet variable="num-particulas">
      <value value="3000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-vel-inicial">
      <value value="50"/>
    </enumeratedValueSet>
    <steppedValueSet variable="tamanio-caja" first="10" step="10" last="100"/>
    <enumeratedValueSet variable="colisiones?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="presion-temperatura" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>presion</metric>
    <metric>volumen</metric>
    <metric>temperatura</metric>
    <enumeratedValueSet variable="num-particulas">
      <value value="3000"/>
    </enumeratedValueSet>
    <steppedValueSet variable="max-vel-inicial" first="0" step="10" last="100"/>
    <enumeratedValueSet variable="tamanio-caja">
      <value value="70"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="presion-volumen-isotemras" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="200"/>
    <metric>presion</metric>
    <metric>temperatura</metric>
    <metric>volumen</metric>
    <enumeratedValueSet variable="num-particulas">
      <value value="3000"/>
    </enumeratedValueSet>
    <steppedValueSet variable="max-vel-inicial" first="10" step="10" last="100"/>
    <steppedValueSet variable="tamanio-caja" first="10" step="10" last="100"/>
    <enumeratedValueSet variable="colisiones?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
1
@#$#@#$#@
