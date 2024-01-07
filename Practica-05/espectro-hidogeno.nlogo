breed [ nucleos nucleo ]
breed [ electrones electron ]
breed [ fotones foton ]

electrones-own [ nivel-energia ]
fotones-own [ long-onda-foton cambio-nivel absorber? ]
patches-own [ long-onda-parche espectrometro ]


globals [
  ajuste-x-pos ;; variable para mapear las coordenadas del parche a una longitud de onda
  radio
  aumento-radio
  longitud-paso
]

to setup
  clear-all

  set ajuste-x-pos 580
  set aumento-radio 15
  set longitud-paso 10

  crear-atomo
  crear-espectrometros

  reset-ticks
end


to go
  ask electrones [ orbitar ]
  ask fotones [ fd longitud-paso ]
  revisar-absorcion
  revisar-emision

;  export-interface ( word ("imgs/img-") (agregar-ceros (word ticks "") 3) (".png" ))
  tick
end

to revisar-emision
  ask patches with [ pycor = max-pycor ][
    if any? fotones-here [
      ask patches with [ espectrometro = "emision" and long-onda-parche = [ long-onda-parche ] of myself ]
      [ set pcolor obtener-color long-onda-parche ]
    ]
  ]
end


to revisar-absorcion
  ask patch 0 0 [
    let foton-para-absorber one-of fotones with [ absorber? = True ] in-radius radio
    if foton-para-absorber != nobody [
      ask one-of electrones [ subir-nivel [ cambio-nivel ] of foton-para-absorber  ]
      ask foton-para-absorber [ die ]
    ]
  ]
end

to subir-nivel [ nuevo-nivel ]
  let delta-nivel nuevo-nivel - nivel-energia
  lt 90
  fd abs delta-nivel * aumento-radio
  rt 90
  set nivel-energia nuevo-nivel
  set radio ( nivel-energia * aumento-radio )
end

to orbitar
  let theta longitud-paso * 180 / ( pi * radio )
  rt theta / 2
  fd longitud-paso
  rt theta / 2
end

to cambiar-nivel
  let delta-nivel ( nivel  - [ nivel-energia ] of one-of electrones )
  let energia-final calcular-energia nivel
  let energia-inicial calcular-energia [ nivel-energia ] of one-of electrones
  let delta-energia energia-final - energia-inicial
  let long-onda energia-a-long-onda abs delta-energia

  if delta-nivel > 0
  [ crear-foton-para-absorber long-onda nivel ]
  if delta-nivel < 0
  [ crear-foton-para-emitir long-onda nivel
    ask electrones [ bajar-nivel nivel ]
  ]
end

to bajar-nivel [ nuevo-nivel ]
  let delta-nivel nuevo-nivel - nivel-energia
  rt 90
  fd abs delta-nivel * aumento-radio
  lt 90
  set nivel-energia nuevo-nivel
  set radio ( nivel-energia * aumento-radio )
end

to crear-foton-para-emitir [ long-onda nivel-final ]
  ask electrones [
    hatch-fotones 1 [
      set color obtener-color long-onda
      set long-onda-foton long-onda
      set absorber? False
      set label long-onda
      facexy calcular-pos-x-foton long-onda max-pycor
      penup
    ]
  ]
end


to crear-foton-para-absorber [ long-onda nivel-final ]
  create-fotones 1 [
    set color obtener-color long-onda
    set long-onda-foton long-onda
    set cambio-nivel nivel-final
    set absorber? True
    set label long-onda
    setxy calcular-pos-x-foton long-onda min-pycor
    facexy 0 0
  ]
  ask patches with [ espectrometro = "absorcion" and long-onda-parche = long-onda ]
  [ set pcolor black ]
end

to-report calcular-pos-x-foton [ long-onda ]
  let pos-x-foton long-onda - ajuste-x-pos
  if long-onda > 781 [ set pos-x-foton max-pxcor ]
  if long-onda < 380 [ set pos-x-foton min-pxcor ]
  report pos-x-foton
end

to-report calcular-energia [ n ]
  let R 3.29e+15
  let h 6.626e-34
  report ( - ((Z ^ 2) * h * R) / ( n ^ 2))
end

to-report energia-a-long-onda [ energia ]
  let h 6.626e-34
  let c 299792458
  ifelse energia = 0
  [ report 0 ]
  [ report precision ((( c * h ) / energia ) * 1e9 ) 0 ]
end

to crear-atomo
  create-nucleos 1 [
    set shape "circle"
    set color red
    set size 20
  ]
  create-electrones 1 [
    set shape "circle"
    set color gray
    set size 10
    set heading 180
    set nivel-energia nivel
    set radio nivel-energia * aumento-radio
    setxy radio 0
    pendown
  ]
end


