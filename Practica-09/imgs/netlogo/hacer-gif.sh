# cortar imágenes
mogrify -crop 355x506+400+13 +repage *.png

# hacer gif
convert -delay 0.5 -loop 0 *.png cinetica-enzimatica.gif
