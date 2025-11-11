"""
Task: Python Particle System Analysis

Complete solution demonstrating:
1. Creating a particle array in 3D space
2. Calculating pairwise distances
3. Finding the closest particle pair
4. Computing total system energy

"""

import numpy as np
from scipy.spatial.distance import pdist, squareform

# ============================================================================
# STEP 1: Create an array of 20 particles
# ============================================================================

# Set random seed for reproducibility
rng = np.random.default_rng(12345)

# Create 20 particles in a box (100, 10, 10)
# Each row is a particle with (x, y, z) coordinates
pos = rng.uniform(low=[0, 0, 0], high=[100, 10, 10], size=(20, 3))

print("=" * 70)
print("STEP 1: Particle Array Creation")
print("=" * 70)
print(f"Particle array shape: {pos.shape}")
print(f"Box dimensions: (100, 10, 10)")
print(f"\nFirst 5 particles (x, y, z):")
for i in range(5):
    print(f"  Particle {i}: ({pos[i, 0]:.4f}, {pos[i, 1]:.4f}, {pos[i, 2]:.4f})")
print()

# ============================================================================
# STEP 2: Find the minimum distance between all pairs of particles
# ============================================================================

print("=" * 70)
print("STEP 2: Minimum Distance Calculation")
print("=" * 70)

# Calculate pairwise distances using scipy
# pdist returns a condensed distance matrix (upper triangle only)
distances = pdist(pos)

# Find minimum distance
min_distance = np.min(distances)

# Verify the expected number of distances
expected_pairs = 20 * 19 // 2
actual_pairs = len(distances)

print(f"Total number of unique particle pairs: {actual_pairs}")
print(f"Expected: C(20,2) = 20×19/2 = {expected_pairs}")
print(f"Match? {actual_pairs == expected_pairs}")
print(f"\nMinimum distance between any two particles: {min_distance:.6f}")
print()

# ============================================================================
# STEP 3: Find which particles have the minimum distance
# ============================================================================

print("=" * 70)
print("STEP 3: Identifying Minimum Distance Particle Pair")
print("=" * 70)

# Convert condensed distance matrix to square form for easier indexing
dist_matrix = squareform(distances)

# Find indices of minimum distance
# Note: np.argmin returns a flat index, unravel_index converts to 2D coordinates
min_flat_idx = np.argmin(dist_matrix)
i, j = np.unravel_index(min_flat_idx, dist_matrix.shape)

# Ensure i < j for consistency
if i > j:
    i, j = j, i

print(f"Particle pair with minimum distance: {i} and {j}")

# Extract the two particles' coordinates
particle_i = pos[i]
particle_j = pos[j]

print(f"\nParticle {i} position: ({particle_i[0]:.4f}, {particle_i[1]:.4f}, {particle_i[2]:.4f})")
print(f"Particle {j} position: ({particle_j[0]:.4f}, {particle_j[1]:.4f}, {particle_j[2]:.4f})")

# Verify by calculating distance multiple ways
# Method 1: Using numpy's norm function
diff = particle_j - particle_i
distance_norm = np.linalg.norm(diff)

# Method 2: Manual calculation using the formula
distance_manual = np.sqrt(np.sum(diff ** 2))

# Method 3: Using the direct formula
distance_formula = np.sqrt((particle_j[0] - particle_i[0])**2 +
                            (particle_j[1] - particle_i[1])**2 +
                            (particle_j[2] - particle_i[2])**2)

print(f"\nDistance verification:")
print(f"  Using numpy.linalg.norm: {distance_norm:.6f}")
print(f"  Manual calculation:      {distance_manual:.6f}")
print(f"  Using direct formula:    {distance_formula:.6f}")
print(f"  From pdist result:       {min_distance:.6f}")

# Verify all calculations agree
all_agree = np.isclose(distance_norm, min_distance) and \
            np.isclose(distance_manual, min_distance) and \
            np.isclose(distance_formula, min_distance)

print(f"  All methods agree? {all_agree}")
print()

# ============================================================================
# STEP 4: Calculate total energy of the system
# ============================================================================

print("=" * 70)
print("STEP 4: Total Energy Calculation")
print("=" * 70)

def calculate_total_energy(positions):
    """
    Calculate total energy of the system.
    
    Energy formula: U = sum(z_i)
    where z_i is the z-coordinate of particle i
    
    Physical interpretation: This represents a system in a uniform
    gravitational field where potential energy is proportional to height.
    
    Parameters
    ----------
    positions : ndarray
        Array of shape (N, 3) containing particle positions (x, y, z)
        
    Returns
    -------
    float
        Total energy of the system
    """
    z_coordinates = positions[:, 2]  # Extract z-coordinates (3rd column)
    total_energy = np.sum(z_coordinates)
    return total_energy

# Calculate total energy
total_energy = calculate_total_energy(pos)

print("Energy Calculation Details:")
print("-" * 70)
print(f"Formula: U = Σ z_i (where z_i is the z-coordinate of particle i)")
print(f"Number of particles: {pos.shape[0]}")
print(f"\nZ-coordinates of all particles:")

z_coords = pos[:, 2]
for idx, z in enumerate(z_coords):
    print(f"  Particle {idx:2d}: z = {z:.6f}")

print(f"\nCalculation:")
print(f"  U = {' + '.join([f'{z:.4f}' for z in z_coords[:3]])} + ... + {z_coords[-1]:.4f}")
print(f"\nTotal energy U = Σ z_i = {total_energy:.6f}")

# Verify with alternative calculation
total_energy_alt = np.sum(pos[:, 2])
print(f"Verification (one-liner): {total_energy_alt:.6f}")
print(f"Match? {np.isclose(total_energy, total_energy_alt)}")
print()

# ============================================================================
# SUMMARY
# ============================================================================

print("=" * 70)
print("SUMMARY - Exercise #4 Results")
print("=" * 70)
print(f"System Configuration:")
print(f"  • Number of particles: 20")
print(f"  • Box dimensions: (100, 10, 10)")
print(f"  • Random seed: 12345")
print(f"\nResults:")
print(f"  • Total unique particle pairs: {len(distances)}")
print(f"  • Minimum pairwise distance: {min_distance:.6f}")
print(f"  • Closest particle pair: ({i}, {j})")
print(f"  • Total system energy: {total_energy:.6f}")
print("=" * 70)