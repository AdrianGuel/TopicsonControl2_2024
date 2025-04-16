# Seesaw Dynamics Simulation

This repository contains a Manim animation, developed in Jupyter Notebook, that illustrates the dynamic behavior of a seesaw (balancing beam) system. The simulation includes an animation of the system motion and a phase‐space plot of its states (angular position and angular velocity).

![Imagen1](https://github.com/user-attachments/assets/8cbec655-4df8-4f57-9e25-36db37337ef0)

![output](https://github.com/user-attachments/assets/065351ed-6e69-424a-8ee1-ea7632ea35da)


## Overview

In this simulation, we consider a seesaw model with the following physics:
- **Two point masses** on either side of a beam of length *L*
- **Gravitational torque** due to the mass imbalance
- **Viscous damping** and **Coulomb friction** (with a smooth approximation)
- A **control force** acting on the beam

The system equations are solved numerically using `scipy.integrate.solve_ivp`. The animation is created with Manim and displays both the moving seesaw and its corresponding phase-space diagram.

## Simulation Details

- **Dynamic parameters:**
  - `m1`, `m2`: Masses at each end
  - `m_b`: Beam mass
  - `L`: Beam length
  - `g`: Gravitational acceleration
  - `b`: Viscous damping coefficient
  - `u_c`: Coulomb friction coefficient
  - `eps`: Smoothing parameter for the hyperbolic tangent function
  - `F`: Control force (set to zero in this simulation)

- **State variables:**
  - `θ` (theta): Angular position of the seesaw
  - `θ̇` (theta_dot): Angular velocity

- **Output:**
  - An animated seesaw along with a phase-space plot showing the evolution of `θ` and `θ̇` over time.

## Requirements

Make sure you have the following installed:
- [Manim](https://www.manim.community/)
- NumPy
- SciPy

You should also run this in a Jupyter Notebook environment since the simulation leverages notebook magic commands.

## Running the Simulation

To run the simulation, execute the jupyter notebook
