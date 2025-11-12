set yrange [-0.6:1]
set xrange [0:10]
set key box title "Functions" reverse
set xlabel "x"
set ylabel "y"
set title "Figure 2"
plot sin(x)*cos(x) with linespoints pt 5 ps 1, 2/(x+1) lw 3