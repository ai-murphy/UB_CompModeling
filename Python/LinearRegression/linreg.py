import numpy as np
import matplotlib.pyplot as plt

# ============================================================================
# STEP 1: Generate sample data (replace with file reading in practice)
# ============================================================================

#### Set random seed for reproducibility
###np.random.seed(42)
###
#### Generate iterations 1 to 14
###iterations = np.arange(1, 15)
###
#### Simulate exponential decay characteristic of SCF convergence
#### log10(abs(DeltaE)) = true_slope * iteration + true_intercept
###true_slope = -0.3
###true_intercept = -1.0
###log_deltaE_ideal = true_slope * iterations + true_intercept
###
#### Add small random noise to make it realistic
###deltaE = 10**log_deltaE_ideal * (1 + 0.05 * np.random.randn(iterations.size))
###
#### Create additional irrelevant columns to simulate the full SCF ITERATIONS table
###random_cols = np.random.randn(iterations.size, 3)
###
#### Stack into a table: [Iteration, Random1, Delta-E, Random2, Random3]
###data = np.column_stack((iterations, random_cols[:, 0], deltaE, random_cols[:, 1], random_cols[:, 2]))
###
###print("Sample SCF ITERATIONS table (first 5 rows):")
###print("Iteration | Random1 | Delta-E | Random2 | Random3")
###print("-" * 60)
###for i in range(min(5, data.shape[0])):
###    print(f"{data[i, 0]:9.0f} | {data[i, 1]:7.3f} | {data[i, 2]:7.3e} | {data[i, 3]:7.3f} | {data[i, 4]:7.3f}")
###print()

# ============================================================================
# STEP 2: Extract and preprocess data
# ============================================================================

def read_orca_out(filename):
    """
    Reads the SCF ITERATIONS table from orca.out and extracts iteration numbers and Delta-E values.
    
    Assumes the file contains whitespace-separated columns, where:
    - First column is iteration number
    - Third column (index 2) contains Delta-E values
    Ignores other columns.
    """
    iterations = []
    deltaE_vals = []
    
    with open(filename, 'r') as file:
        for line in file:
            # Strip line of whitespace and skip empty or malformed lines
            line = line.strip()
            if not line:
                continue
            
            # Skip header lines if necessary (e.g., if actual orca.out has)
            # For this example, assume all lines are data
            
            # Split line by whitespace or '|'
            parts = line.replace('|', ' ').split()
            
            # Expect at least 3 columns (iteration, ..., Delta-E)
            if len(parts) < 3:
                continue
            
            try:
                iteration = int(parts[0])
                deltaE = float(parts[2])
            except ValueError:
                # Skip any lines that cannot be parsed
                continue
            
            iterations.append(iteration)
            deltaE_vals.append(deltaE)
    
    return np.array(iterations), np.array(deltaE_vals)

# Usage example with previously saved orca.out file:
# Make sure the orca.out file contains the sample data exactly as shown in your message
iterations, deltaE = read_orca_out('orca.out')

# Now filter the data from iteration 5 to 14
start_iter = 5
end_iter = 14
# Filter data for the specified iteration range
mask = (iterations >= start_iter) & (iterations <= end_iter)
# Extract x (iteration numbers) and y (Delta-E values)
x = iterations[mask]     # Column 0: iterations
y_deltaE = deltaE[mask]  # Column 2: Delta-E

# Convert to log10 scale for regression
y = np.log10(np.abs(y_deltaE))


# ============================================================================
# STEP 3: Perform linear regression
# ============================================================================

# Use numpy.polyfit for least-squares polynomial fitting
# polyfit(x, y, 1) fits a degree-1 polynomial (straight line)
# Returns [slope, intercept]
slope, intercept = np.polyfit(x, y, 1)

# Define the regression line function
def regression_line(x_val):
    return slope * x_val + intercept

# Print results
print(f"Linear Regression Results (iterations {start_iter} to {end_iter}):")
print(f"  Slope:     {slope:.6f}")
print(f"  Intercept: {intercept:.6f}")
print(f"  Equation:  y = {slope:.6f}*x + {intercept:.6f}")
print()

# ============================================================================
# STEP 4: Create plot
# ============================================================================

plt.figure(figsize=(10, 6))

# Plot the data points as blue scatter points
plt.scatter(x, y, color='blue', s=100, label='log₁₀(|ΔE|) data points', 
            edgecolors='darkblue', linewidth=1.5, zorder=3)

# Plot the regression line in red
x_fit = np.linspace(start_iter - 0.5, end_iter + 0.5, 100)
y_fit = regression_line(x_fit)
plt.plot(x_fit, y_fit, color='red', linewidth=2.5, 
         label=f'Linear fit: y = {slope:.4f}·x + {intercept:.4f}', zorder=2)

# Formatting
plt.title('SCF Iterations: Delta-E Linear Regression (log₁₀ scale)', 
          fontsize=14, fontweight='bold')
plt.xlabel('Iteration Number', fontsize=12)
plt.ylabel('log₁₀(|Δ E|)', fontsize=12)
plt.legend(fontsize=11, loc='best', framealpha=0.95)
plt.grid(True, alpha=0.3, linestyle='--')
plt.xlim(start_iter - 1, end_iter + 1)
plt.tight_layout()
plt.show()