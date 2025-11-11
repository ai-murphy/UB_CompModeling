#!/usr/bin/env python3
"""
Exercise #2 Data Generation Script
Generates sample data for the function: z = cos(x^3 - y) - sin(x + y)
Output file: values.dat (3 columns: x, y, z)
"""

import numpy as np

def compute_z(x, y):
    """
    Compute the z value for the given function.
    
    Args:
        x: x-coordinate(s)
        y: y-coordinate(s)
    
    Returns:
        z = cos(x^3 - y) - sin(x + y)
    """
    return np.cos(x**3 - y) - np.sin(x + y)


def generate_data(x_min=-2, x_max=2, y_min=-2, y_max=2, resolution=100):
    """
    Generate a regular mesh grid and compute z values.
    
    Args:
        x_min, x_max: Range for x values
        y_min, y_max: Range for y values
        resolution: Number of points per dimension (resolution x resolution grid)
    
    Returns:
        data_array: Numpy array with shape (resolution^2, 3) containing [x, y, z]
    """
    # Create linearly spaced points
    x_points = np.linspace(x_min, x_max, resolution)
    y_points = np.linspace(y_min, y_max, resolution)
    
    # Create mesh grid
    X, Y = np.meshgrid(x_points, y_points)
    
    # Calculate z values
    Z = compute_z(X, Y)
    
    # Flatten and combine into data array
    # Critical: iterate over x in outer loop, y in inner loop for proper gnuplot ordering
    data = []
    for i in range(len(x_points)):
        for j in range(len(y_points)):
            data.append([X[j, i], Y[j, i], Z[j, i]])
    
    return np.array(data), (x_min, x_max, y_min, y_max), Z


def save_to_file(data_array, filename='values.dat'):
    """
    Save the data array to a file in gnuplot-compatible format.
    
    Args:
        data_array: Numpy array with shape (N, 3) containing [x, y, z]
        filename: Output filename
    """
    np.savetxt(filename, data_array, fmt='%.6f', delimiter=' ', 
               header='x y z', comments='')
    print(f"✓ Data file '{filename}' created successfully!")


def print_statistics(data_array, ranges, Z):
    """Print information about the generated data."""
    x_min, x_max, y_min, y_max = ranges
    
    print("\n" + "="*60)
    print("DATA GENERATION STATISTICS")
    print("="*60)
    print(f"Function: z = cos(x³ - y) - sin(x + y)")
    print(f"\nGrid Dimensions:")
    print(f"  Total points: {len(data_array):,}")
    print(f"  Grid size: {int(np.sqrt(len(data_array)))}x{int(np.sqrt(len(data_array)))}")
    print(f"\nCoordinate Ranges:")
    print(f"  X range: [{x_min}, {x_max}]")
    print(f"  Y range: [{y_min}, {y_max}]")
    print(f"  Z range: [{data_array[:, 2].min():.6f}, {data_array[:, 2].max():.6f}]")
    print(f"\nData Statistics:")
    print(f"  X mean: {data_array[:, 0].mean():.6f}")
    print(f"  Y mean: {data_array[:, 1].mean():.6f}")
    print(f"  Z mean: {data_array[:, 2].mean():.6f}")
    print(f"  Z std dev: {data_array[:, 2].std():.6f}")
    print(f"\nSample data (first 5 points):")
    print("  X         Y         Z")
    for row in data_array[:5]:
        print(f"  {row[0]:8.6f}  {row[1]:8.6f}  {row[2]:8.6f}")
    print("="*60 + "\n")


if __name__ == "__main__":
    # Generate data with 100×100 resolution
    print("Generating data for z = cos(x³ - y) - sin(x + y)...")
    data_array, ranges, Z = generate_data(x_min=0, x_max=2, y_min=0, y_max=5, resolution=100)
    
    # Save to file
    save_to_file(data_array, 'values.dat')
    
    # Print statistics
    print_statistics(data_array, ranges, Z)
    
    print("Ready to use values.dat with gnuplot!")
