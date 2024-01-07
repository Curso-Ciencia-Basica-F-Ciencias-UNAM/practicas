# cortar imágenes
mogrify -crop 582x493+258+13 +repage *.png
# hacer gif
convert -delay 2 -loop 0 *.png parabolico.gif
