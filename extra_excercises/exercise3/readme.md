# State-Space System Modeling and Analysis in Octave

This repository contains an Octave script that demonstrates state-space modeling, transfer function conversion, and time-domain analysis of a linear system. The script simulates step/impulse responses and system behavior under a sinusoidal input, with visualizations of input, state variables, and output.

## Purpose
The script illustrates:
1. State-space system definition using matrices \( A, B, C, D \).
2. Conversion of state-space models to transfer functions.
3. Time-domain simulations:
   - Step and impulse responses.
   - Response to a sinusoidal input with state/output tracking.

## Key Equations
### State-Space Representation

$$\begin{align*}
\dot{\mathbf{x}}(t) &= A\mathbf{x}(t) + B\mathbf{u}(t) \\
\mathbf{y}(t) &= C\mathbf{x}(t) + D\mathbf{u}(t)
\end{align*}$$
For the given system:
$$A = \begin{bmatrix} -2 & 1 \\ 0 & -3 \end{bmatrix}, \quad
B = \begin{bmatrix} 0 \\ 1 \end{bmatrix}, \quad
C = \begin{bmatrix} 1 & 0 \end{bmatrix}, \quad
D = 0$$

## Code Overview
### State-Space Model
```matlab
sys_ss = ss(A, B, C, D);  % Create state-space object
sys_tf = tf(sys_ss);       % Convert to transfer function
```

### Simulations
1. **Step/Impulse Responses**:
   ```matlab
   step(sys_ss, t);     % Step response
   impulse(sys_ss, t);  % Impulse response
   ```
2. **Arbitrary Input (Sinusoidal)**:
   ```matlab
   u = sin(2*t);                   % Input signal
   [y, t, x] = lsim(sys_ss, u, t); % Simulate output and states
   ```

### Plotting
- Three subplots for input, state variables $x_1, x_2$, and output $y$.


## Usage
1. Run the script in Octave:
   ```bash
   octave state_space_analysis.m
   ```
2. Generated Figures:
   - **Step Response**: System output to a unit step input.
   - **Impulse Response**: System output to a Dirac delta input.
   - **Sinusoidal Input Analysis**:
     - Top subplot: Input signal $u(t) = \sin(2t)$.
     - Middle subplot: State variables $x_1(t)$ and $x_2(t)$.
     - Bottom subplot: Output signal $y(t)$.

## Results
- The script prints the state-space model and its equivalent transfer function:
  $$G(s) = \frac{1}{s^2 + 5s + 6}$$
- **Step/Impulse Responses**: Show the system's transient and steady-state behavior.
- **Sinusoidal Response**: Demonstrates how states and output evolve under periodic forcing.
