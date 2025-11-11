# --- 2D Contour Plot ---

set terminal pngcairo size 1024,768 font "Arial,12"
set output "2d_contour_2.png"

set view map
set xrange [-5:5]
set yrange [-3:3]
set xlabel "x"
set ylabel "y"
set title "2D Contour: z(x,y) = sin(x)cos(y) + 0.2xy"

set contour base
set cntrparam levels 0.5
unset surface

# Arrow and label for maximum location
set arrow from 4.2,2.7 to 5,3 head lw 2 lc rgb "red"
set label "Max" at 4,2.5 font "Arial,14" tc rgb "red"

# Plot as contours (using function)
splot sin(x)*cos(y) + 0.2*x*y notitle
