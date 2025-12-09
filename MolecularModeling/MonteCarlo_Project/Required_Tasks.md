1. Implement the Metropolis algorithm (with single-spin flip Glauber dynamics and random updating) for the Ising model without magnetic field, defined by the energy function $E = −\sum_ {\langle i,j \rangle} S_iS_j$, on the two-dimensional square lattice of linear size $L$ with $N = L^2$ spins, using periodic (toroidal) boundary conditions and nearest-neighbour interactions. The code must have the following input/output:

      Input:
      - L (linear size of the lattice)
      - T (temperature),
      - $n_{MCS}$ (total number of MCS, where 1 MCS = $N$ attempted spin flips). (I repeat: 1 MCS = $N$ attempted spin flips, not **one** attempted spin flip!)
      - $n_{meas}$ (number of MCS between two successive measurements), seed of the random number generator.
      
      Note: $L$ can either be specified at compile time (for example with a Makefile) or at run time (in the latter case, dynamical allocation should be used, in order not to waste memory).
      
      Output: time series for the magnetization $M =\sum_{i=1,N} S_i$ and the energy $E$ every $n_{meas}$ MC steps (length of the time series = $n_{MCS}/n_{meas}$).
      
      The program must be structured with the following separate functions (or subroutines in Fortran):
      - a) - input (which can be contained in the main program)
      - b) - output
      - c) - initialization of the lattice (geometry);
      - d) - Monte Carlo update
      - e) - measurement of the observables M, E.
      
      The Monte Carlo update should be independent of the geometry, i.e. it should work also in three dimensions, for a triangular    lattice, for the square lattice with the nextnearest neighbors, etc. The only information about the geometry of the lattice should be contained in an array listing the neighbors of each site. This array should be created in the function c) above.


2. Report the speed of the Monte Carlo update, expressed in number of attempted spin flips per second.

3. Write a code that groups the data in a time series into “bins” of size $m$ and computes the statistical error of the average of the binned data, for different values of $m$ = 1, 2, 4, 8, 16, 32, . . . (the largest value of $m$ should be such that there are of order 100
bins).

4. To test the correctness of your MC code, perform a simulation with $L = 20$, $T = 2.0$, $n_{meas} = 10$ starting with random initial conditions. Try at least with $n_{MCS} = 10^8$ (this allows to estimate $<E>/L^2$ with a relative statistical error of less than $10^−5$).

    Discarding the first $10^3$ MCS, compute the sample average $\overline{E}$. Use your binning code, plot the statistical error of $\overline{E}$ as a function of $m$. From this, report your final estimate of $\langle E \rangle/L^2$ **with its statistical error** (standard deviation). Comment on whether your estimate agrees, **within its statistical error**, with the $\emph{exact}$ value given by Ferdinand and Fisher $\langle E \rangle/L^2 = −1.7455571250$... for $L = 20$ and $T = 2.0$. Agreement is necessary for your code to be correct. The larger $n_{MCS}$ the more stringent the test will be. If there is still no agreement after carefully checking the code, try with a different random number generator. If this still fails, contact me. You can also try different temperatures.

5. After the code has passed the Ferdinand-Fisher test above, perform “production runs” for $L = 100$, and at least these three values of the temperature: $T = 2.0$, $T = 2.27$, $T = 2.6$, starting from a random initial configuration. Use $n_{meas} = 10$ and at least $n_{MCS} = 10^6$ (for compiled codes, $n_{MCS} = 10^6$ should be possible). If you have sufficient computer time, you can try to do the simulations for $2.0 ≤ T ≤ 3.0$ in steps $∆T = 0.1$.

6. Plot the time series for $E$ and $M$ (not $|M|$ !) for the three temperatures above for the first $10^3$ MCS, and for the first $10^6$ MCS (in this case plot no more than one point every 100 data so you don’t have too many points). Give your interpretation of these plots. Plot the time series for $L = 20$ for $M$ (not $|M|$ !) at $T = 2.0$ for $n_{MCS} = 10^6$ (one point every 100 data) and comment on the difference with that for $L = 100$.

7. Use the binning code to compute, for the three temperatures above, $\langle E \rangle$ and $\langle |M| \rangle$, and the statistical errors of the binned data. Plot this error as a function of m for both quantities at each temperature. From this plot, obtain your final estimate of the statistical error on $\langle E \rangle$, $\langle |M| \rangle$, and estimate the autocorrelation time of $E$ and $|M|$. Comment on the dependence of the autocorrelation time on temperature.

8. Plot $\langle E \rangle/N$ and $\langle |M| \rangle/N$, **with their statistical error**, as a function of the temperature. Give an intepretation of the plots.

**Important**: in all the plots, $M$ and $E$ should be normalized by $N$.
