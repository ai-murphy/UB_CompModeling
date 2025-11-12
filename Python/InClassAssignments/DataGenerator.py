import numpy as np

def generate_data(seed=34567):
    """
    Generates 50 (x, y) data points using numpy's default_rng with a fixed seed.
    The x values are uniformly distributed and the y values are generated from 
    a linear relation with added noise.
    Unless you specify the seed, it always generates the same data.
    Input:
        seed (integer, or a valid seed, optional): the seed of the generator
    Returns:
        x (np.ndarray): Array of x values
        y (np.ndarray): Array of y values
    """
    rng = np.random.default_rng(seed)
    x = rng.uniform(0, 10, 50)
    noise = rng.normal(0, 1, 50)
    y = 2.5 * x + 5 + noise  # Linear relation with noise
    return x, y

