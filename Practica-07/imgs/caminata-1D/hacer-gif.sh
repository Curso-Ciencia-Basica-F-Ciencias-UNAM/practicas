# cortar imágenes
mogrify -crop 810x238+215+46 +repage  *.png

# hacer gif
convert -delay 0.5 -loop 0 *.png caminata-1D.gif
