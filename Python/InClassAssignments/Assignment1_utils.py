import numpy as np

def lj(r: float, eps: float = 1., sigma: float = 1.) -> float:
    """Calculates the LJ potential given:
       - r:     the distance between 2 particles
       - eps:   the epsilon parameter (defaults to 1.0)
       - sigma: the sigma parameter (defaults to 1.0)
       
       NOTE - Lennard-Jones potential is defined as
       V_LJ (r) = 4*eps * ((sigma/r)^^12 - (sigma/r)^^6)
       
       Returns:
       - energy: the potential energy"""
    
    sigr6 = (sigma / r)**6
    sigr12 = (sigma / r)**12
    energy = 4 * eps * (sigr12 - sigr6)

    return energy

def total_e(distances: np.array, eps: float = 1., sigma: float = 1.) -> float:
    """Calculates the total energy of a system, as the sum of all LJ interactions
       - distances: the distances between particles, as a numpy array which may be 1D (flat) or 2D (squareform)
       - eps:       epsilon value passed to lj function
       - sigma:     sigma value passed to lj function

       Requires:
       - numpy
       - lj function

       Returns:
       - (float): total energy of a system
    """

    if len(distances.shape) == 1:
        oneDarray = distances
    #2D array handling
    elif len(distances.shape) == 2:
        #passed in as squareform; check the diagonal and just return the unique pairwise distances
        if distances.diagonal().min() == distances.diagonal().max():
            oneDarray = distances[np.triu_indices(distances.shape[0],k=1)]
        #not squareform, user may have passed in coordinates instead of distances
        else:
            return "Error: 2D array passed is not squareform. Ensure array is of distances, not coordinates."
    else:
        return "Error: array must be 1D or 2D"
    
    return np.sum([lj(d) for d in oneDarray])