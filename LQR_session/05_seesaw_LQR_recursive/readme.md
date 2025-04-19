# Finite-Horizon LQR for a Balancing Beam

This repository contains an implementation of a finite-horizon Linear Quadratic Regulator (LQR) for a linearized balancing-beam system with point masses at each end. The code is written in GNU Octave / MATLAB and demonstrates:

- A **recursive backward Riccati** solution for computing time-varying gains $K_k$.
- Visualization of the **cost-to-go matrix** $P_k$ and gain matrix $K_k$ over the horizon.  
- A separate figure showing an **animation** of the beam angle and angular velocity converging under the computed control.

> **Note:** The most interesting parameters to tune are the state-weighting matrix $Q$ and the input-weighting scalar $R$.

---

## Recursive LQR Implementation

The backward Riccati recursion for a discrete-time system

$$x_{k+1} = A_d\,x_k + B_d\,u_k$$

with finite horizon $N$, state-weight $Q$, and input-weight $R$, is given by:

$$
K_k = (R + B_d^T\,P_{k+1}\,B_d)^{-1}\,B_d^T\,P_{k+1}\,A_d
$$

$$
P_k = A_d^T\,P_{k+1}\,A_d
      \;+\; Q
      \;-\; A_d^T\,P_{k+1}\,B_d\,K_k
$$

with terminal condition:

$$
P_{N+1} = Q.
$$

This recursion is implemented as follows:

```matlab
% Preallocate
P = zeros(2,2,N+1);
K = zeros(1,2,N);
P(:,:,N+1) = Q;

% Backward Riccati loop
for k = N:-1:1
    K(:,:,k) = (R + Bd'*P(:,:,k+1)*Bd) \\ (Bd'*P(:,:,k+1)*Ad);
    P(:,:,k) = Ad'*P(:,:,k+1)*Ad + Q \
               - Ad'*P(:,:,k+1)*Bd*K(:,:,k);
end
```

---

## Visualization of $P_k$ and $K_k$

The first figure plots each element of the gain vector $K_k = [K_{k,1}, K_{k,2}]$ and the symmetric entries of $P_k$ (namely $P_{11}, P_{12}=P_{21}, P_{22}$) over time $t = k\,T_s$.

![image](https://github.com/user-attachments/assets/dfc8e51e-8a3b-4ac4-8801-0fa287dc8b2e)
---

## Animation of System Convergence

The second figure is an animated 4-panel plot showing:

1. Angular velocity $\omega(t)$ vs. time.  
2. Phase space trajectory with a vector field background.  
3. 3D representation of the beam rotating under control.  
4. Angle $\theta(t)$ vs. time.  
![image](https://github.com/user-attachments/assets/aa057fe8-3379-451d-a62e-37a97e1784ba)

---

## Tuning $Q$ and $R$

The performance of the controller is highly sensitive to the choice of:

- $Q = \text{diag}(q_1, q_2)$: penalizes state deviations.  
- $R$: penalizes control effort.

Try varying these weights to observe how the beam response and convergence rate change.

---

### Usage

1. Clone the repository.
2. Open the main script in GNU Octave or MATLAB.
3. Adjust `Q` and `R` as desired.
4. Run the script to generate plots and animation.

