# Superposition Analysis

This repository contains an Octave script that demonstrates the difference between Linear Time-Invariant (LTI) and Nonlinear systems by testing the **superposition principle**. The script compares the response of a linear system to the sum of inputs versus the sum of its responses to individual inputs.

## Purpose
The goal is to validate whether a system is linear by applying the following test:
- **Linear System**: The response to the sum of two inputs $u_1(t) + u_2(t)$ equals the sum of the responses to each input individually.
- **Nonlinear System**: The superposition principle does not hold.

The script compares:
1. **LTI System**: $\dot{y}(t) + y(t) = u(t)$
2. **Nonlinear System**: $\dot{y}(t) + e^{4y(t)} = \sin(u(t))$

## Superposition Principle
$$T\left[u_1(t) + u_2(t)\right] = T\left[u_1(t)\right] + T\left[u_2(t)\right]$$

## Code Overview
### Parameters
- Time step: $h = 0.01$
- Simulation time: $t = [0, 10]$ seconds
- Initial condition: $y_0 = 0$

### Input Functions
- $u_1(t) = \sin(2t)$
- $u_2(t) = \sin(0.8t)$

### Systems and ODEs
- **Linear System**:
  ```matlab
  f_LTI_1 = @(y, t) u1(t) - y;       % Response to u1
  f_LTI_2 = @(y, t) u2(t) - y;       % Response to u2
  f_LTI_SI = @(y, t) u1(t)+u2(t) - y; % Response to u1 + u2
  ```
- **Nonlinear System**:
  ```matlab
  f_nL_1 = @(y, t) sin(u1(t)) - exp(4*y); % Response to u1
  f_nL_2 = @(y, t) sin(u2(t)) - exp(4*y); % Response to u2
  f_nL_SI = @(y, t) sin(u1(t)+u2(t)) - exp(4*y); % Response to u1 + u2
  ```

### Analysis Steps
1. Solve ODEs for both systems using `lsode` for individual inputs $u_1(t)$ and $u_2(t)$.
2. Compute the **sum of outputs** $y_{SO} = y_1 + y_2$
3. Solve ODEs for the **sum of inputs** $u_1(t) + u_2(t)$
4. Compare:
   - Sum of individual outputs $y_{SO}$.
   - Output for the summed inputs $y_{SI}$.

## Usage
1. Run the script in Octave:
   ```bash
   octave linearity_analysis.m
   ```
2. Two figures will be generated:
   - **Figure 1 (Linear System)**: The red (`Sum of outputs`) and blue dashed (`Sum of inputs`) lines will overlap, confirming linearity.
   - **Figure 2 (Nonlinear System)**: The red and blue lines will diverge, confirming nonlinearity.

## Results
- **Linear System**: The plots for `Sum of outputs` and `Sum of inputs` coincide, validating the superposition principle.
- **Nonlinear System**: The plots diverge, violating superposition and confirming nonlinearity.
