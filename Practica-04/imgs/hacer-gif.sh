# cortar imágenes
mogrify -crop 513x213+302+30 +repage *.png


# hacer gif
convert -delay 1 -loop 0 *.png trafico-fantasma.gif
