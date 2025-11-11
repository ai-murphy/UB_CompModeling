#!/usr/bin/env gnuplot

# Configure output
set terminal pngcairo size 1024,768 font "Arial,12"
set output '3d_surface.png'

# Set ranges
set xrange [-5:5]
set yrange [-3:3]
set zrange [-5:5]

# Configure contours
set contour base
set cntrparam levels 0.5
set style increment default

# Label axes
set xlabel "x" offset 0,0,0
set ylabel "y" offset 0,0,0
set zlabel "z" offset 0,0,0

# Title
set title "3D Surface Plot: z(x,y) = sin(x)cos(y) + 0.2xy"

# Add arrow pointing to maximum
set arrow 1 from 5, 3, 2 to 5, 3, 3.95 head lw 2 lc rgb "red"
set label "Max" at 5.5, 2.5, 1.95 font "Arial,14" textcolor rgb "red"

# Plot the data
splot 'values.dat' with lines lc rgb "blue" title "z(x,y)"