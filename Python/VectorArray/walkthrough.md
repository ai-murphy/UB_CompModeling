# Vector Array Walkthrough

## Overview
Exercise #1 focuses on working with **arrays of vectors** in 3D space (x, y, z coordinates). You'll practice normalization, dot products, and matrix operations. The exercise involves 5 systems, each with 7 particles in 3D coordinates.

---
Create an array of vectors for 5 systems with 7 particles in xyz coordinates in the following way:
- `rng = np.random.default_rng(12345)`
- `vectors = rng.random(size=(5,7,3))`
1.	Create a new array with these vectors normalized, i.e. all its (x,y,z) vectors should have a module of 1. Print the components of vector (2,4) with 3 decimals. You can use `np.linalg.norm`.
2.	Give the index of the vector of system 1 that has a larger dot product with vector 3 of system 0.
3.	For system 3 and 4 calculate the dot product of all pairs of vectors (a total of 7x7=49). Call this matrix prods. If there is any row of this matrix which has a value larger than 1, print the first element of this row.


## Mathematical Background

### 1. Vector Module (Magnitude/Norm)
The **module** (or magnitude/norm) of a vector **v** = (x, y, z) is calculated as:

```
||v|| = √(x² + y² + z²)
```

**What it means:** The distance from the origin to the point (x, y, z) in 3D space.

**Normalized vector:** A vector with module = 1. To normalize a vector **v**, divide each component by its module:

```
v_normalized = v / ||v||
```

**Example:**
- Vector v = (3, 4, 0)
- Module: ||v|| = √(9 + 16 + 0) = 5
- Normalized: v_norm = (3/5, 4/5, 0) = (0.6, 0.8, 0)
- Check: √(0.6² + 0.8²) = √(0.36 + 0.64) = 1 ✓

### 2. Dot Product
The **dot product** of two vectors **a** = (a₁, a₂, a₃) and **b** = (b₁, b₂, b₃) is:

```
a · b = a₁b₁ + a₂b₂ + a₃b₃
```

**Geometric interpretation:**
```
a · b = ||a|| × ||b|| × cos(θ)
```
where θ is the angle between the vectors.

**Properties:**
- If vectors are **perpendicular** (θ = 90°): a · b = 0
- If vectors are **parallel** (θ = 0°): a · b = ||a|| × ||b||
- If vectors are **opposite** (θ = 180°): a · b = -||a|| × ||b||
- For **normalized vectors** (||a|| = ||b|| = 1): a · b = cos(θ)

**Example:**
- a = (1, 0, 0), b = (0, 1, 0)
- a · b = 1×0 + 0×1 + 0×0 = 0 (perpendicular)

### 3. Matrix Operations
A **dot product of all pairs** of vectors creates a matrix where:
- Element (i, j) = vector_i · vector_j
- The resulting matrix is **symmetric**: prods[i,j] = prods[j,i]
- Diagonal elements are always **1** for normalized vectors: prods[i,i] = 1

---

## Part 1: Vector Normalization

### Mathematical Approach (Without NumPy)

```python
import numpy as np

# Initialize the random number generator
rng = np.random.default_rng(12345)
vectors = rng.random(size=(5, 7, 3))

# Manual normalization (no numpy linalg)
normalized_vectors = np.zeros_like(vectors)

for system in range(5):
    for particle in range(7):
        # Extract the vector
        v = vectors[system, particle, :]
        
        # Calculate the module (norm) manually
        module = np.sqrt(v[0]**2 + v[1]**2 + v[2]**2)
        
        # Normalize by dividing by the module
        normalized_vectors[system, particle, :] = v / module
```

### Using NumPy's Built-in Function

```python
# More efficient approach using numpy.linalg.norm
normalized_vectors = vectors / np.linalg.norm(vectors, axis=2, keepdims=True)
```

