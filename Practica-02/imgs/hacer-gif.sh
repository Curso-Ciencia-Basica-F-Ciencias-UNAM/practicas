# cortar imágenes
mogrify -crop 610x458+237+17 +repage *.png
# hacer gif
convert -delay 2 -loop 0 *.png resorte.gif
