# Seesaw Stabilization with LQR Controller

## Overview

This project implements a Linear Quadratic Regulator (LQR) controller for stabilizing a seesaw (balancing beam) system. The simulation visualizes the system dynamics in a phase space diagram and provides a 3D animation of the beam movement over time.

![image](https://github.com/user-attachments/assets/eaa75e8a-8055-4564-90fc-0fe3884c7c33)


## System Description

The system consists of a beam with two different masses at each end, capable of rotating around its center point. The control objective is to stabilize the beam at a desired equilibrium position (typically at $\theta_e = \frac{3\pi}{2}$ radians) using an LQR controller.

### System Dynamics

The seesaw is modeled as a rigid beam with the following dynamics:

$$I\ddot{\theta} + b\dot{\theta} + u_c g L \tanh\left(\frac{\dot{\theta}}{\epsilon}\right) + (m_2-m_1)\frac{gL}{2}\sin(\theta) = \frac{L}{2}u$$

Where:
- $\theta$ is the angle of the beam
- $\dot{\theta}$ is the angular velocity
- $\ddot{\theta}$ is the angular acceleration
- $I$ is the moment of inertia
- $b$ is the viscous damping coefficient
- $u_c$ is the Coulomb friction coefficient
- $\epsilon$ is a smoothing parameter for the tanh function
- $m_1$ and $m_2$ are the masses at each end of the beam
- $L$ is the length of the beam
- $g$ is the gravitational acceleration
- $u$ is the control input

## Linearization

The nonlinear system is linearized around the equilibrium point $\theta_e = \frac{3\pi}{2}$ radians (downward vertical position), which is inherently stable. The linearized state-space model takes the form:

$$\dot{x} = Ax + Bu$$

Where $x = [\theta - \theta_e, \dot{\theta} - \dot{\theta}_e]^T$ and:

$$A = \begin{bmatrix} 
0 & 1 \\
-\frac{(m_2-m_1)gL}{2I}\sin(\theta_e) & -\frac{b}{I} - \frac{u_c g L}{2I\epsilon}
\end{bmatrix}$$

$$B = \begin{bmatrix} 
0 \\
\frac{L}{2I}
\end{bmatrix}$$

## LQR Controller Design

The LQR controller minimizes the cost function:

$$J = \int_{0}^{\infty} (x^T Q x + u^T R u) dt$$

Where:
- $Q$ is a positive semi-definite matrix that penalizes state deviations
- $R$ is a positive definite matrix that penalizes control effort

The optimal control law is given by:

$$u = -Kx$$

Where $K = R^{-1}B^TP$ and $P$ is the solution to the algebraic Riccati equation.

## Installation Requirements

- GNU Octave
- Control package for Octave
- Symbolic package for Octave

Install the required packages in Octave using:

```octave
pkg install -forge control
pkg install -forge symbolic
```

## Usage

1. Clone this repository
2. Open the script in GNU Octave
3. Run the script with:
   ```octave
   balancing_beam_lqr
   ```

## Modifiable Parameters

The following parameters can be adjusted to experiment with the system behavior:

### Physical Parameters
- `m1`: Mass at one end of the beam (kg)
- `m2`: Mass at the other end of the beam (kg)
- `mb`: Mass of the beam (kg)
- `L`: Length of the beam (m)
- `g`: Gravitational acceleration (m/s²)
- `b`: Viscous damping coefficient (N·m·s/rad)
- `u_c`: Coulomb friction coefficient
- `eps`: Smoothing parameter for tanh function

### Control Parameters
- `Q`: State penalty matrix (diagonal matrix of size 2×2)
- `R`: Control penalty scalar

### Initial Conditions
- `x0`: Initial state vector [θ₀; θ̇₀]

### Simulation Parameters
- `tspan`: Time span for simulation

## Tuning the Controller

### Modifying Q and R

The Q and R matrices directly affect the controller behavior:

1. **Q Matrix**: Increase the diagonal elements to penalize state deviations more heavily
   - Higher values for Q[1,1] penalize angle deviations more strongly
   - Higher values for Q[2,2] penalize angular velocity deviations

2. **R Value**: Adjust the control effort penalty
   - Lower R values allow more aggressive control actions
   - Higher R values lead to more conservative control

### Recommended Starting Values
```octave
Q = diag([5, 1]);  % Penalize angle error more than velocity error
R = 0.1;           % Moderate control effort penalty
```

### Linearization Point

The recommended linearization point is $\theta_e = \frac{\pi}{2}$ (downward vertical position), which is naturally stable when $\gamma > 0 \implies m_2 > m_1$ . This position corresponds to the beam pointing straight down with gravity helping to maintain stability.

You can experiment with other linearization points, but may need to adjust the controller.

## Visualizations

The simulation provides four visualization panels:

1. Angular velocity vs. time
2. Phase space diagram with vector field
3. 3D animation of the beam
4. Angle vs. time (rotated plot)
