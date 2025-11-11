#!/usr/bin/env gnuplot

# Configure output
set terminal pngcairo size 1024,768 font "Arial,12"
set output '2d_contour.png'

# Set 2D view (flat/map view)
set view map

# Set ranges
set xrange [-5:5]
set yrange [-3:3]

# Configure contours
set contour base
set cntrparam levels 0.5

# Label axes
set xlabel "x" offset 0,0,0
set ylabel "y" offset 0,0,0

# Title
set title "2D Contour Plot: z(x,y) = sin(x)cos(y) + 0.2xy"

# Add arrow to maximum (now in 2D coordinates)
set arrow 1 from 4.7, 2.7 to 5, 3 head lw 2 lc rgb "red"
set label "Max" at 5, 3 font "Arial,14" textcolor rgb "red"

# Plot the data as 2D contour
splot 'values.dat' with lines lc rgb "blue" title "Level Curves"