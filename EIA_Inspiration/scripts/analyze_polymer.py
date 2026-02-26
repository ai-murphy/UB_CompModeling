# authored by: Person D
import numpy as np
import matplotlib.pyplot as plt
import os

def analyze():
    # Load energy data
    print("Loading energy.dat...")
    try:
        def fortran_float(s):
            s_str = s.decode('utf-8').upper()
            if 'E' not in s_str and '+' in s_str[1:]:
                # Handle cases like 0.108156+184
                s_str = s_str[0] + s_str[1:].replace('+', 'E+')
            elif 'E' not in s_str and '-' in s_str[1:]:
                s_str = s_str[0] + s_str[1:].replace('-', 'E-')
            return float(s_str)

        data = np.loadtxt('energy.dat', converters={1: fortran_float})
        steps = data[:, 0]
        energy = data[:, 1]
        acc_ratio = data[:, 2]
        ree = data[:, 3]
        rg = data[:, 4]

        # Plot Energy
        plt.figure(figsize=(10, 6))
        plt.plot(steps, energy, label='Total Energy')
        plt.xlabel('MC Step')
        plt.ylabel('Energy (kJ/mol)')
        plt.title('Energy Evolution')
        plt.grid(True)
        plt.legend()
        plt.savefig('energy_evolution.png')
        plt.close()

        # Plot Rg and R_ee
        plt.figure(figsize=(10, 6))
        plt.plot(steps, rg, label='Radius of Gyration ($R_g$)')
        plt.plot(steps, ree, label='End-to-End Distance ($R_{ee}$)', alpha=0.7)
        plt.xlabel('MC Step')
        plt.ylabel('Distance (Å)')
        plt.title('Structural Observables')
        plt.grid(True)
        plt.legend()
        plt.savefig('structural_observables.png')
        plt.close()
        print("Saved energy and structural plots.")
    except Exception as e:
        print(f"Error processing energy.dat: {e}")

    # Load trajectory data for torsions
    print("Loading trajectory.dat...")
    try:
        # Each row is: step, torsions...
        traj = np.loadtxt('trajectory.dat')
        torsions = traj[:, 1:] # Skip the step column
        
        # Flatten and plot histogram
        torsions_flat = torsions.flatten()
        
        plt.figure(figsize=(10, 6))
        plt.hist(torsions_flat, bins=100, range=(-180, 180), density=True, alpha=0.7, color='g')
        plt.xlabel('Torsion Angle (degrees)')
        plt.ylabel('Probability Density')
        plt.title('Torsion Angle Distribution')
        plt.grid(True)
        plt.savefig('torsion_distribution.png')
        plt.close()
        print("Saved torsion distribution plot.")
    except Exception as e:
        print(f"Error processing trajectory.dat: {e}")

if __name__ == '__main__':
    analyze()
