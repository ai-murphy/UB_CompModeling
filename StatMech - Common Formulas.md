

# Common formulas used in Statistical Mechanics.

Here is a concise list of the most common formulas used in statistical mechanics, including both general definitions and relationships for thermodynamic potentials, ensembles, and physical observables:

## Temperature and Energy Relations

- Boltzmann constant: $$ k_B $$
- Reciprocal temperature (often used): $$ \beta = \frac{1}{k_B T} $$
- Equipartition theorem: Each quadratic degree of freedom contributes $$ \frac{1}{2}k_B T $$ to internal energy.


## Partition Functions and Ensembles

- **Microcanonical Ensemble**:
    - Number of microstates at energy $$ E $$: $$ \Omega(E) $$
    - Entropy: $$ S(E,V,N) = k_B \ln \Omega(E) $$
- **Canonical Ensemble**:
    - Partition function: $$ Z = \sum_i e^{-\beta E_i} $$
    - Probability of state $$ i $$: $$ P_i = \frac{e^{-\beta E_i}}{Z} $$
    - Helmholtz free energy: $$ F = -k_B T \ln Z $$
    - Internal energy: $$ U = - \frac{\partial}{\partial \beta} \ln Z $$
    - Energy fluctuations: $$ \langle (\Delta E)^2 \rangle = k_B T^2 C_v $$
- **Grand Canonical Ensemble**:
    - Grand partition function: $$ \mathcal{Z} = \sum_{N} \sum_{i} e^{\beta \mu N} e^{-\beta E_{i,N}} $$
    - Pressure: $$ P = k_B T \frac{\partial}{\partial V} \ln \mathcal{Z} $$


## Thermodynamic Potentials

- **Internal Energy**: $$ dE = T dS - P dV + \mu dN $$
- **Helmholtz Free Energy**: $$ F = E - T S $$
- **Gibbs Free Energy**: $$ G = E - T S + P V $$
- **Enthalpy**: $$ H = E + P V $$


## Connection to Observables

- **Mean value of observable**: $$ \langle A \rangle = \frac{1}{Z} \sum_i A_i e^{-\beta E_i} $$
- **Specific Heat at Constant Volume**: $$ C_v = \left( \frac{\partial U}{\partial T} \right)_V $$


## Distribution and Probability

- Boltzmann factor: $$ P_i \propto e^{-\beta E_i} $$
- Maxwell-Boltzmann speed distribution (ideal gas): $$ f(v) \propto v^2 e^{-\frac{mv^2}{2k_B T}} $$
- Chemical equilibrium: Law of mass action ($$ K = \frac{[Products]}{[Reactants]} $$) where $$ K $$ can be calculated from partition functions.


## Thermodynamic Derivatives

- Pressure from partition function: $$ P = k_B T \frac{\partial \ln Z}{\partial V} $$
- Entropy: $$ S = -k_B \sum_i P_i \ln P_i $$
- Chemical potential: $$ \mu = \left( \frac{\partial F}{\partial N} \right)_{T,V} $$


## Fluctuations

- Energy fluctuations in canonical ensemble: $$ \langle (\Delta E)^2 \rangle = k_B T^2 \left( \frac{\partial U}{\partial T} \right)_V $$
- Number fluctuations in grand canonical: $$ \langle (\Delta N)^2 \rangle = k_B T \left( \frac{\partial \langle N \rangle}{\partial \mu} \right)_{V,T} $$


## Example Physical Models

- Ideal Gas Law: $$ PV = Nk_B T $$
- Ising Model energy: $$ E = -J \sum_{\langle i,j \rangle} S_i S_j - h \sum_i S_i $$
- Diffusion: $$ \langle x^2 \rangle = 2 D t $$, where $$ D $$ is the diffusion constant.


## Derivatives and Free Energy

- Force from free energy: $$ F = -\left(\frac{\partial F}{\partial x}\right)_T $$
- Magnetization: $$ M = -\left( \frac{\partial F}{\partial H} \right)_T $$


