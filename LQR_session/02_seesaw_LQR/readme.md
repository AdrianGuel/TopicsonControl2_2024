# Seesaw Stabilization with LQR Control

This repository contains a GNU Octave implementation of a Linear Quadratic Regulator (LQR) controller to stabilize a seesaw system around an equilibrium point. The code demonstrates closed-loop dynamics, animation, and phase-space analysis.

---

## System Dynamics

The seesaw is modeled using rotational dynamics:

$$
I \ddot{\theta} = \sum \tau
$$

where:
- $I = \frac{1}{12}m_b L^2 + \frac{1}{4}(m_1 + m_2)L^2$ is the total moment of inertia,
- $\tau$ includes gravitational, friction, and control torques.

### Linearized State-Space Model
The system is linearized around the equilibrium $\theta_{\text{eq}} = -\pi/2$ (vertical position):

$$
\begin{aligned}
\dot{\mathbf{x}} &= A \mathbf{x} + B u, \\
A &= 
\begin{bmatrix} 
0 & 1 \\
-\gamma \sin\theta_{\text{eq}} & -\alpha - \beta/\epsilon 
\end{bmatrix}, \quad 
B = 
\begin{bmatrix} 
0 \\ 
\delta 
\end{bmatrix},
\end{aligned}
$$

where:
- $\alpha = b/I$ (viscous damping),
- $\beta = (\mu_c g L)/(2I)$ (Coulomb friction),
- $\gamma = ((m_2 - m_1)g L)/(2I)$ (gravitational torque),
- $\delta = L/(2I)$ (control input gain).

---

## LQR Control Theory

The LQR controller minimizes the cost function:

$$
J = \int_0^\infty \left( \mathbf{x}^T Q \mathbf{x} + u^T R u \right) dt,
$$

where:
- $Q \geq 0$ penalizes state deviations,
- $R > 0$ penalizes control effort.

### Key Steps in the Code:
1. **Compute LQR Gain**:
   ```matlab
   [K, S, e_vals] = lqr(A, B, Q, R);  % Solve Riccati equation
   ```
   - `K`: Optimal feedback gain matrix.
   - `e_vals`: Closed-loop eigenvalues (poles).

2. **Closed-Loop Dynamics**:
   ```matlab
   cl_sys = A - B*K;  % Closed-loop state matrix
   ```

3. **Simulate Stabilized System**:
   ```matlab
   linear_cl = @(t, x_err) cl_sys * x_err;  % Error dynamics
   ```

---

## Parameters
| Parameter | Description | Value |
|-----------|-------------|-------|
| `m1`      | Left mass   | 0.2 kg |
| `m2`      | Right mass  | 0.35 kg |
| `mb`      | Beam mass   | 0.5 kg |
| `L`       | Beam length | 1 m |
| `Q`       | State cost  | `diag([5, 0.1])` |
| `R`       | Control cost | 0.1 |

---

## Equilibrium Point
- **Chosen Equilibrium**: $\theta_{\text{eq}} = -\pi/2$ (vertical position with $m_2 > m_1$).
- **Stability Condition**: The equilibrium is stabilized by the LQR controller, which places closed-loop eigenvalues in the left-half plane (verified via `e_vals`).

---

## Simulation Outputs

### 1. **Angular Velocity ($\dot{\theta}$) vs. Time**
   - Green curve: Closed-loop response.
   - Magenta marker: Instantaneous angular velocity.

### 2. **Phase Plot ($\theta$ vs. $\dot{\theta}$)**
   - Black arrows: Linearized vector field.
   - Green trajectory: Closed-loop state evolution.
   - Yellow marker: Equilibrium point.

### 3. **3D Beam Animation**
   - Green beam: Current angular position.
   - Magenta/cyan spheres: Masses $m_1$ and $m_2$ (scaled by mass).

### 4. **Angular Position ($\theta$) vs. Time (Rotated)**
   - Time on the y-axis for visualizing convergence.

---

## Usage
1. **Run in GNU Octave**:
   ```bash
   octave lqr_seesaw.m
   ```
2. **Adjust Parameters**:
   - Tune `Q` and `R` for different performance trade-offs.
   - Modify `m1`, `m2`, or `theta_e` for new equilibria.

---

## Notes
- **Coulomb Friction**: Approximated as $\tanh(\dot{\theta}/\epsilon)$ for smoothness.
- **Assumptions**: Small-angle deviations (validity of linearization).
- **Dependencies**: Requires `control` and `symbolic` Octave packages.
