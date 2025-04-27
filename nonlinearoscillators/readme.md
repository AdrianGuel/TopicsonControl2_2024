# Nonlinear Oscillator Models and Simulation Code

## Overview

This project provides a Python simulation framework to explore and visualize **nonlinear oscillators** through their **phase portraits**.
The code uses **Plotly** for interactive plotting and **SciPy** for numerical integration.

## Implemented Nonlinear Oscillator Models

### 1. Van der Pol Oscillator
- **Equation:**
  $$ \ddot{x} - \mu(1-x^2)\dot{x} + x = 0 $$
- **Characteristics:**
  - Nonlinear damping.
  - Exhibits limit cycles.
- **Parameters:**
  - `mu`: Nonlinearity/damping strength (default: `1.0`).

### 2. Duffing Oscillator
- **Equation:**
  $$ \ddot{x} + \delta \dot{x} + \alpha x + \beta x^3 = \gamma \cos(\omega t) $$
- **Characteristics:**
  - Double-well potential.
  - Can exhibit chaos.
- **Parameters:**
  - `delta`: Damping coefficient (default: `0.2`).
  - `alpha`: Linear stiffness (default: `-1`).
  - `beta`: Nonlinear stiffness (default: `1`).
  - `gamma`: Forcing amplitude (default: `0.3`).
  - `omega`: Forcing frequency (default: `1.2`).

### 3. Simple Pendulum
- **Equation:**
  $$ \ddot{\theta} + \frac{g}{l} \sin(\theta) = 0 $$
- **Characteristics:**
  - Nonlinear due to the sine function.
  - Small angle approximation yields simple harmonic motion.
- **Parameters:**
  - `g`: Gravitational acceleration (default: `9.81 m/s^2`).
  - `l`: Length of the pendulum (default: `1.0 m`).

### 4. Rayleigh Oscillator
- **Equation:**
  $$ \ddot{x} + \epsilon \left( \dot{x} - \frac{1}{3}\dot{x}^3 \right) + x = 0 $$
- **Characteristics:**
  - Self-excited oscillations.
- **Parameters:**
  - `epsilon`: Nonlinearity strength (default: `1.0`).


## Simulation and Plotting Features

- **Phase Portrait Generation**:
  - A **normalized vector field** is plotted to show the local dynamics.
  - **Multiple trajectories** are simulated from different initial conditions.
  - **Flow direction arrows** along trajectories.

- **Customization**:
  - All models can be parameterized easily.
  - The simulation region is fixed to \([-2, 2]\) for both position and velocity.

- **Interactive Visualization**:
  - Results are saved as a temporary HTML file.
  - Automatically opened in a web browser.


## Requirements

Install the necessary packages (if you haven't yet):

```bash
pip install numpy scipy plotly
```


## How to Run

```bash
poetry run python nonlinearoscillators.py
```

- The program will ask you to choose which oscillator to simulate.
- It will then display the corresponding phase portrait.


## Example of Use

Choosing the **Simple Pendulum** model will show:
- Closed orbits around the stable equilibrium (small oscillations).
- Open orbits representing full rotations.
- Clear separatrix between oscillation and rotation.


## Future Enhancements
- Add energy-based color maps for trajectories.
- Include equilibrium point markers.
- Support for additional oscillators like FitzHugh-Nagumo.
- Animate trajectories over time.

---

Enjoy exploring nonlinear dynamics! 🚀
