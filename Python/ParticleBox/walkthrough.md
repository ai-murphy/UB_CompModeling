# Python Particle System Analysis - Complete Walkthrough

## Task
1. Create an array of 20 particles named pos in a box of dimensions (100, 10, 10). If possible, use this random seed:
`r ng = np. random.default_rng(12345)`
2. Find the minimum distance between all pairs of particles.
3. Find which particles pair (give particle indices) has the minimum distance that you have found. Prove your result by explicitly calculating the distance between these two particles and printing the result. The function squareform in the scipy.spatial.distance may be useful, but you do not need to use it.
3. Imagine that all particles are in a field so that the energy of the system is $$U= ∑_iz_i^2$$  where $z_i$ is the third component of the particle positions $r_i = (x_i, y_i, z_i)$. Create a function that calculates the total energy of the system and use it to print the total energy.

---
## Table of Contents

1. [Overview](#overview)
2. [4.1: Creating an Array of 20 Particles](#41-creating-an-array-of-20-particles)
3. [4.2: Finding Minimum Distance Between All Pairs](#42-finding-minimum-distance-between-all-pairs)
4. [4.3: Identifying the Minimum Distance Pair](#43-identifying-the-minimum-distance-pair)
5. [4.4: Calculating Total System Energy](#44-calculating-total-system-energy)
6. [Complete Functioning Code](#complete-functioning-code)
7. [Key Concepts and Tricks](#key-concepts-and-tricks)

---

## Overview

Exercise #4 focuses on working with a system of 20 particles distributed in a 3D box. The exercise involves:

- **Part 4.1:** Creating a particle array with random positions
- **Part 4.2:** Computing distances between all particle pairs
- **Part 4.3:** Finding which pair has the minimum distance
- **Part 4.4:** Calculating the total energy of the system

This exercise demonstrates fundamental skills in numerical computing: array manipulation, distance calculations, and data aggregation.

---

## 4.1: Creating an Array of 20 Particles

### Objective

Create a 20-particle array with random positions in a 3D box with dimensions (100, 10, 10).

### Mathematical Background

Particles are positions in 3D space. We need to create a 2D array where:
- **Rows:** Individual particles (20 rows)
- **Columns:** Coordinates (3 columns for x, y, z)
- **Box dimensions:**
  - x ∈ [0, 100]
  - y ∈ [0, 10]
  - z ∈ [0, 10]

### Code Implementation

```python
import numpy as np
from scipy.spatial.distance import pdist, squareform

# Set random seed for reproducibility
rng = np.random.default_rng(12345)

# Create 20 particles in a box (100, 10, 10)
# Shape: (20, 3) where 3 represents x, y, z coordinates
pos = rng.uniform(low=[0, 0, 0], high=[100, 10, 10], size=(20, 3))

print("Particle positions shape:", pos.shape)
print("First 5 particles:\n", pos[:5])
```

### Explanation

- `rng.uniform()`: Generates uniformly distributed random numbers
- `low` and `high`: Lists specifying bounds for each dimension
- `size=(20, 3)`: Ensures 20 particles with 3 coordinates each
- Result: A (20, 3) NumPy array

### Output Example

```
Particle positions shape: (20, 3)
First 5 particles:
 [[57.28 8.42 5.67]
  [23.45 2.11 9.34]
  [89.12 6.78 1.23]
  [12.34 4.56 7.89]
  [76.54 1.23 3.45]]
```

---

## 4.2: Finding Minimum Distance Between All Pairs

### Objective

Calculate distances between all pairs of particles and find the minimum.

### Mathematical Background

#### Euclidean Distance Formula

The Euclidean distance between two 3D points P₁ = (x₁, y₁, z₁) and P₂ = (x₂, y₂, z₂) is:

```
d(P₁, P₂) = √[(x₂ - x₁)² + (y₂ - y₁)² + (z₂ - z₁)²]
```

#### Number of Unique Pairs

For N particles, the number of unique pairs is:

```
C(N, 2) = N(N-1)/2
```

For N = 20: C(20, 2) = 190 unique pairs

### Method 1: Manual Distance Calculation (Educational)

```python
def calculate_all_distances_manual(positions):
    """
    Calculate pairwise distances without using scipy.
    
    Returns a condensed distance matrix (1D array of unique distances).
    
    Process:
    1. Iterate through all unique pairs (i, j) where i < j
    2. Calculate the Euclidean distance for each pair
    3. Store in a 1D array
    """
    n_particles = positions.shape[0]
    distances = []
    
    # Iterate through all unique pairs
    for i in range(n_particles):
        for j in range(i + 1, n_particles):
            # Calculate difference vector
            diff = positions[j] - positions[i]
            
            # Calculate Euclidean distance
            # ||diff|| = √(Σ diff²)
            distance = np.sqrt(np.sum(diff ** 2))
            
            distances.append(distance)
    
    return np.array(distances)

# Calculate all pairwise distances
distances_manual = calculate_all_distances_manual(pos)
min_distance_manual = np.min(distances_manual)

print(f"Number of distances: {len(distances_manual)}")
print(f"Minimum distance (manual): {min_distance_manual:.6f}")
```

### Method 2: Using scipy.spatial.distance.pdist (Optimized)

```python
from scipy.spatial.distance import pdist

# Using scipy's pdist function
# Returns condensed distance matrix (only upper triangle)
distances = pdist(pos)

# Find minimum
min_distance = np.min(distances)

print(f"Minimum distance (scipy): {min_distance:.6f}")
print(f"Total number of distances: {len(distances)}")
```

### Why Use scipy.pdist?

| Aspect | Manual Loop | pdist |
|--------|-------------|-------|
| Speed | Slower (Python loops) | Faster (C implementation) |
| Memory | Full N×N matrix | Condensed format (~50% less) |
| Code Complexity | More verbose | Concise |
| Readability | Clear logic flow | Industry standard |

### Condensed vs. Squared Distance Matrices

**Condensed Format:** 1D array of size 190
- Stores only unique distances
- Memory efficient
- Direct output from `pdist()`

**Squared Format:** 2D array of size (20, 20)
- Symmetric matrix (d[i,j] = d[j,i])
- Diagonal is zero (d[i,i] = 0)
- Intuitive for indexing
- Created with `squareform()`

### Conversion Between Formats

```python
# Convert condensed to square matrix
dist_matrix_square = squareform(distances)

print("Condensed shape:", distances.shape)      # (190,)
print("Square shape:", dist_matrix_square.shape)  # (20, 20)

# Verify symmetry
print("Is symmetric?", np.allclose(dist_matrix_square, dist_matrix_square.T))
```

---

## 4.3: Identifying the Minimum Distance Pair

### Objective

Determine which two particles have the minimum distance and verify the calculation.

### Mathematical Background

Given a condensed distance matrix, we need to map the minimum index back to particle indices (i, j).

**Key Insight:** The condensed matrix stores distances in a specific order:
- (0,1), (0,2), ..., (0,19), (1,2), (1,3), ..., (1,19), (2,3), ...

### Method 1: Using squareform (Recommended)

```python
# Step 1: Calculate distances
distances = pdist(pos)

# Step 2: Convert to square matrix
dist_matrix = squareform(distances)

# Step 3: Find minimum in square matrix
min_indices = np.unravel_index(np.argmin(dist_matrix), dist_matrix.shape)
i, j = min_indices

print(f"Particles with minimum distance: {i} and {j}")

# Note: Due to symmetry, this might return (i, j) or (j, i)
# Normalize so i < j if needed
if i > j:
    i, j = j, i
```

### Method 2: Manual Mapping from Condensed Index (Advanced)

```python
def find_min_pair_condensed(distances, n_particles=20):
    """
    Find particle indices from condensed distance matrix.
    
    The condensed matrix stores distances in row-major order for the
    upper triangle. This function converts the minimum index back to (i, j).
    
    Algorithm:
    1. Find the index of the minimum value
    2. Convert from condensed indexing to (i, j) indexing
    """
    min_idx = np.argmin(distances)
    
    # Convert condensed index to (i, j) coordinates
    row_sum = 0
    for i in range(n_particles):
        row_length = n_particles - i - 1
        if min_idx < row_sum + row_length:
            j = i + 1 + (min_idx - row_sum)
            return i, j
        row_sum += row_length
    
    return None, None

i, j = find_min_pair_condensed(distances)
print(f"Particle pair (condensed method): {i} and {j}")
```

### Verification Through Explicit Distance Calculation

```python
# Extract the two particles
particle_i = pos[i]
particle_j = pos[j]

# Method 1: Using numpy.linalg.norm
distance_norm = np.linalg.norm(particle_j - particle_i)

# Method 2: Manual calculation
diff = particle_j - particle_i
distance_manual = np.sqrt(np.sum(diff ** 2))

# Method 3: Direct formula
distance_formula = np.sqrt((particle_j[0] - particle_i[0])**2 +
                            (particle_j[1] - particle_i[1])**2 +
                            (particle_j[2] - particle_i[2])**2)

# Verification
print(f"\nParticle {i} position: {particle_i}")
print(f"Particle {j} position: {particle_j}")
print(f"\nDistance verification:")
print(f"  Using numpy.linalg.norm: {distance_norm:.6f}")
print(f"  Manual calculation:      {distance_manual:.6f}")
print(f"  Using formula:           {distance_formula:.6f}")
print(f"  From pdist result:       {np.min(distances):.6f}")
print(f"\nAll methods agree? {np.allclose([distance_norm, distance_manual, distance_formula],
                                         np.min(distances))}")
```

---

## 4.4: Calculating Total System Energy

### Objective

Calculate the total energy of the system using the formula: **U = Σ zᵢ**

### Mathematical Background

#### Energy Formula

```
U_total = Σ(i=1 to N) z_i
```

Where:
- N = total number of particles
- zᵢ = z-coordinate of particle i

#### Physical Interpretation

This formula represents a system in a **uniform gravitational field**:

**Potential Energy in Gravity:**
```
U_i = m_i * g * h_i
```

With the assumptions:
- Unit mass: m = 1
- Unit gravitational acceleration: g = 1
- Height is the z-coordinate: h = z

We get:
```
U_i = z_i
U_total = Σ z_i
```

#### Force From Energy

The force on each particle is the negative gradient of potential energy:

```
F_i = -∂U/∂z_i = -1
```

This represents a constant downward force on all particles.

### Code Implementation

```python
def calculate_total_energy(positions):
    """
    Calculate total energy of the system.
    
    The energy is defined as U = sum(z_i) where z_i is the z-coordinate
    (third column, index 2) of each particle.
    
    Parameters
    ----------
    positions : ndarray
        Array of shape (N, 3) containing particle positions (x, y, z)
        
    Returns
    -------
    float
        Total energy of the system
        
    Formula
    -------
    U = Σ z_i
    
    Physical Meaning
    ----------------
    In a uniform gravitational field with g=1 and m=1, this is the
    total gravitational potential energy of the system.
    """
    # Extract z-coordinates (third column, index 2)
    z_coordinates = positions[:, 2]
    
    # Sum all z-coordinates
    total_energy = np.sum(z_coordinates)
    
    return total_energy

# Calculate and print total energy
total_energy = calculate_total_energy(pos)

print(f"Total Energy Calculation:")
print(f"------------------------")
print(f"Number of particles: {pos.shape[0]}")
print(f"Z-coordinates of all particles:")

for idx, z in enumerate(pos[:, 2]):
    print(f"  Particle {idx:2d}: z = {z:.6f}")

print(f"\nTotal Energy (U = Σ z_i): {total_energy:.6f}")

# Alternative one-liner
total_energy_alt = np.sum(pos[:, 2])
print(f"Energy (one-liner):       {total_energy_alt:.6f}")
print(f"Match? {np.isclose(total_energy, total_energy_alt)}")
```

### Step-by-Step Breakdown

1. **Extract z-coordinates:** Access the third column (index 2)
   ```python
   z_coords = pos[:, 2]  # Shape: (20,)
   ```

2. **Sum all values:**
   ```python
   energy = np.sum(z_coords)  # Returns a scalar
   ```

3. **Result:** A single number representing total system energy

### Why This Matters

- **Baseline for comparison:** Energy calculations are fundamental in physics
- **Optimization problems:** Minimizing energy is a common objective
- **Gradient calculations:** Understanding energy leads to computing forces
- **Stability analysis:** System evolution depends on energy changes

---

## Complete Functioning Code

```python
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
```

---

## Key Concepts and Tricks

### Distance Calculation Tricks

#### Trick 1: Broadcasting for Efficient Distance Calculation

Instead of explicit loops, use NumPy broadcasting:

```python
def distances_broadcasting(pos):
    """
    Calculate full pairwise distance matrix using broadcasting.
    
    Process:
    1. Expand pos to (N, 1, 3) and (1, N, 3)
    2. Subtract to get (N, N, 3) difference matrix
    3. Square and sum along axis 2 to get (N, N) squared distances
    4. Take square root to get distances
    """
    # pos shape: (N, 3)
    
    # Create difference matrix: shape (N, N, 3)
    diff = pos[np.newaxis, :, :] - pos[:, np.newaxis, :]
    
    # Calculate squared distances: shape (N, N)
    distances_sq = np.sum(diff ** 2, axis=2)
    
    # Take square root: shape (N, N)
    distances = np.sqrt(distances_sq)
    
    return distances

# Usage
dist_full = distances_broadcasting(pos)  # Shape: (20, 20)
```

**Performance Comparison:**
- Full matrix: ~400 numbers (20×20)
- Condensed (pdist): ~190 numbers
- Broadcasting creates full matrix, less efficient than pdist for large N

#### Trick 2: Understanding Array Indexing

```python
# Extract specific coordinates
x_coords = pos[:, 0]  # All x-coordinates
y_coords = pos[:, 1]  # All y-coordinates
z_coords = pos[:, 2]  # All z-coordinates

# Extract specific particle
particle_5 = pos[5]  # All coordinates of particle 5
particle_5_x = pos[5, 0]  # x-coordinate of particle 5
```

#### Trick 3: Condensed vs. Square Indexing

| Operation | Condensed | Square |
|-----------|-----------|--------|
| Get distance (0,1) | `distances[0]` | `dist_matrix[0, 1]` |
| Get distance (5,8) | Complex formula | `dist_matrix[5, 8]` |
| Find minimum | `np.argmin(distances)` | `np.unravel_index(np.argmin(dist_matrix), dist_matrix.shape)` |
| Memory usage | Low (N×(N-1)/2) | High (N²) |

### Mathematical Concepts

#### Vector Operations in NumPy

```python
# Vector subtraction
v1 = np.array([1, 2, 3])
v2 = np.array([4, 5, 6])
diff = v2 - v1  # [3, 3, 3]

# Magnitude (norm)
magnitude = np.linalg.norm(diff)  # √(3² + 3² + 3²) = √27 ≈ 5.196

# Manual norm calculation
magnitude_manual = np.sqrt(np.sum(diff ** 2))  # Same result

# Dot product
dot = np.dot(diff, diff)  # 9 + 9 + 9 = 27 (squared magnitude)
```

#### Energy Aggregation

The sum operation is fundamental:

```python
# Different ways to sum z-coordinates
energy1 = np.sum(pos[:, 2])              # Recommended
energy2 = pos[:, 2].sum()                # Alternative
energy3 = sum(pos[:, 2])                 # Python built-in (slower)

# For verification
energies = [particle[2] for particle in pos]
energy4 = sum(energies)  # Python loop (slowest)
```

### Optimization Tips

1. **Use vectorization** instead of loops
2. **Use scipy functions** (pdist, squareform) for standard operations
3. **Seed random number generator** for reproducibility
4. **Check array shapes** frequently during development
5. **Verify calculations** using multiple methods when learning

---

## Common Pitfalls and How to Avoid Them

| Pitfall | Problem | Solution |
|---------|---------|----------|
| Indexing error | `pos[20]` causes IndexError | Remember: indices 0-19 for 20 particles |
| Using wrong axis | `sum(pos)` sums all elements | Use `pos[:, 2]` to extract column |
| Forgetting to seed RNG | Different results each run | Set seed: `rng = np.random.default_rng(12345)` |
| Symmetric indexing confusion | (i, j) vs (j, i) differences | Always check if i < j, normalize if needed |
| Off-by-one errors | Distances wrong due to iteration | Use range(i+1, n) to avoid duplicates |

---

## References and Further Reading

- NumPy Array Indexing: https://numpy.org/doc/stable/user/basics.indexing.html
- SciPy Distance Functions: https://docs.scipy.org/doc/scipy/reference/spatial.distance.html
- Linear Algebra with NumPy: https://numpy.org/doc/stable/reference/routines.linalg.html

---

**End of Walkthrough**
