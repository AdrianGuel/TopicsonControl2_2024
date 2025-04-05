
# Phase Plane and Norms Visualization of an Autonomous Linear System

This project simulates a two-dimensional autonomous linear system in GNU Octave using the Euler integration method. It visualizes both the system's state evolution in the phase plane and the behavior of various vector norms over time.

## Overview

The system is defined by the following linear differential equation:

$$
\frac{d\mathbf{x}}{dt} = A \mathbf{x}
$$

with matrix:

$$
A = \begin{bmatrix}
-0.5 & -1 \\
1 & -0.5
\end{bmatrix}
$$

and initial condition:

$$
\mathbf{x}(0) = \begin{bmatrix}
1 \\
1
\end{bmatrix}
$$

This matrix results in a spiral convergence to the origin, which is a stable equilibrium point.

## Features

### Phase Plane Visualization

- The first subplot displays the phase portrait (i.e., the trajectory of the state vector $$\mathbf{x}(t)$$ in the $$x_1$$–$$x_2$$ plane).
- A red arrow illustrates the current state vector from the origin, highlighting the Euclidean distance from the equilibrium point.
- The trajectory is shown in blue as it converges toward the origin.

### Norms Plot

- The second subplot shows the evolution of three norms of the state vector over time:
  - **L1 norm (green)** – Manhattan norm:
    $$
    \|\mathbf{x}(t)\|_1 = |x_1(t)| + |x_2(t)|
    $$
  - **L2 norm (red)** – Euclidean norm:
    $$
    \|\mathbf{x}(t)\|_2 = \sqrt{x_1(t)^2 + x_2(t)^2}
    $$
  - **L∞ norm (blue)** – Maximum absolute value:
    $$
    \|\mathbf{x}(t)\|_\infty = \max\left(|x_1(t)|, |x_2(t)|\right)
    $$
- The L2 norm is always bounded by the L1 and L∞ norms, as expected by norm inequalities.

## Simulation Parameters

- Integration method: Explicit Euler
- Time step: $$\Delta t = 0.1$$ seconds
- Total simulation time: $$t_{\text{final}} = 10$$ seconds

## Requirements

- GNU Octave (recommended version: 6.0 or later)
- No additional toolboxes required

## Running the Simulation

Simply run the script in GNU Octave:

```octave
>> my_simulation_script.m
```

It will generate an animated figure with:
1. The state vector's trajectory in the phase plane.
2. Real-time updating plots of the L1, L2, and L∞ norms.
