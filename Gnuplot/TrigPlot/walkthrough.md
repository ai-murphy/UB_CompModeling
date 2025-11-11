# TrigPlot Gnuplot Walkthrough

## Overview
This exercise requires creating a visualization of the function:
```
z(x,y) = sin(x) * cos(y) + 0.2 * x * y
```
over the domain x ∈ [-5, 5], y ∈ [-3, 3]

The exercise requires:
1. Generate sample data (`values.dat`) with a 50×30 grid
2. Create a 3D surface plot with contours at the base (contour levels every 0.5)
3. Create a 2D contour plot showing only the level curves
4. Add axis labels (x, y, z)
5. Mark the relative maximum with an arrow and "Max" label
6. Save both plots in graphic format (jpg, png, or eps)

---

## Part 1: Python Data Generation

### Understanding the Data Format for Gnuplot

Gnuplot expects 3D data in a specific format:
- **Format**: `x y z` (tab or space-separated)
- **Row Separation**: Blank lines separate data rows (important for `splot` command)
- **Grid Structure**: Data should be organized so that consecutive points along x-axis are followed by a blank line

### Complete Python Script

```python
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
```

### Key Points:
- **Meshgrid**: Creates 2D coordinate arrays from 1D x and y arrays
- **Blank Lines**: Essential for gnuplot to recognize row breaks in 3D data
- **Precision**: Using `.6f` format ensures adequate precision for smooth plots
- **Loop Order**: Iterate y in outer loop, x in inner loop for proper grid organization

---

## Part 2: Gnuplot Script Essentials

### Finding the Maximum

The function \(z(x,y) = \sin(x) \cos(y) + 0.2xy\) has its maximum at approximately:
- **Location**: x ≈ 1.5, y ≈ 1.5
- **Value**: z ≈ 0.997 + 0.45 ≈ 1.45

You can estimate this by analyzing the derivative or simply finding where the function reaches its peak value within the domain.

### Gnuplot Tips & Tricks

#### 1. Setting up the Terminal
```gnuplot
set terminal pngcairo size 1024,768  # For PNG output
# Alternative: set terminal jpeg size 1024,768
# Alternative: set terminal postscript color  # For EPS
set output 'filename.png'
```

#### 2. Contour Levels
```gnuplot
set contour base           # Shows contours at the base of 3D plot
set cntrparam levels 0.5   # Contour spacing of 0.5
```
**Important**: For 2D contour plots, use `set view 0,0` or `set view map`

#### 3. Axis Labels
```gnuplot
set xlabel "x"
set ylabel "y"
set zlabel "z"
```

#### 4. Adding Arrows and Labels
```gnuplot
set arrow 1 from 1.5, 1.5, 0 to 1.5, 1.5, 1.5 head lw 2
set label "Max" at 1.5, 1.5, 1.8
```
**Note**: Coordinates are (x, y, z) for arrow endpoints. Adjust z-coordinates based on your plot range.

#### 5. Range Settings
```gnuplot
set xrange [-5:5]
set yrange [-3:3]
set zrange [-5:5]  # Generous range to accommodate all values
```

#### 6. Plotting Data
```gnuplot
splot 'values.dat' with lines  # 3D surface plot
plot 'values.dat' with lines   # 2D contour plot
```

#### 7. Output and Display
```gnuplot
set output 'output.png'
replot  # Executes the plot and writes to file
```

---

## Part 3: Complete Gnuplot Scripts

### 3D Surface Plot with Contours (`plot3d.gp`)

```gnuplot
#!/usr/bin/env gnuplot

# Configure output
set terminal pngcairo size 1024,768 font "Arial,12"
set output '3d_surface.png'

# Set ranges
set xrange [-5:5]
set yrange [-3:3]
set zrange [-5:5]

# Configure contours
set contour base
set cntrparam levels 0.5
set style increment default

# Label axes
set xlabel "x" offset 0,0,0
set ylabel "y" offset 0,0,0
set zlabel "z" offset 0,0,0

# Title
set title "3D Surface Plot: z(x,y) = sin(x)cos(y) + 0.2xy"

# Add arrow pointing to maximum
set arrow 1 from 1.5, 1.5, 0 to 1.5, 1.5, 1.5 head lw 2 lc rgb "red"
set label "Max" at 1.5, 1.5, 1.8 font "Arial,14" textcolor rgb "red"

# Plot the data
splot 'values.dat' with lines lc rgb "blue" title "z(x,y)"
```

### 2D Contour Plot (`plot2d.gp`)

```gnuplot
#!/usr/bin/env gnuplot

# Configure output
set terminal pngcairo size 1024,768 font "Arial,12"
set output '2d_contour.png'

# Set 2D view (flat/map view)
set view map

# Set ranges
set xrange [-5:5]
set yrange [-3:3]

# Configure contours
set contour base
set cntrparam levels 0.5

# Label axes
set xlabel "x" offset 0,0,0
set ylabel "y" offset 0,0,0

# Title
set title "2D Contour Plot: z(x,y) = sin(x)cos(y) + 0.2xy"

# Add arrow to maximum (now in 2D coordinates)
set arrow 1 from 1.5, 1.5 to 1.7, 1.7 head lw 2 lc rgb "red"
set label "Max" at 1.8, 1.8 font "Arial,14" textcolor rgb "red"

# Plot the data as 2D contour
plot 'values.dat' with lines lc rgb "blue" title "Level Curves"
```

