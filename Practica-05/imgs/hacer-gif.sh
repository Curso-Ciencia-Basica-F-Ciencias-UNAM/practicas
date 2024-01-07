# cortar imágenes
mogrify -crop 578x419+210+10 +repage  *.png

# hacer gif
convert -delay 0.5 -loop 0 *.png espectros-hidrogeno.gif
