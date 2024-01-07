# cortar imágenes
mogrify -crop 689x435+211+12 +repage  *.png

# hacer gif
convert -delay 0.5 -loop 0 *.png cinetica-gases.gif
