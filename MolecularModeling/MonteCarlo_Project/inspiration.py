import numpy as np
import matplotlib.pyplot as plt
from collections import defaultdict
import time

# ==============================================================================
# TASK 1: INPUT - Parameters for the simulation (Required_Tasks 1.a)
# ==============================================================================
"""
These parameters control the Metropolis algorithm simulation:
- L: linear size of square lattice (total sites N = L²)
- T: temperature in units of J/k_B
- n_MCS: total number of Monte Carlo Steps (1 MCS = N attempted spin flips)
- n_meas: measurement frequency (measure every n_meas MCS)
- seed: random number generator seed for reproducibility
"""

# Example parameters - can be modified for different tests
L = 10                    # Linear lattice size
N = L**2                  # Total number of spins = 100
T = 2.0                   # Temperature
n_MCS = 10000             # Total Monte Carlo steps
n_meas = 25               # Measure every 25 MCS
seed = 42                 # Random seed

np.random.seed(seed)

# ==============================================================================
# TASK 1c: LATTICE GEOMETRY - Create neighbor array
# ==============================================================================
"""
Required_Tasks 1.c: Initialization of lattice geometry

Creates a neighbor array where nbr[i, j] gives the j-th neighbor of spin i.
Uses periodic boundary conditions (toroidal topology).
The Monte Carlo update uses ONLY this array, making it geometry-independent.
"""

def create_nbr(L):
    """
    Build neighbor list for 2D square lattice with periodic boundary conditions.
    
    Parameters:
        L: linear size of lattice
    
    Returns:
        nbr: (N, 4) array where nbr[i, :] = [right, left, above, below] neighbors
    
    Note: This is the ONLY place where lattice geometry is hardcoded.
    The MC update function uses nbr without knowing it's a 2D square lattice.
    """
    nbr = np.zeros(shape=(L**2, 4), dtype=int)
    
    # Periodic boundary conditions: next and previous indices wrap around
    ip = np.arange(L) + 1      # indices shifted right
    im = np.arange(L) - 1      # indices shifted left
    ip[L - 1] = 0              # rightmost wraps to leftmost
    im[0] = L - 1              # leftmost wraps to rightmost
    
    for x in range(L):
        for y in range(L):
            i = x + y * L      # 1D index for spin at position (x, y)
            nbr[i, 0] = ip[x] + y * L      # right neighbor
            nbr[i, 1] = im[x] + y * L      # left neighbor
            nbr[i, 2] = x + ip[y] * L      # above neighbor
            nbr[i, 3] = x + im[y] * L      # below neighbor
    
    return nbr

nbr = create_nbr(L)
print(f"Neighbor array created for L={L} lattice (N={N} spins)")

# ==============================================================================
# TASK 1: INITIALIZATION - Random spin configuration
# ==============================================================================
"""
Required_Tasks 1: Initialize lattice

Start with random spin configuration (each spin ±1 with equal probability).
This tests the equilibration and ergodicity of the algorithm.
"""

spins = np.random.choice([-1, 1], size=N)
print(f"Initial random spin configuration: {spins[:20]}...")

# ==============================================================================
# TASK 1e: MEASUREMENT FUNCTION - Observable calculations
# ==============================================================================
"""
Required_Tasks 1.e: Measurement of observables M and E

Computes:
- Energy: E = -Σ_{<i,j>} S_i * S_j (sum over nearest neighbors)
- Magnetization: M = Σ_i S_i (sum of all spins)

Energy is divided by 2 because each pair is counted twice in the sum.
"""

def calc_energy(state, nbr):
    """
    Calculate total energy of the spin configuration.
    
    E = -Σ_{<i,j>} S_i * S_j (nearest neighbor interactions)
    
    Parameters:
        state: (N,) array of ±1 spins
        nbr: (N, 4) neighbor array
    
    Returns:
        energy: Total energy (divided by 2 to avoid double counting)
    """
    energy = 0
    N = len(state)
    
    for i in range(N):
        spin_i = state[i]
        # Sum neighbors' spins
        neighbor_sum = 0
        for j in range(4):  # 4 neighbors in 2D square lattice
            neighbor_sum += state[nbr[i, j]]
        # Contribution to energy: E_i = -S_i * Σ_j S_j
        energy += spin_i * neighbor_sum
    
    # Each pair counted twice (once for each spin in the pair)
    return energy / 2

def calc_magnetization(state):
    """
    Calculate total magnetization.
    
    M = Σ_i S_i
    
    Parameters:
        state: (N,) array of ±1 spins
    
    Returns:
        magnetization: Total magnetization
    """
    return np.sum(state)

# Test the measurement functions
test_energy = calc_energy(spins, nbr)
test_mag = calc_magnetization(spins)
print(f"Initial energy: {test_energy:.2f}")
print(f"Initial magnetization: {test_mag}")

