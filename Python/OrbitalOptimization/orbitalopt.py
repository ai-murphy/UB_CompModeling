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