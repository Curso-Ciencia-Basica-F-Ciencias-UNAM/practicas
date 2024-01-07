# cortar imágenes
mogrify -crop 597x256+278+48 +repage *.png


# hacer gif
convert -delay 2 -loop 0 *.png 1D.gif