# ==============================================================================
# TASK 1d: MONTE CARLO UPDATE - Metropolis algorithm with Glauber dynamics
# ==============================================================================
"""
Required_Tasks 1.d: Monte Carlo update (Metropolis algorithm)

Implements:
1. Random spin selection
2. Energy change calculation (only needs 4 neighbors)
3. Metropolis acceptance: accept if ΔE < 0 or with probability exp(-βΔE)

This function is GEOMETRY-INDEPENDENT:
- It only uses the neighbor array
- Works for any lattice (2D, 3D, triangular, etc.)
- Same code as long as neighbor array is correctly defined
"""

def step_once(current_state, nbr, beta):
    """
    Perform one Monte Carlo step (one attempted spin flip).
    
    Uses Metropolis algorithm with Glauert dynamics:
    1. Choose random spin
    2. Calculate energy cost of flipping: ΔE = 2 * S_i * Σ_j S_j
    3. Accept if ΔE < 0 (energy decreases)
       OR with probability exp(-β*ΔE) (thermal fluctuation)
    
    Parameters:
        current_state: (N,) array of ±1 spins
        nbr: (N, 4) neighbor array
        beta: 1/T (inverse temperature)
    
    Returns:
        current_state: Updated spin configuration (modified in-place)
    """
    N = len(current_state)
    
    # Choose random spin to flip
    flip_index = np.random.randint(0, N)
    spin_i = current_state[flip_index]
    
    # Calculate energy difference if we flip this spin
    # ΔE = E_new - E_old = 2 * S_i * Σ_j S_j
    neighbor_indices = nbr[flip_index]
    neighbor_sum = np.sum(current_state[neighbor_indices])
    delta_E = 2 * spin_i * neighbor_sum
    
    # Metropolis acceptance criterion
    if (delta_E < 0) or (np.random.rand() < np.exp(-beta * delta_E)):
        current_state[flip_index] *= -1  # Accept flip
    
    return current_state


# ==============================================================================
# TASK 1: FULL SIMULATION WITH MEASUREMENTS
# ==============================================================================
"""
Required_Tasks 1:
- Run n_MCS Monte Carlo steps
- Each MCS = N attempted spin flips (random updating)
- Measure observables every n_meas steps
- Store time series for analysis
"""

print(f"\n{'='*70}")
print(f"Starting Monte Carlo simulation")
print(f"L={L}, T={T}, n_MCS={n_MCS}, n_meas={n_meas}")
print(f"{'='*70}\n")

beta = 1.0 / T
n_measurements = n_MCS // n_meas

# Storage for time series (Required_Tasks 1: output)
energy_series = np.zeros(n_measurements)
mag_series = np.zeros(n_measurements)
mcs_steps = np.arange(n_measurements) * n_meas

# Timing for performance (Required_Tasks 2: speed)
start_time = time.time()
total_flips = 0

