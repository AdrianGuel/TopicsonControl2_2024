# 3D Ball Dynamics on Stable/Unstable Equilibrium Surfaces

This repository contains an Octave script that animates a ball rolling on a 3D surface to demonstrate **stable** (valley) and **unstable** (peak) equilibrium points. The simulation shows how initial conditions and surface geometry determine whether the ball escapes from a peak or oscillates in a valley.

## Purpose
- Visualize equilibrium stability through 3D terrain modeling
- Demonstrate Euler integration for physics simulation
- Show effects of:
  - Surface curvature parameters (`a`, `b`, `c`)
  - Damping (friction)
  - Initial velocities (`vx0`, `vy0`)

## Key Equations
### Terrain Surface
$$z(x,y) = -a(x^2 + y^2) + b\cdot e^{-c(x^2 + y^2)}$$
- **Positive \( b \)**: Creates unstable peak (ball rolls away)
- **Negative \( b \)**: Creates stable valley (ball oscillates)

### Force Components
$$F_x = -mg\frac{\partial z}{\partial x} - \text{damping}\cdot v_x$$
$$F_y = -mg\frac{\partial z}{\partial y} - \text{damping}\cdot v_y$$

with partial derivatives:
$$\frac{\partial z}{\partial x} = -2ax - 2bcx\cdot e^{-c(x^2+y^2)}$$

## Parameters
| Variable | Description | Example Values |
|----------|-------------|----------------|
| `a`      | Bowl curvature | 0.01       |
| `b`      | Peak height (positive) / Valley depth (negative) | ±10       |
| `c`      | Peak/valley width control | 0.05      |
| `vx0`    | Initial x-velocity (escape threshold ~30 m/s) | 35 m/s    |
| `damping`| Energy loss coefficient | 0.5       |

## Code Overview
1. **Terrain Setup**:
   ```matlab
   terrain = @(x, y) -a*(x.^2 + y.^2) + b*exp(-c*(x.^2 + y.^2));
   ```
2. **Physics Simulation**:
   - Euler integration for position/velocity updates
   - Force calculations using terrain gradients
3. **3D Animation**:
   - Real-time ball position updates
   - Trajectory path history
   - Dynamic camera view


## Usage
1. Run the script in Octave:
   ```bash
   octave ball_dynamics_3d.m
   ```
2. Animation features:
   - Rotating 3D surface (drag to view angles)
   - Red ball with trajectory trail
   - Real-time time counter
   - Axis limits: X,Y ∈ [-10,10], Z ∈ [-10,15]

## Results
### Unstable Equilibrium (b > 0)

- Ball rapidly escapes peak with initial velocity >30 m/s


### Stable Equilibrium (b < 0)

- Ball oscillates in valley with decaying amplitude