to crear-espectrometros
  ask patches [
    set long-onda-parche pxcor + ajuste-x-pos
    if pycor < min-pycor + 40 [
      set pcolor obtener-color long-onda-parche
      set espectrometro "absorcion" ]
    if pycor > max-pycor - 40 [
      set pcolor gray - 3
      set espectrometro "emision" ]
  ]
end

to graficar-niveles
  set-current-plot "energia"
  let niveles [ 1 2 3 4 5 6 7 8 9 10 ]
  let eV 1.602e-19
  foreach niveles [
    n ->
    set-current-plot-pen ( word "" n )
    plot-pen-up
    plotxy 0 ( calcular-energia n ) / eV
    plot-pen-down
    plotxy 1 ( calcular-energia n ) / eV
  ]
end



to-report agregar-ceros [ cadena numero-ceros ]
  if length cadena >= numero-ceros [
    report cadena
  ]
  report agregar-ceros ( insert-item 0 cadena "0" ) numero-ceros
end




;; Función para convertir de longitud de onda a rgb
;; tomada de: https://stackoverflow.com/questions/1472514/convert-light-frequency-to-rgb
to-report obtener-color [ longitud-de-onda ]
  let gamma 0.8
  let intensidad 255
  let factor 1
  let rojo 0
  let verde 0
  let azul 0

  if (( longitud-de-onda >= 380) and (longitud-de-onda < 440))
  [ set rojo (- (longitud-de-onda - 440) / (440 - 380))
    set verde 0
    set azul 1 ]
  if (( longitud-de-onda >= 440) and (longitud-de-onda < 490))
  [ set rojo 0
    set verde (longitud-de-onda - 440) / (490 - 440)
    set azul 1 ]
  if (( longitud-de-onda >= 490) and (longitud-de-onda < 510))
  [ set rojo 0
    set verde 1
    set azul (- (longitud-de-onda - 510) / (510 - 490)) ]
  if (( longitud-de-onda >= 510) and (longitud-de-onda < 580))
  [ set rojo (longitud-de-onda - 510) / (580 - 510)
    set verde 1
    set azul 0 ]
  if (( longitud-de-onda >= 580) and (longitud-de-onda < 645))
  [ set rojo 1
    set verde (- (longitud-de-onda - 645) / (645 - 580))
    set azul 0 ]
  if (( longitud-de-onda >= 645) and (longitud-de-onda < 781))
  [ set rojo 1
    set verde 0
    set azul 0 ]
  if ( longitud-de-onda >= 781 )
  [ set rojo 0
    set verde 0
    set azul 0 ]
  if (longitud-de-onda < 380)
  [ set rojo 0
    set verde 0
    set azul 0 ]

  if ((longitud-de-onda >= 380) and (longitud-de-onda < 420))
  [ set factor 0.3 + 0.7 * ( longitud-de-onda - 380) / ( 420 - 380) ]
  if ((longitud-de-onda >= 420) and (longitud-de-onda < 701))
  [ set factor 1 ]
  if ((longitud-de-onda >= 701) and (longitud-de-onda < 781))
  [ set factor 0.3 + 0.7 * ( 780 - longitud-de-onda) / ( 780 - 700) ]

  if rojo != 0  [ set rojo ((rojo * factor) ^ gamma ) * intensidad ]
  if verde != 0 [ set verde ((verde * factor) ^ gamma ) * intensidad ]
  if azul != 0  [ set azul ((azul * factor) ^ gamma ) * intensidad ]

  report (list rojo verde azul)
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
629
430
-1
-1
1.0
1
10
1
1
1
0
0
0
1
-205
205
-205
205
1
1
1
ticks
30.0

BUTTON
78
35
145
68
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

SLIDER
30
133
203
166
nivel
nivel
1
10
2.0
1
1
NIL
HORIZONTAL

INPUTBOX
33
174
195
236
Z
1.0
1
0
Number

BUTTON
80
80
144
114
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

BUTTON
54
274
174
308
NIL
cambiar-nivel
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
628
10
788
429
energia
NIL
eV
0.0
1.0
-14.0
0.0
true
false
"" "clear-plot \ngraficar-niveles"
PENS
"energia" 1.0 2 -16777216 true "" "plotxy 0.5 [(calcular-energia nivel-energia)] of one-of electrones / 1.602e-19"
"1" 1.0 0 -7500403 true "" ""
"2" 1.0 0 -2674135 true "" ""
"3" 1.0 0 -955883 true "" ""
"4" 1.0 0 -6459832 true "" ""
"5" 1.0 0 -1184463 true "" ""
"6" 1.0 0 -10899396 true "" ""
"7" 1.0 0 -13840069 true "" ""
"8" 1.0 0 -14835848 true "" ""
"9" 1.0 0 -11221820 true "" ""
"10" 1.0 0 -13791810 true "" ""

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