# Main MC loop
for mcs_step in range(n_MCS):
    # One MCS = N attempted spin flips (random updating)
    for _ in range(N):
        spins = step_once(spins, nbr, beta)
        total_flips += 1
    
    # Measure observables every n_meas steps
    if (mcs_step + 1) % n_meas == 0:
        measurement_idx = (mcs_step + 1) // n_meas - 1
        energy_series[measurement_idx] = calc_energy(spins, nbr)
        mag_series[measurement_idx] = calc_magnetization(spins)
    
    # Progress indicator
    if (mcs_step + 1) % (n_MCS // 10) == 0:
        current_energy = calc_energy(spins, nbr)
        print(f"MCS {mcs_step + 1}/{n_MCS}: E = {current_energy:.2f}, |M| = {abs(mag_series[(mcs_step + 1) // n_meas - 1])}")

elapsed_time = time.time() - start_time

# ==============================================================================
# TASK 2: PERFORMANCE MEASUREMENT
# ==============================================================================
"""
Required_Tasks 2: Report speed of MC update

Speed = number of attempted spin flips per second
This tests efficiency of the implementation.
"""

flip_rate = total_flips / elapsed_time
print(f"\n{'='*70}")
print(f"TASK 2: PERFORMANCE")
print(f"{'='*70}")
print(f"Total MC time: {elapsed_time:.2f} seconds")
print(f"Total spin flip attempts: {total_flips}")
print(f"Spin flip rate: {flip_rate:.2e} flips/second")
print(f"{'='*70}\n")

# ==============================================================================
# TASK 3: BINNING ANALYSIS
# ==============================================================================
"""
Required_Tasks 3: Binning code for statistical error estimation

Groups time series data into "bins" of increasing size m.
For each bin size, calculates:
- Mean of binned averages
- Standard deviation of binned averages

The binned standard deviation = statistical error of the mean.
Plateau in error vs. bin size indicates autocorrelation time.
"""

def binning_analysis(data, max_bin_size=None):
    """
    Perform binning analysis on time series data.
    
    Parameters:
        data: (n_measurements,) time series array
        max_bin_size: maximum bin size (~100 bins should remain)
    
    Returns:
        bin_sizes: array of bin sizes (powers of 2)
        bin_errors: standard error for each bin size
        bin_means: mean value from binned data
    """
    n_data = len(data)
    
    # Max bin size such that we have ~100 bins left
    if max_bin_size is None:
        max_bin_size = max(1, n_data // 100)
    
    # Bin sizes: 1, 2, 4, 8, 16, 32, ...
    bin_sizes = []
    bin_errors = []
    bin_means = []
    
    m = 1
    while m <= max_bin_size:
        n_bins = n_data // m
        
        if n_bins < 1:
            break
        
        # Bin the data
        binned_data = np.array([np.mean(data[i*m:(i+1)*m]) for i in range(n_bins)])
        
        # Calculate statistics
        bin_mean = np.mean(binned_data)
        bin_std = np.std(binned_data, ddof=1)  # Sample std dev
        bin_error = bin_std / np.sqrt(n_bins)  # Standard error of the mean
        
        bin_sizes.append(m)
        bin_errors.append(bin_error)
        bin_means.append(bin_mean)
        
        m *= 2
    
    return np.array(bin_sizes), np.array(bin_errors), np.array(bin_means)

# Perform binning analysis
bin_sizes, energy_errors, energy_means = binning_analysis(energy_series)
bin_sizes_m, mag_errors, mag_means = binning_analysis(np.abs(mag_series))

print(f"{'='*70}")
print(f"TASK 3: BINNING ANALYSIS")
print(f"{'='*70}")
print(f"\nEnergy binning (E):")
print(f"{'m':<8} {'<E>':<15} {'Error':<15}")
for m, em, err in zip(bin_sizes, energy_means, energy_errors):
    print(f"{m:<8} {em:<15.6f} {err:<15.6e}")

print(f"\nMagnetization binning (|M|):")
print(f"{'m':<8} {'<|M|>':<15} {'Error':<15}")
for m, mm, err in zip(bin_sizes_m, mag_means, mag_errors):
    print(f"{m:<8} {mm:<15.6f} {err:<15.6e}")

# ==============================================================================
# TASK 4, 7, 8: PLOTTING AND ANALYSIS
# ==============================================================================
"""
Required_Tasks 4, 7, 8: Visualization and interpretation

Plots:
- Time series for E and M
- Binning error analysis
- Observable vs temperature
- Normalized by system size N
"""

fig, axes = plt.subplots(2, 2, figsize=(14, 10))

# Plot 1: Energy time series (normalized by N)
axes[0, 0].plot(mcs_steps, energy_series / N, 'b-', linewidth=1, alpha=0.7)
axes[0, 0].set_xlabel('MCS')
axes[0, 0].set_ylabel('E / N')
axes[0, 0].set_title(f'Energy Time Series (L={L}, T={T})')
axes[0, 0].grid(True, alpha=0.3)

# Plot 2: Magnetization time series (normalized by N)
axes[0, 1].plot(mcs_steps, mag_series / N, 'r-', linewidth=1, alpha=0.7)
axes[0, 1].set_xlabel('MCS')
axes[0, 1].set_ylabel('M / N')
axes[0, 1].set_title(f'Magnetization Time Series (L={L}, T={T})')
axes[0, 1].grid(True, alpha=0.3)

# Plot 3: Binning error for Energy
axes[1, 0].loglog(bin_sizes, energy_errors, 'bo-', linewidth=2, markersize=8, label='Energy')
axes[1, 0].set_xlabel('Bin size m')
axes[1, 0].set_ylabel('Statistical Error')
axes[1, 0].set_title('Energy: Binning Analysis')
axes[1, 0].grid(True, alpha=0.3, which='both')
axes[1, 0].legend()

# Plot 4: Binning error for Magnetization
axes[1, 1].loglog(bin_sizes_m, mag_errors, 'ro-', linewidth=2, markersize=8, label='|M|')
axes[1, 1].set_xlabel('Bin size m')
axes[1, 1].set_ylabel('Statistical Error')
axes[1, 1].set_title('Magnetization: Binning Analysis')
axes[1, 1].grid(True, alpha=0.3, which='both')
axes[1, 1].legend()

plt.tight_layout()
plt.savefig(f'ising_L{L}_T{T:.2f}_analysis.png', dpi=150)
plt.show()

print(f"\nPlots saved as: ising_L{L}_T{T:.2f}_analysis.png")

# ==============================================================================
# SUMMARY
# ==============================================================================

final_energy = energy_series[-1]
final_energy_norm = final_energy / N
final_mag = np.mean(np.abs(mag_series)) / N

print(f"\n{'='*70}")
print(f"SUMMARY")
print(f"{'='*70}")
print(f"Final <E>/N: {final_energy_norm:.6f} ± {energy_errors[-1]/N:.6e}")
print(f"Mean <|M|>/N: {final_mag:.6f} ± {mag_errors[-1]/N:.6e}")
print(f"Autocorrelation length ≈ {bin_sizes[-1]} MCS")
print(f"{'='*70}\n")