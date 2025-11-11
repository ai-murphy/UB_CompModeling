# Task: HOMO-LUMO Gap Analysis from Gaussian Output
## Complete Walkthrough and Implementation Guide

---

## Table of Contents
1. [Scientific Background](#scientific-background)
2. [Problem Overview](#problem-overview)
3. [Code Snippets and Explanations](#code-snippets-and-explanations)
4. [Complete Solution](#complete-solution)
5. [Sample Data](#sample-data)
6. [Running the Solution](#running-the-solution)

---

## Scientific Background

### What are HOMO and LUMO?

**HOMO (Highest Occupied Molecular Orbital)**
- The molecular orbital with the **highest energy** that actually contains electrons
- Represents the "valence" electrons available for chemical reactions
- In a molecular orbital diagram, it's the topmost filled level
- Higher HOMO energy → molecule is more easily oxidized → more nucleophilic
- Appears in the **occupied** (occ) eigenvalues list

**LUMO (Lowest Unoccupied Molecular Orbital)**
- The molecular orbital with the **lowest energy** that is currently empty
- Represents the lowest energy states available for incoming electrons
- In a molecular orbital diagram, it's the lowest unfilled level
- Lower LUMO energy → molecule is more easily reduced → more electrophilic
- Appears in the **virtual** (virt) eigenvalues list

### Why is the HOMO-LUMO Gap Important?

The **energy gap** between HOMO and LUMO is one of the most important molecular properties:

| Property | Effect |
|----------|--------|
| **Stability** | Larger gap = more stable molecule; Smaller gap = more reactive |
| **Optical Properties** | Gap determines absorption/emission wavelengths (λ ∝ 1/E_gap) |
| **Electrical Conductivity** | Smaller gap = better electron transport = better conductor |
| **Chemical Reactivity** | Smaller gap = easier to excite electrons = more reactive |
| **Optimization Convergence** | Stabilization of gap indicates approaching equilibrium geometry |

### Occupied vs. Virtual Eigenvalues: Why Track Both?

In quantum chemistry, molecular orbitals are classified by occupation:

- **Occupied (occ) eigenvalues**: Orbitals filled with electrons in the ground state
  - For a closed-shell system with N electrons, the first N/2 orbitals are occupied
  - These define the ground state electronic structure
  - HOMO is the **maximum** of this list

- **Virtual (virt) eigenvalues**: Orbitals empty in the ground state
  - These orbitals can accept electrons during excitation or reaction
  - Define the electronic states available for excited states
  - LUMO is the **minimum** of this list

**Why both matter during optimization:**
1. During geometric optimization, electrons rearrange to minimize total energy
2. The occupied orbital energies change as the molecular geometry changes
3. The virtual orbital energies also shift
4. **Convergence is reached** when the HOMO-LUMO gap stabilizes (stops changing significantly)
5. Tracking both allows you to see the system approaching its equilibrium configuration

---

## Problem Overview

**Task Requirements:**
- Parse a Gaussian output file (`piri.log`) from a geometry optimization
- For each optimization step, extract:
  - The HOMO orbital energy (highest occupied eigenvalue)
  - The LUMO orbital energy (lowest virtual eigenvalue)
  - Calculate the HOMO-LUMO gap: E_gap = E_LUMO - E_HOMO
- Create a plot showing how the gap evolves across optimization steps
- The plot should resemble an evolutionary profile with steps gradually stabilizing

**Key Challenge:** The Gaussian output has multiple occurrences of eigenvalue data (one per optimization step), and you need to parse them all sequentially.

---

## Code Snippets and Explanations

### Step 1: Reading and Parsing the Gaussian File

```python
import re

def parse_gaussian_log(filename):
    """
    The core parsing function that extracts HOMO and LUMO from Gaussian output.
    
    Strategy:
    1. Read the file line by line
    2. Identify lines containing "Alpha occ. eigenvalues"
    3. Extract the numerical values from these lines
    4. Look for the corresponding "Alpha virt. eigenvalues" line
    5. Extract the virtual eigenvalues
    6. Calculate HOMO (max of occupied) and LUMO (min of virtual)
    7. Calculate the gap
    """
    homo_energies = []
    lumo_energies = []
    
    with open(filename, 'r') as f:
        lines = f.readlines()
    
    # Iterate through each line
    for i, line in enumerate(lines):
        # Check if this line contains occupied eigenvalues
        if 'Alpha occ. eigenvalues' in line:
            try:
                # Split on '--' to separate the label from the numbers
                # Example: "Alpha occ. eigenvalues --  -10.18456  -10.17832  ..."
                parts = line.split('--')
                
                if len(parts) > 1:
                    # Convert the string of numbers to a list of floats
                    occ_values = [float(x) for x in parts[1].split()]
                    
                    # Check if the next line has virtual eigenvalues
                    if i + 1 < len(lines) and 'Alpha virt. eigenvalues' in lines[i + 1]:
                        virt_line = lines[i + 1]
                        virt_parts = virt_line.split('--')
                        
                        if len(virt_parts) > 1:
                            virt_values = [float(x) for x in virt_parts[1].split()]
                            
                            # HOMO = highest energy occupied orbital
                            # (most positive, closest to zero)
                            homo_energy = max(occ_values)
                            homo_energies.append(homo_energy)
                            
                            # LUMO = lowest energy virtual orbital
                            # (least positive, closest to zero)
                            lumo_energy = min(virt_values)
                            lumo_energies.append(lumo_energy)
            except ValueError:
                # Skip lines that don't parse correctly
                pass
    
    # Calculate the gap: E_gap = E_LUMO - E_HOMO
    # This is always positive for a stable system (LUMO > HOMO)
    gap_energies = [lumo - homo for homo, lumo in zip(homo_energies, lumo_energies)]
    
    return homo_energies, lumo_energies, gap_energies
```

**Key Parsing Tricks:**
1. **String splitting**: Use `.split('--')` to separate the label from the data
2. **Float conversion**: Apply `float()` to each token in `.split()`
3. **Sequential iteration**: Check `lines[i+1]` after finding an "occ" line to get the corresponding "virt" line
4. **Extrema identification**: 
   - HOMO = `max(occ_values)` (highest energy occupied)
   - LUMO = `min(virt_values)` (lowest energy unoccupied)
5. **Error handling**: Use try-except to skip malformed lines without crashing

---

### Step 2: Understanding the Energy Ordering

In Gaussian output, eigenvalues are typically printed from lowest to highest energy. For example:

```
Alpha occ. eigenvalues --  -10.18456  -10.17832   -1.05643   -0.89234   -0.76543   -0.65432
Alpha virt. eigenvalues --    0.12345    0.34567    0.56789    1.02345    1.34567    1.67890
```

This means:
- **Occupied orbitals** (negative energies): The numbers increase from left to right
  - HOMO = **-0.65432** eV (rightmost, highest energy of occupied)
  - Deeper electrons are more negative (lower energy) on the left

- **Virtual orbitals** (positive energies): The numbers increase from left to right
  - LUMO = **0.12345** eV (leftmost, lowest energy of unoccupied)
  - Higher virtual orbitals are more positive (higher energy) on the right

**Mathematical Relationship:**
```
E_gap = E_LUMO - E_HOMO = 0.12345 - (-0.65432) = 0.77777 eV
```

---

### Step 3: Creating the Visualization

```python
import matplotlib.pyplot as plt

def plot_homo_lumo_gap(homo_list, lumo_list, gap_list, output_file='homo_lumo_plot.png'):
    """
    Create a professional-quality plot of the HOMO-LUMO gap evolution.
    """
    # Create list of optimization step numbers
    optimization_steps = list(range(1, len(gap_list) + 1))
    
    # Create figure with appropriate size
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Plot the data points connected by lines
    ax.plot(optimization_steps, gap_list, 
            'o-',                          # Circle markers with line
            linewidth=2.5,                 # Line thickness
            markersize=8,                  # Marker size
            color='#2E86AB',               # Line color (blue)
            markerfacecolor='#A23B72',     # Marker fill (red)
            markeredgewidth=2,             # Marker edge thickness
            markeredgecolor='#2E86AB')     # Marker edge color
    
    # Configure axes labels and title
    ax.set_xlabel('Optimization Step', fontsize=12, fontweight='bold')
    ax.set_ylabel('Energy Gap (eV)', fontsize=12, fontweight='bold')
    ax.set_title('Evolution of HOMO-LUMO Energy Gap During Geometry Optimization', 
                 fontsize=13, fontweight='bold', pad=15)
    
    # Set x-axis to show each step as an integer
    ax.set_xticks(optimization_steps)
    
    # Add grid for readability
    ax.grid(True, alpha=0.3, linestyle='--')
    
    # Save the figure at high resolution
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"Plot saved as '{output_file}'")
    plt.close()
```

**Plot Interpretation:**
- **Downward trend**: Gap is decreasing as geometry optimizes (normal behavior)
- **Flattening curve**: Gap stabilization indicates convergence
- **Oscillations**: May indicate numerical issues or poor convergence settings
- **Final value**: The stable gap is characteristic of the optimized molecule

---

### Step 4: Analyzing Convergence

```python
def analyze_convergence(gap_energies, threshold=0.001):
    """
    Determine if the optimization has converged based on gap stability.
    
    Convergence criterion: Gap change between steps < threshold (default 1 meV)
    """
    if len(gap_energies) < 2:
        return None, 0.0
    
    # Calculate change in gap between consecutive steps
    gap_changes = [abs(gap_energies[i+1] - gap_energies[i]) 
                   for i in range(len(gap_energies)-1)]
    
    # Find maximum change
    max_gap_change = max(gap_changes)
    
    # Find first step where change is below threshold
    convergence_step = None
    for step, change in enumerate(gap_changes, 1):
        if change < threshold:
            convergence_step = step
            break
    
    return convergence_step, max_gap_change
```

---

## Complete Solution

Here is the fully functional Python script that solves the task:

```python
#!/usr/bin/env python3
"""
HOMO-LUMO Gap Analysis from Gaussian Output
with parsing, analysis, and visualization.
"""

import re
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path


def parse_gaussian_log(filename):
    """
    Parse Gaussian output file to extract HOMO and LUMO eigenvalues.
    Returns lists of HOMO, LUMO, and gap energies for each optimization step.
    """
    homo_energies = []
    lumo_energies = []
    
    try:
        with open(filename, 'r') as f:
            lines = f.readlines()
    except FileNotFoundError:
        raise FileNotFoundError(f"File '{filename}' not found.")
    
    for i, line in enumerate(lines):
        if 'Alpha occ. eigenvalues' in line:
            try:
                parts = line.split('--')
                if len(parts) > 1:
                    occ_values = [float(x) for x in parts[1].split()]
                    
                    if i + 1 < len(lines) and 'Alpha virt. eigenvalues' in lines[i + 1]:
                        virt_line = lines[i + 1]
                        virt_parts = virt_line.split('--')
                        
                        if len(virt_parts) > 1:
                            virt_values = [float(x) for x in virt_parts[1].split()]
                            
                            homo_energy = max(occ_values)
                            homo_energies.append(homo_energy)
                            
                            lumo_energy = min(virt_values)
                            lumo_energies.append(lumo_energy)
            except ValueError:
                pass
    
    gap_energies = [lumo - homo for homo, lumo in zip(homo_energies, lumo_energies)]
    
    return homo_energies, lumo_energies, gap_energies


def plot_homo_lumo_gap(homo_list, lumo_list, gap_list, output_file='homo_lumo_plot.png'):
    """Create and save the HOMO-LUMO gap evolution plot."""
    optimization_steps = list(range(1, len(gap_list) + 1))
    
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.plot(optimization_steps, gap_list, 'o-', 
            linewidth=2.5, markersize=8, 
            color='#2E86AB', markerfacecolor='#A23B72', 
            markeredgewidth=2, markeredgecolor='#2E86AB',
            label='HOMO-LUMO Gap')
    
    ax.set_xlabel('Optimization Step', fontsize=12, fontweight='bold')
    ax.set_ylabel('Energy Gap (eV)', fontsize=12, fontweight='bold')
    ax.set_title('Evolution of HOMO-LUMO Energy Gap During Geometry Optimization', 
                 fontsize=13, fontweight='bold', pad=15)
    
    ax.set_xticks(optimization_steps)
    ax.grid(True, alpha=0.3, linestyle='--')
    ax.legend(fontsize=11)
    
    plt.tight_layout()
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"✓ Plot saved as '{output_file}'")
    plt.close()


def print_summary(homo_list, lumo_list, gap_list):
    """Print analysis summary statistics."""
    print("\n" + "="*70)
    print("HOMO-LUMO GAP ANALYSIS SUMMARY")
    print("="*70)
    
    print(f"\nNumber of optimization steps: {len(gap_list)}")
    
    print(f"\nHOMO Energies (eV):")
    print(f"  Initial: {homo_list[0]:8.5f}")
    print(f"  Final:   {homo_list[-1]:8.5f}")
    print(f"  Change:  {homo_list[-1] - homo_list[0]:8.5f}")
    
    print(f"\nLUMO Energies (eV):")
    print(f"  Initial: {lumo_list[0]:8.5f}")
    print(f"  Final:   {lumo_list[-1]:8.5f}")
    print(f"  Change:  {lumo_list[-1] - lumo_list[0]:8.5f}")
    
    print(f"\nHOMO-LUMO Gap (eV):")
    print(f"  Initial: {gap_list[0]:8.5f}")
    print(f"  Final:   {gap_list[-1]:8.5f}")
    print(f"  Change:  {gap_list[-1] - gap_list[0]:8.5f}")
    print(f"  Min gap: {min(gap_list):8.5f}")
    print(f"  Max gap: {max(gap_list):8.5f}")
    
    print("\n" + "="*70 + "\n")


def main():
    """Main execution function."""
    print("\n" + "="*70)
    print("GAUSSIAN HOMO-LUMO GAP ANALYSIS TOOL")
    print("="*70 + "\n")
    
    if not Path('piri.log').exists():
        print("ERROR: piri.log not found!")
        return
    
    print("Parsing piri.log...")
    homo_list, lumo_list, gap_list = parse_gaussian_log('piri.log')
    
    if not gap_list:
        print("ERROR: No eigenvalue data found!")
        return
    
    print(f"✓ Successfully extracted data from {len(gap_list)} optimization steps")
    
    print_summary(homo_list, lumo_list, gap_list)
    
    print("Generating plot...")
    plot_homo_lumo_gap(homo_list, lumo_list, gap_list)
    
    print("✓ Analysis complete!\n")


if __name__ == '__main__':
    main()
```

---

## Sample Data

Create a file named `piri.log` with the following content to test the solution:

```
 --Link1--
 # B3LYP/6-31G(d) Opt

 Initial optimization step
 
 Alpha occ. eigenvalues --  -10.18456  -10.17832   -1.05643   -0.89234   -0.76543   -0.65432
 Alpha virt. eigenvalues --    0.12345    0.34567    0.56789    1.02345    1.34567    1.67890

 --Link1--
 # B3LYP/6-31G(d) Opt

 Optimization step 2
 
 Alpha occ. eigenvalues --  -10.19234  -10.18643   -1.06123   -0.89876   -0.77123   -0.66234
 Alpha virt. eigenvalues --    0.11234    0.33456    0.55678    1.01234    1.33456    1.66789

 --Link1--
 # B3LYP/6-31G(d) Opt

 Optimization step 3
 
 Alpha occ. eigenvalues --  -10.19876  -10.19234   -1.06543   -0.90234   -0.77543   -0.66765
 Alpha virt. eigenvalues --    0.10543    0.32789    0.55012    1.00567    1.32789    1.66123

 --Link1--
 # B3LYP/6-31G(d) Opt

 Optimization step 4
 
 Alpha occ. eigenvalues --  -10.20123  -10.19567   -1.06789   -0.90456   -0.77765   -0.66987
 Alpha virt. eigenvalues --    0.10123    0.32345    0.54567    1.00123    1.32345    1.65678

 --Link1--
 # B3LYP/6-31G(d) Opt

 Optimization step 5
 
 Alpha occ. eigenvalues --  -10.20345  -10.19789   -1.07012   -0.90678   -0.77987   -0.67209
 Alpha virt. eigenvalues --    0.09876    0.32012    0.54234    0.99876    1.32012    1.65345

 --Link1--
 # B3LYP/6-31G(d) Opt

 Optimization step 6
 
 Alpha occ. eigenvalues --  -10.20456  -10.19876   -1.07123   -0.90789   -0.78098   -0.67320
 Alpha virt. eigenvalues --    0.09654    0.31789    0.54012    0.99654    1.31789    1.65123

 --Link1--
 # B3LYP/6-31G(d) Opt

 Optimization step 7
 
 Alpha occ. eigenvalues --  -10.20523  -10.19943   -1.07234   -0.90876   -0.78165   -0.67387
 Alpha virt. eigenvalues --    0.09432    0.31567    0.53789    0.99432    1.31567    1.64901

 --Link1--
 # B3LYP/6-31G(d) Opt

 Optimization step 8
 
 Alpha occ. eigenvalues --  -10.20567  -10.19987   -1.07312   -0.90932   -0.78223   -0.67445
 Alpha virt. eigenvalues --    0.09234    0.31345    0.53567    0.99234    1.31345    1.64679

 Job completed
```

---

## Running the Solution

1. **Save the script**: Copy the complete solution code to `orbitalopt.py`

2. **Create sample data**: Save the sample data to `piri.log` in the same directory

3. **Install dependencies** (if not already installed):
   ```bash
   pip install numpy matplotlib
   ```

4. **Run the script**:
   ```bash
   python orbitalopt.py
   ```

5. **Expected output**:
   - Console summary with statistics
   - `homo_lumo_plot.png` showing the gap evolution
   - Confirmation messages for each step

---

## Key Takeaways

✓ **HOMO** = max(occupied eigenvalues) — the highest occupied orbital
✓ **LUMO** = min(virtual eigenvalues) — the lowest unoccupied orbital
✓ **Gap** = LUMO − HOMO — always positive for stable molecules
✓ **Parsing strategy** = Sequential line-by-line search for "Alpha occ." and "Alpha virt." pairs
✓ **Convergence indicator** = Gap stabilization shows the molecule is approaching equilibrium geometry
✓ **Visualization** = Scatter plot with connecting lines shows evolutionary profile across optimization steps

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| FileNotFoundError | Ensure `piri.log` is in the same directory as the script |
| No data extracted | Check that `piri.log` has the correct section headers ("Alpha occ." and "Alpha virt.") |
| Plot not saving | Ensure write permissions in the directory; check disk space |
| Negative gap values | This shouldn't happen; check for data format issues or reversed HOMO/LUMO |
