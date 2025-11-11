# --- Surface Plot with Contours ---

set terminal pngcairo size 1024,768 font "Arial,12"
set output "3d_surface_2.png"

set xrange [-5:5]
set yrange [-3:3]
set zrange [-5:5]

set xlabel "x"
set ylabel "y"
set zlabel "z"
set title "3D Surface: z(x,y) = sin(x)cos(y) + 0.2xy"

set contour base
set cntrparam levels 0.5
set style data lines

# Arrow and label at the actual maximum:
set arrow from 5,3,0 to 5,3,3.95 head lw 2 lc rgb "red"
set label "Max" at 5,3,4.3 font "Arial,14" tc rgb "red"

# Plot (using functions, not data file)
splot sin(x)*cos(y) + 0.2*x*y notitle
