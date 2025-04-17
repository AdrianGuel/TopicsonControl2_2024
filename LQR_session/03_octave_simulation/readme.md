
# Seesaw rotational dynamics Simulation: Nonlinear vs Linearized Dynamics

This repository provides a simulation and visualization framework in **GNU Octave** for analyzing a physical balancing beam system under both **nonlinear** and **linearized** dynamic models. It includes animated plots, phase-space analysis, and an interactive vector field visualization to understand the differences between models and dynamic behavior near equilibrium points.

## 📊 Features

- Simulates both nonlinear and linearized ODE models of a rotating beam.
- 3D animation of the physical system, showing real-time angular motion of both models.
- Plots of angular velocity and angular position over time.
- Phase space visualization with optional vector field (linear or nonlinear).
- Interactive GUI to toggle between vector fields.
- Legend and color-coded trajectories for comparison clarity.

## 🔧 Modifiable Parameters

You can easily customize the behavior of the system by modifying the following variables at the top of the script:

| Variable        | Description |
|----------------|-------------|
| `m1`, `m2`      | Masses located at each end of the beam (in kg). |
| `L`             | Length of the beam (in meters). |
| `g`             | Gravitational acceleration. |
| `b`             | Viscous damping coefficient. |
| `u_c`           | Coulomb friction coefficient. |
| `u`             | Control torque applied (defaults to 0). |
| `eps`           | Smoothing parameter for tanh (used in nonlinear damping). |
| `theta_e`       | Linearization point (angle in radians). |
| `theta_e_dot`   | Linearization point (angular velocity in rad/s). |
| `x0`            | Initial state `[theta; theta_dot]`. |
| `tspan`         | Time vector for simulation, i.e. `linspace(t_start, t_end, N)`. |
| `animation_step`| Step size for the animation frame update. |

## 📁 File Overview

### Main Script

- **Section 1: System Parameters**  
  Defines physical constants, beam masses, damping, gravity, and precomputed constants.

- **Section 2: Model Definitions**
  - **Nonlinear ODE**: Full dynamics using damping and cosine torque.
  - **Linearized ODE**: Approximated model around a user-defined equilibrium point.

- **Section 3: Simulation Setup**
  Time vector and initial conditions. Integrates the systems using `ode45`.

- **Section 4: Plotting and Animation**
  Creates four plots:
  1. Angular velocity over time `x'(t) vs t`.
  2. Phase space `x'(t)` vs `x(t)` with switchable vector field.
  3. 3D animated beam showing physical movement.
  4. Angular position over time `t vs x(t)` (rotated plot).

- **Section 5: Interactivity**
  A GUI dropdown menu allows toggling between the vector fields of the nonlinear and linear models on the phase space plot.

- **Section 6: Animation Loop**
  Updates all figures simultaneously: 3D beam, time responses, and phase plot markers.

## 🧠 Mathematical Models

### Nonlinear Model:
$$
\begin{cases}
\dot{\theta} = \omega \\
\dot{\omega} = -a \omega - b \tanh\left(\frac{\omega}{\varepsilon}\right) + c \cos(\theta)
\end{cases}
$$

### Linearized Model:
Linearization around $\theta_e, \omega_e$:
$$
\dot{x} = A x + B u
$$

Where:
- $x = [\theta - \theta_e; \omega - \omega_e]$
- $A$ is computed using symbolic derivatives.

## 📌 Dependencies

This script uses GNU Octave and requires the **symbolic** package. You can install it with:
```octave
pkg install -forge symbolic
pkg load symbolic
```

## ▶️ Running the Code

Simply execute the script in GNU Octave. All figures will be generated, and the animation will run in real time. Use the dropdown menu on the top-right corner to toggle between the linear and nonlinear vector fields in the phase space.

## 📷 Preview

![Video sin título ‐ Hecho con Clipchamp](https://github.com/user-attachments/assets/811c2d90-b17a-48ca-a146-57a990ce703f)


## 📜 License

This project is released under the MIT License.

---

Feel free to fork and adapt the script to different systems or to extend it with controllers (e.g., LQR, PID) or measurement noise to simulate real-world scenarios.

Enjoy simulating dynamics!
```

Let me know if you want to include a LaTeX-formatted PDF version or an animated GIF for the GitHub README too!