**Explanation:**
- `np.linalg.norm(vectors, axis=2)`: Computes the norm along axis 2 (3rd from 0; the x, y, z components)
- Returns shape (5, 7) - one norm per particle
- `keepdims=True`: Keeps it as shape (5, 7, 1) for proper broadcasting
- Division broadcasts automatically: each vector is divided by its norm

### Part 1 Solution

```python
import numpy as np

# Create the vectors
rng = np.random.default_rng(12345)
vectors = rng.random(size=(5, 7, 3))

# Normalize vectors
normalized_vectors = vectors / np.linalg.norm(vectors, axis=2, keepdims=True)

# Print vector (2,4) with 3 decimals
#print(f"{normalized_vectors[2, 4]:.3f}")   #<<< gives np error
v = [f"{x:.3f}" for x in normalized_vectors[2, 4]]
print(f"[{', '.join(v)}]")
# Output: [0.547, 0.792, 0.270]
```

---

## Part 2: Finding Maximum Dot Product

### Understanding the Task
- System 0, vector 3: target_vector = normalized_vectors[0, 3, :]
- System 1: all_vectors = normalized_vectors[1, :, :]
- Find which vector in system 1 has the **largest dot product** with system 0's vector 3

### Approach

```python
# Reference vector from system 0
target_vector = normalized_vectors[0, 3, :]

# All vectors in system 1
system1_vectors = normalized_vectors[1, :, :]

# Calculate dot products using NumPy
dot_products = np.dot(system1_vectors, target_vector)
# This computes: system1_vectors[i, :] · target_vector for each i

# Find the index with maximum dot product
max_index = np.argmax(dot_products)
```

**Manual dot product calculation:**

```python
# If you want to see how dot product works step-by-step
dot_products_manual = np.zeros(7)

for i in range(7):
    v = system1_vectors[i, :]
    dot_products_manual[i] = v[0] * target_vector[0] + \
                              v[1] * target_vector[1] + \
                              v[2] * target_vector[2]

max_index = np.argmax(dot_products_manual)
```

### Part 2 Solution

```python
# Find the vector in system 1 with largest dot product with system 0, vector 3
target_vector = normalized_vectors[0, 3, :]
dot_products = np.dot(normalized_vectors[1, :, :], target_vector)
max_dot_product_index = np.argmax(dot_products)

print(f"Index: {max_dot_product_index}")
# Output: 5
```

---

## Part 3: Pairwise Dot Products Matrix

### Understanding the Task
- For systems 3 and 4
- Calculate dot product of **all pairs**: 7 × 7 = 49 dot products
- Result is a 7×7 matrix
- Check if any row has a value > 1
- If yes, print the first element of that row

### Why Can Values Be > 1?
For **normalized vectors**, the dot product a · b = cos(θ), which should be in [-1, 1]. However:
- Floating-point **rounding errors** can produce values slightly > 1
- Values > 1 in a row might indicate numerical precision issues

### Approach

```python
# Extract vectors from systems 3 and 4
vectors_system3 = normalized_vectors[3, :, :]  # Shape: (7, 3)
vectors_system4 = normalized_vectors[4, :, :]  # Shape: (7, 3)

# Calculate all pairwise dot products between system 3 and system 4
prods = np.dot(vectors_system3, vectors_system4.T)
```

**Explanation of `np.dot(A, B.T)`:**
- A has shape (7, 3): 7 vectors with 3 components
- B.T (transpose of B) has shape (3, 7)
- Result has shape (7, 7)
- Element [i, j] = vectors_system3[i, :] · vectors_system4[j, :]

### Manual approach:

```python
prods = np.zeros((7, 7))

for i in range(7):
    for j in range(7):
        v1 = vectors_system3[i, :]
        v2 = vectors_system4[j, :]
        prods[i, j] = v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2]
```

### Finding Rows with Values > 1

```python
# Check each row
for row_idx in range(7):
    if np.any(prods[row_idx, :] > 1):
        print(f"First element of row {row_idx}: {prods[row_idx, 0]}")
        break  # Print only the first row
```

### Part 3 Solution

