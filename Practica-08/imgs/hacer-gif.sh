# cortar imágenes
mogrify -crop 655x365+210+10 +repage  *.png

# hacer gif
convert -delay 0.5 -loop 0 *.png urna-ehrenfest.gif
