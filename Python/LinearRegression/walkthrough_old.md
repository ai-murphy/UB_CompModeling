# LinearRegression Walkthrough

## Overview

The exercise asks you to:

- Read the Delta-E column from the SCF ITERATIONS section of the "orca.out" output file.
- For iterations 5 through 14, compute and plot $\log_{10}(|\Delta E|)$.
- Fit a linear regression to this data, print the slope, and plot both points and the fitted line.
- Display the regression equation in the plot legend.


## Mathematical Background

- **Logarithm transformation:** Converting $\Delta E$ to $\log_{10}(|\Delta E|)$ emphasizes trend regularity in convergence.
- **Linear regression:** Fitting a line $y = mx + b$ is done using scipy's `linregress` for straightforward output of slope, intercept, and statistics.


## Python Code Walkthrough

### 1. Generate Sample Data for "orca.out"

Assume "orca.out" looks like:

```
SCF ITERATIONS
Iter       Delta-E
1      0.0081
2      0.0067
...
14     0.000044
```

A reasonable simulation for 14 iterations with exponentially decreasing energy differences:

```python
import numpy as np

iters = np.arange(1, 15)
delta_e = 0.01 * np.exp(-0.6 * (iters - 1))  # simulates convergence
```


### 2. Select Iterations 5 to 14

```python
data_iter = iters[4:14]    # Iterations 5-14 (Python 0-based index)
data_delta_e = delta_e[4:14]
```


### 3. Log Transformation

```python
log_delta_e = np.log10(np.abs(data_delta_e))
```


### 4. Linear Regression

Use scipy's `linregress`:

```python
from scipy.stats import linregress

slope, intercept, r_value, p_value, std_err = linregress(data_iter, log_delta_e)
```


### 5. Plotting with matplotlib

Include both scatter points and regression line, and show the regression function in the legend:

```python
import matplotlib.pyplot as plt

plt.figure(figsize=(8,5))
plt.scatter(data_iter, log_delta_e, color='blue', label='Data points')
plt.plot(data_iter, intercept + slope * data_iter, color='red', label=f'Fit: log₁₀(ΔE)={slope:.2f}·iter+{intercept:.2f}')
plt.xlabel('Iteration')
plt.ylabel('log10(abs(Delta-E))')
plt.title('SCF Convergence')
plt.legend()
plt.grid(True)
plt.show()

print(f'Slope of the fit: {slope:.3f}')
```


### 6. Sample Codeset (All-in-one)

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import linregress

# Generate sample data
iters = np.arange(1, 15)
delta_e = 0.01 * np.exp(-0.6 * (iters - 1))  # simulate exp convergence

# Exercise Section: Use iterations 5-14
data_iter = iters[4:14]
data_delta_e = delta_e[4:14]
log_delta_e = np.log10(np.abs(data_delta_e))

# Linear regression
slope, intercept, r_value, p_value, std_err = linregress(data_iter, log_delta_e)

# Plot
plt.figure(figsize=(8,5))
plt.scatter(data_iter, log_delta_e, color='blue', label='Data points')
plt.plot(data_iter, intercept + slope * data_iter, color='red', 
         label=f'Fit: log₁₀(ΔE)={slope:.2f}·iter+{intercept:.2f}')
plt.xlabel('Iteration')
plt.ylabel('log10(abs(Delta-E))')
plt.title('SCF Convergence')
plt.legend()
plt.grid(True)
plt.show()

print(f'Slope of the fit: {slope:.3f}')
```


## Tips and Tricks

- Use `np.log10` for precise logarithm calculation.
- Slicing in numpy (`[4:14]`) allows clean selection of iteration windows.
- Always visualize your regression line and data points together for clarity.
- Label your axes for interpretability.
- Print the regression equation in the legend for direct visual reference.

***

## Markdown Guide for Download

```markdown
# SCF Iterations Linear Fit Walkthrough (Python & matplotlib)

## Step-by-step instructions

1. **Generate sample data simulating Delta-E values for 14 SCF iterations**

```

import numpy as np

iters = np.arange(1, 15)
delta_e = 0.01 * np.exp(-0.6 * (iters - 1))

```

2. **Select iterations 5 through 14**

```

data_iter = iters[4:14]
data_delta_e = delta_e[4:14]

```

3. **Compute log10 of absolute Delta-E**

```

log_delta_e = np.log10(np.abs(data_delta_e))

```

4. **Fit linear regression**

```

from scipy.stats import linregress
slope, intercept, r_value, p_value, std_err = linregress(data_iter, log_delta_e)

```

5. **Plot data points and fit**

```

import matplotlib.pyplot as plt

plt.figure(figsize=(8,5))
plt.scatter(data_iter, log_delta_e, color='blue', label='Data points')
plt.plot(data_iter, intercept + slope * data_iter, color='red',
label=f'Fit: log₁₀(ΔE)={slope:.2f}·iter+{intercept:.2f}')
plt.xlabel('Iteration')
plt.ylabel('log10(abs(Delta-E))')
plt.title('SCF Convergence')
plt.legend()
plt.grid(True)
plt.show()

print(f'Slope of the fit: {slope:.3f}')

```

---

**Key points:**
- Use `numpy` for array math and slicing.
- Use `scipy.stats.linregress` for fits.
- Use `matplotlib` for visualization.
- Always annotate your plot with key info (fit equation, axis labels).
```

You can copy-paste the above markdown into a `.md` file for future reference.
<span style="display:none">[^1]</span>

<div align="center">⁂</div>

[^1]: 2021_Final.pdf