```python
# Calculate pairwise dot products between systems 3 and 4
prods = np.dot(normalized_vectors[3, :, :], normalized_vectors[4, :, :].T)

# Check if any row has value > 1
for row_idx in range(7):
    if np.any(prods[row_idx, :] > 1):
        print(f"First element of row {row_idx}: {prods[row_idx, 0]}")
        break
```

---

## Complete Working Solution

```python
import numpy as np

# Create the vectors
rng = np.random.default_rng(12345)
vectors = rng.random(size=(5, 7, 3))

# ============================================
# PART 1: Normalize vectors
# ============================================
normalized_vectors = vectors / np.linalg.norm(vectors, axis=2, keepdims=True)

# Print vector (2,4) with 3 decimals
print("Part 1 - Vector (2,4) normalized:")
#print(f"{normalized_vectors[2, 4]:.3f}")   #<<< gives np error
v = [f"{x:.3f}" for x in normalized_vectors[2, 4]]
print(f"[{', '.join(v)}]")
# Expected output: [0.547, 0.792, 0.270]

# ============================================
# PART 2: Find max dot product
# ============================================
target_vector = normalized_vectors[0, 3, :]
dot_products = np.dot(normalized_vectors[1, :, :], target_vector)
max_dot_product_index = np.argmax(dot_products)

print(f"\nPart 2 - Index with max dot product: {max_dot_product_index}")
# Expected output: 5

# ============================================
# PART 3: Pairwise dot products
# ============================================
prods = np.dot(normalized_vectors[3, :, :], normalized_vectors[4, :, :].T)

print("\nPart 3 - First element of row with value > 1:")
found = False
for row_idx in range(7):
    if np.any(prods[row_idx, :] > 1):
        print(f"{prods[row_idx, 0]}")
        found = True
        break

if not found:
    print("No row with value > 1 found")
```

---

## Key NumPy Functions Used

| Function | Purpose | Example |
|----------|---------|---------|
| `np.linalg.norm(arr, axis=k)` | Calculate vector norms along axis k | `np.linalg.norm(vectors, axis=2)` |
| `np.dot(A, B)` | Dot product (A × B) | `np.dot(vectors1, vectors2.T)` |
| `np.argmax(arr)` | Index of maximum value | `np.argmax(dot_products)` |
| `np.any(condition)` | Check if any element meets condition | `np.any(prods > 1)` |

---

## Verification and Testing

### Check Normalization
```python
# All norms should be 1 (or very close due to floating point)
norms = np.linalg.norm(normalized_vectors, axis=2)
print(f"Min norm: {norms.min()}, Max norm: {norms.max()}")
# Expected: Both very close to 1.0
```

### Check Dot Product Properties
```python
# For normalized vectors, dot product with themselves should be 1
v = normalized_vectors[0, 0, :]
self_dot = np.dot(v, v)
print(f"Dot product with itself: {self_dot}")
# Expected: 1.0
```

### Check Matrix Symmetry (for pairwise products)
```python
# Dot product matrix should be symmetric
is_symmetric = np.allclose(prods, prods.T)
print(f"Matrix is symmetric: {is_symmetric}")
# Expected: True
```

---

## Common Mistakes to Avoid

1. **Forgetting `keepdims=True`**: Without it, normalization won't broadcast correctly
2. **Using wrong axis**: Axis 2 is for (x, y, z) components
3. **Forgetting matrix transpose**: In `np.dot(A, B.T)`, the transpose is crucial for correct dimensions
4. **Not checking floating-point precision**: Values slightly > 1 are normal due to rounding errors
5. **Indexing confusion**: Remember arrays are 0-indexed (system 0 = first system)

---

## Tips for Understanding

- **Visualize the data structure**: 5 systems × 7 particles × 3 coordinates = 3D array
- **Think in layers**: Each system is a 7×3 matrix of vectors
- **Dot product as similarity**: Higher dot product = more similar directions
- **Normalized vectors**: Useful for comparing directions without worrying about magnitude

Good luck with Exercise #1!
