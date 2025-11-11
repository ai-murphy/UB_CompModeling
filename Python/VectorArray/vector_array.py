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
# Expected output: [0.629 0.633 0.452]

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