---

## Part 4: Running the Complete Solution

### Step-by-Step Execution

```bash
# Step 1: Generate the data file
python3 generate_data.py

# Step 2: Create the 3D plot
gnuplot plot3d.gp

# Step 3: Create the 2D plot
gnuplot plot2d.gp

# Verify output files
ls -lh *.png
```

### Expected Output Files
- `values.dat` - Data file (50×30 grid)
- `3d_surface.png` - 3D surface with base contours
- `2d_contour.png` - 2D contour map

---

## Part 5: Complete Working Codeset

### File 1: `generate_data.py`

```python
#!/usr/bin/env python3
import numpy as np

def generate_values_dat():
    """Generate values.dat for Exercise 4"""
    x_points = 50
    y_points = 30
    
    x = np.linspace(-5, 5, x_points)
    y = np.linspace(-3, 3, y_points)
    X, Y = np.meshgrid(x, y)
    Z = np.sin(X) * np.cos(Y) + 0.2 * X * Y
    
    output_lines = []
    for i in range(y_points):
        for j in range(x_points):
            output_lines.append(f"{X[i,j]:.6f} {Y[i,j]:.6f} {Z[i,j]:.6f}")
        output_lines.append("")
    
    with open('values.dat', 'w') as f:
        f.write('\n'.join(output_lines))
    
    print(f"Generated values.dat: {x_points}x{y_points} grid")
    print(f"Z range: [{Z.min():.4f}, {Z.max():.4f}]")

if __name__ == "__main__":
    generate_values_dat()
```

### File 2: `plot3d.gp`

```gnuplot
#!/usr/bin/env gnuplot

set terminal pngcairo size 1024,768 font "Arial,12"
set output '3d_surface.png'

set xrange [-5:5]
set yrange [-3:3]
set zrange [-5:5]

set contour base
set cntrparam levels 0.5

set xlabel "x"
set ylabel "y"
set zlabel "z"

set title "3D Surface Plot: z(x,y) = sin(x)cos(y) + 0.2xy"

set arrow 1 from 1.5, 1.5, 0 to 1.5, 1.5, 1.5 head lw 2 lc rgb "red"
set label "Max" at 1.5, 1.5, 1.8 font "Arial,14" textcolor rgb "red"

splot 'values.dat' with lines lc rgb "blue"
```

### File 3: `plot2d.gp`

```gnuplot
#!/usr/bin/env gnuplot

set terminal pngcairo size 1024,768 font "Arial,12"
set output '2d_contour.png'

set view map

set xrange [-5:5]
set yrange [-3:3]

set contour base
set cntrparam levels 0.5

set xlabel "x"
set ylabel "y"

set title "2D Contour Plot: z(x,y) = sin(x)cos(y) + 0.2xy"

set arrow 1 from 1.5, 1.5 to 1.7, 1.7 head lw 2 lc rgb "red"
set label "Max" at 1.8, 1.8 font "Arial,14" textcolor rgb "red"

plot 'values.dat' with lines lc rgb "blue"
```

---

## Troubleshooting & Common Issues

### Issue: "Contours not appearing in 3D plot"
**Solution**: Ensure `set contour base` is set before plotting. Also verify data format has blank lines between rows.

### Issue: "Data file not found"
**Solution**: Make sure you're in the correct directory and the `values.dat` file was generated successfully.

### Issue: "2D plot shows nothing"
**Solution**: Use `set view map` to enable top-down view. Without this, gnuplot still tries to show a 3D projection.

### Issue: "Arrow is invisible or misplaced"
**Solution**: 
- For 3D plots, use 3D coordinates: `from x,y,z to x,y,z`
- For 2D plots, use 2D coordinates: `from x,y to x,y`
- Adjust coordinates to be within your data range

### Issue: "PNG file is blank"
**Solution**: 
- Set output file before plot command: `set output 'file.png'`
- Call `replot` or re-execute the plot command after setting output
- Check terminal compatibility: use `set terminal pngcairo` for modern systems

---

## Learning Resources

### Key Gnuplot Concepts
- **splot**: Surface plot (3D data)
- **plot**: 2D line/contour plot
- **Meshgrid**: Creates 2D coordinate arrays from 1D vectors
- **Blank Lines**: Critical for gnuplot to parse matrix data correctly

### Data Format Example
```
x1 y1 z1
x2 y1 z1
x3 y1 z1
...
          (blank line)
x1 y2 z1
x2 y2 z1
...
```

### Function Analysis
The partial derivatives help understand extrema:
- \(\frac{\partial z}{\partial x} = \cos(x)\cos(y) + 0.2y = 0\)
- \(\frac{\partial z}{\partial y} = -\sin(x)\sin(y) + 0.2x = 0\)

Solving numerically gives the maximum approximately at (1.5, 1.5).
