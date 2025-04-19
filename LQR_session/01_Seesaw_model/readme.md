# Seesaw Rotational Dynamics Simulation

This repository contains a GNU Octave simulation of a seesaw (balanced beam) system with nonlinear and linearized dynamics, including gravitational torque, viscous damping, and Coulomb friction. The simulation visualizes the system's behavior through four key plots and a 3D animation.

## System Dynamics

The seesaw is modeled using Newton’s second law for rotation:

$$
I \ddot{\theta} = \sum \tau
$$

where:
- $I$ is the moment of inertia,
- $\theta$ is the angular position,
- $\sum \tau$ is the sum of torques (gravitational, friction, and control input).

### Key Equations
**Net Torque**:

   $$
   \ddot{\theta} + \alpha \dot{\theta} + \beta \tanh\left(\frac{\dot{\theta}}{\epsilon}\right) = \gamma \cos\theta + \delta F
   $$

   where:
   - $\alpha = \frac{b}{I}$ (viscous damping),
   - $\beta = \frac{\mu_c g L}{2I}$ (Coulomb friction),
   - $\gamma = \frac{(m_2 - m_1)g L}{2I}$ (gravitational torque),
   - $\delta = \frac{L}{2I}$ (control input gain).

**State-Space Representation**:

   $$
   \begin{aligned}
   \dot{x}_1 &= x_2, \\
   \dot{x}_2 &= -\alpha x_2 - \beta \tanh\left(\frac{x_2}{\epsilon}\right) + \gamma \cos x_1 + \delta F
   \end{aligned}
   $$

## Parameters
| Parameter | Description | Value |
|-----------|-------------|-------|
| `m1`      | Mass at left end | 0.35 kg |
| `m2`      | Mass at right end | 0.2 kg |
| `mb`      | Beam mass | 0.5 kg |
| `L`       | Beam length | 1 m |
| `b`       | Viscous damping coefficient | 0.08 N·m·s/rad |
| `u_c`     | Coulomb friction coefficient | 0.001 |
| `eps`     | Smoothing parameter for `tanh` | 0.1 |

## Equilibrium Points
The system has equilibrium points at $\theta_{\text{eq}} = \pm \frac{\pi}{2} + n\pi$ (vertical positions).  
**Conditions for stability**:
- Use $\theta_{\text{eq}} = \frac{\pi}{2}$ when $m_2 > m_1$ (heavier mass at the bottom).
- Use $\theta_{\text{eq}} = -\frac{\pi}{2}$ when $m_1 > m_2$ (heavier mass at the bottom).  

The linearized Jacobian at equilibrium:

$$
A = 
\begin{bmatrix} 
0 & 1 \\
-\gamma \sin\theta_{\text{eq}} & -\alpha - \beta/\epsilon 
\end{bmatrix}
$$

## Simulation Outputs
The code generates four plots and a 3D animation:

### 1. **Angular Velocity ($\dot{\theta}$) vs. Time**
   - Compares nonlinear (blue) and linearized (green) solutions.
   - Red/magenta markers show instantaneous values.

### 2. **Phase Plot ($\theta$ vs. $\dot{\theta}$)**
   - Trajectories in state-space for both models.
   - Toggleable vector fields (linear/nonlinear) via dropdown menu.
   - Dashed lines connect to current state.

### 3. **3D Animation**
   - **Nonlinear model (blue beam)**: Rendered at the origin.
   - **Linearized model (green beam)**: Offset vertically for clarity.
   - Masses scaled by their values (red/blue for nonlinear, magenta/cyan for linear).

### 4. **Angular Position ($\theta$) vs. Time (Rotated)**
   - Time on the y-axis for better visualization of long-term behavior.

## Usage
1. Run the script in GNU Octave (requires `symbolic` package).
2. Adjust parameters (e.g., `m1`, `m2`, `theta_e`) to explore different equilibria.
3. The animation loops automatically; close the figure to stop.

## Notes
- The linearized model approximates $\tanh(\dot{\theta}/\epsilon)$ with a linear term (valid near equilibrium).
- Stability depends on the sign of $\gamma$ and the equilibrium angle (see **Equilibrium Points** section).
