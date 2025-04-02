# Phase Space Analysis of a Second-Order LTI System with Initial Conditions

This repository contains an Octave script that visualizes the phase space trajectory and time-domain responses of a damped second-order linear time-invariant (LTI) system with a **non-zero initial condition** and external forcing. The animation demonstrates how initial conditions influence the system's transient and steady-state behavior.

## Purpose
- Visualize the impact of non-zero initial conditions on system trajectories.
- Animate the evolution of the system in both time-domain and phase space.
- Demonstrate the interplay between initial conditions and external forcing (sinusoidal input).

## Key Equations
### Second-Order System
The system is defined by:
$$\ddot{x}(t) + 0.5\dot{x}(t) + 0.5x(t) = \sin(t)$$

Converted to first-order form:

$$\dot{y}_1 = y_2$$
$$\dot{y}_2 = -0.5y_2 - 0.5y_1 + \sin(t)$$

where $y_1 = x(t)$ (position) and $y_2 = \dot{x}(t)$ (velocity).

### Initial Conditions

$$x(0) = 0.5, \quad \dot{x}(0) = 1$$

## Code Overview
### System Definition
```matlab
f = @(y, t) [y(2); -0.5*y(2) - 0.5*y(1) + sin(t)];  % ODE system
y0 = [0.5; 1];  % Initial conditions [x(0); x'(0)]
t_total = linspace(0, 20, 1000)';  % Time vector
sol = lsode(f, y0, t_total);       % Solve numerically
```

### Animation Setup
- **Subplot 1**: $x(t)$ vs. $t$ (position time series).
- **Subplot 2**: Phase space $x(t)$ vs. $\dot{x}(t)$.
- **Subplot 3**: $\dot{x}(t)$ vs. $t$ (velocity time series).
- Real-time markers (red circles) track the current state.

## Usage
1. Run the script in Octave:
   ```bash
   octave phase_space_animation.m
   ```
2. The animation will play automatically:
   - Duration: ~5 seconds.
   - The phase plot (middle subplot) shows the trajectory evolving from the initial condition (red marker).
   - Time-domain plots (left and right) update synchronously.

## Results
- **Phase Space Trajectory**: Spirals toward a limit cycle due to the damping and sinusoidal forcing.
- **Time-Domain Plots**: Show transient oscillations converging to a steady-state response.
- **Key Observations**:
  - Initial conditions affect the transient path but not the steady-state behavior.
  - The system exhibits damped oscillations modulated by the external $\sin(t)$ input.
