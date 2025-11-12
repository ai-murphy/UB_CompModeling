set ylabel "%"
set xlabel "time (day)"
set xrange [0:28]
set yrange [0:100]
set xtics 0,3,27 nomirror
set ytics 0,25,100 nomirror
set border 3
set title "Time evolution of A, B and C"
set key bottom center outside horizontal
set size ratio .45
Cfit(x)=a*x**2+b*x
fit Cfit(x) "e3.dades" using 1:(100*$4/($2+$3+$4)) via a,b

plot "e3.dades" using 1:($2*100/($2+$3+$4)) with linespoints lw 2 lc rgb "red" pt 5 ps 2.5 title "A", \
             "" using 1:($3*100/($2+$3+$4)) with linespoints lw 2 lc rgb "green" pt 7 ps 2.5 title "B", \
             "" using 1:($4*100/($2+$3+$4)) with linespoints lw 2 lc rgb "blue" pt 9 ps 3 title "C", \
                Cfit(x) lc rgb "blue" lw 4 title "Cfit"
