#!/usr/bin/gnuplot

# Configure output
set terminal png size 800,600 enhanced
set output 'plot2.png'

#set key at screen 1, 0.9 right top vertical Right noreverse enhanced autotitle nobox

# Labels and title
set xlabel 'X' font "Arial,12"
set ylabel 'Y' font "Arial,12"
set zlabel 'Z' font "Arial,12"
set title 'z = cos(x³ - y) - sin(x + y)' font "Arial,14"

# Viewing angle (50° elevation, 60° azimuth)
set view 50,60

# Enable contours at the base
set contour both
set cntrparam levels 10
#unset surface

# Surface styling - gray palette
#set style data lines
set style data pm3d
set palette gray

# Legend configuration
set key bottom left title "Waves" font "Arial,11"

# Margins for better spacing
set lmargin 10
set rmargin 10
set tmargin 5
set bmargin 5

# Plot with surface and contours
set dgrid3d 30,60
#splot 'values.dat' using 1:2:3 with pm3d notitle, \
#      'values.dat' using 1:2:3 with lines lc black lw 0.5 notitle
splot sin(x)*cos(y) + 0.2*x*y with lines, sin(x)*cos(y) + 0.2*x*y notitle

# Keep window open (for interactive terminal)
# pause -1