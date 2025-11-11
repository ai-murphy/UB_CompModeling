import numpy as np

def generate_values_dat():
    """
    Generate values.dat file with x, y, z coordinates for the function:
    z(x,y) = sin(x) * cos(y) + 0.2 * x * y
    """
    
    # Define grid parameters
    x_points = 50
    y_points = 30
    
    # Create 1D arrays for x and y
    x = np.linspace(-5, 5, x_points)
    y = np.linspace(-3, 3, y_points)
    
    # Create meshgrid (2D arrays)
    X, Y = np.meshgrid(x, y)
    
    # Calculate z values using the given function
    Z = np.sin(X) * np.cos(Y) + 0.2 * X * Y
    
    # Prepare output data
    output_lines = []
    
    # Important: iterate through y values (outer loop), then x values (inner loop)
    for i in range(y_points):
        for j in range(x_points):
            x_val = X[i, j]
            y_val = Y[i, j]
            z_val = Z[i, j]
            output_lines.append(f"{x_val:.6f} {y_val:.6f} {z_val:.6f}")
        output_lines.append("")  # Blank line between rows
    
    # Write to file
    with open('values.dat', 'w') as f:
        f.write('\n'.join(output_lines))
    
    print("values.dat generated successfully!")
    print(f"Grid: {x_points}x{y_points}")
    print(f"Z range: [{Z.min():.4f}, {Z.max():.4f}]")
    
    return X, Y, Z

if __name__ == "__main__":
    X, Y, Z = generate_values_dat()