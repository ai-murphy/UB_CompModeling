set title "Figure 1"
set xrange[1:5]
set yrange[-1.5:4]
set linetype 3 lw 4
set linetype 2 lw 2
set key bottom center box outside horizontal
set xlabel "x"
set ylabel "y"
plot cos(x**2), atan(x)/x**2, sin(x)*exp(1/x)