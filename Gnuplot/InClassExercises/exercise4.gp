set ylabel "distance"
set xlabel "time"
set xrange [0:120]
set yrange [0:25]
set xtics 0,20,120 mirror
set ytics 0,5,25 mirror
set title "Evolution of the distance with respect to the initial position"
set key bottom right box
set border 15
set size square
fn1(x)=a1*x+b1
fn2(x)=a2*x+b2
fit [0:20] fn1(x) "e4.dades" using 1:(($3-$2)*0.72) via a1,b1
fit [60:120] fn2(x) "e4.dades" using 1:(($3-$2)*0.72) via a2,b2

plot "e4.dades" using 1:(($3-$2)*0.72) with points lc "green" pt 5 ps 1.5 title "dist", \
                fn1(x) lc "black" lw 5 title "fitting 0 to 20", \
                fn2(x) lc "goldenrod" lw 5 title "fitting 60 to 120"