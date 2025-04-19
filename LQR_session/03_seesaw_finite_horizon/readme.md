# Finite-Horizon LQR for Seesaw Stabilization (Discrete-Time)

This repository implements a **discrete-time finite-horizon Linear Quadratic Regulator (LQR)** to stabilize a seesaw system. The code computes time-varying feedback gains recursively and simulates the closed-loop response.

---

## Theory: Finite-Horizon LQR

The goal is to minimize the quadratic cost function over a fixed time horizon $N$:

$$
J = \sum_{k=0}^{N-1} \left( \mathbf{x}_k^T Q \mathbf{x}_k + u_k^T R u_k \right) + \mathbf{x}_N^T Q \mathbf{x}_N,
$$

where:
- $Q \geq 0$ penalizes state deviations,
- $R > 0$ penalizes control effort.

### Recursive Gain Computation
The optimal feedback gains $K_k$ and cost-to-go matrix $P_k$ are computed backward in time using the **discrete-time Riccati equation**:
**Terminal Condition**: $P_N = Q$.
**Backward Recursion**:

$$
\begin{aligned}
K_k &= (R + B_d^T P_{k+1} B_d)^{-1} B_d^T P_{k+1} A_d, \\
P_k &= A_d^T P_{k+1} A_d + Q - A_d^T P_{k+1} B_d K_k.
\end{aligned}
$$

Here, $A_d$ and $B_d$ are the discrete-time state matrices.

---

## Code Explanation

### Key Steps:
1. **Discretization**:
   ```matlab
   sysd = c2d(sysc, Ts, 'zoh');  % Convert continuous system to discrete-time
   ```
   - Uses Zero-Order Hold (ZOH) with sampling time $T_s = 0.01$ s.

2. **Finite-Horizon LQR**:
   ```matlab
   for k = N:-1:1
       K(:,:,k) = (R + Bd'*P(:,:,k+1)*Bd) \ (Bd'*P(:,:,k+1)*Ad);
       P(:,:,k) = Ad'*P(:,:,k+1)*Ad + Q - Ad'*P(:,:,k+1)*Bd*K(:,:,k);
   end
   ```
   - Computes time-varying gains \( K_k \) and cost matrices \( P_k \).

3. **Simulation**:
   ```matlab
   for k = 1:N
       nu(k) = -K(:,:,k)*x_err(:,k);  % Time-varying control law
       x_err(:,k+1) = Ad*x_err(:,k) + Bd*nu(k);
   end
   ```
   - Applies the feedback gains to stabilize the system.

---

## Plots and Interpretation

### 1. **Time-Varying Gains $K_1(t)$, $K_2(t)$**
   - **Description**: Shows how the feedback gains evolve over the horizon.
   - **Behavior**:
     - Gains start high to aggressively correct initial deviations.
     - Gradually decrease as the system approaches equilibrium (finite-horizon effect).
   - **Why Time-Varying?**: Finite-horizon LQR optimizes for a fixed duration, unlike infinite-horizon LQR (constant \( K \)).

### 2. **Cost Matrix Elements $P_{11}(t)$, $P_{12}(t)$, $P_{22}(t)$**
   - **Description**: Tracks the Riccati matrix $P_k$ during backward recursion.
   - **Behavior**:
     - $P_k$ grows larger backward in time (higher cost-to-go for earlier states).
     - Convergence indicates stability of the Riccati equation.

### 3. **Angular Velocity ($\omega$) vs. Time**
   - **Description**: Closed-loop angular velocity response.
   - **Expectation**: $\omega \to 0$ as the beam stabilizes.

### 4. **Phase Plot ($\theta$ vs. $\omega$)**
   - **Description**: Trajectory in state-space.
   - **Key Features**:
     - Black arrows: Linearized vector field.
     - Green curve: Closed-loop trajectory converging to equilibrium $(\theta_{\text{eq}}, 0)$.

### 5. **3D Beam Animation**
   - **Description**: Visualizes the beam’s angular motion.
   - **Markers**:
     - Magenta: Mass $m_1 = 0.2$ kg (left).
     - Cyan: Mass $m_2 = 0.35$ kg (right).

### 6. **Angular Position ($\theta$) vs. Time (Rotated)**
   - **Description**: Shows $\theta \to \theta_{\text{eq}} = -\pi/2$ over time.
   - **Note**: Time on the y-axis emphasizes convergence speed.

---

## Parameters
| Parameter | Description | Value |
|-----------|-------------|-------|
| `Q`       | State cost  | `diag([5, 0.1])` |
| `R`       | Control cost | 0.1 |
| `N`       | Horizon steps | 500 |
| `Ts`      | Sampling time | 0.01 s |
| `theta_e` | Equilibrium | \(-\pi/2\) (vertical) |

---

## Usage
1. **Run in GNU Octave**:
   ```bash
   octave finite_horizon_lqr.m
   ```
2. **Adjustments**:
   - Modify `Q`, `R`, or `N` to explore trade-offs between performance and control effort.
   - Change `theta_e` for different equilibria (ensure \( m_2 > m_1 \)).

---

## Conclusion
This implementation demonstrates how finite-horizon LQR computes **time-varying gains** for optimal control over a fixed duration. The plots highlight the controller’s ability to drive the system to equilibrium while minimizing energy use.
