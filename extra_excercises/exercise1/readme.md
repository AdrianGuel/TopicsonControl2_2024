# LTI vs LTV System Analysis with Time Delay

This repository contains an Octave script that demonstrates the difference between Linear Time-Invariant (LTI) and Linear Time-Variant (LTV) systems by analyzing their responses to a delayed input and comparing them to their delayed outputs.

## Purpose
The goal is to validate whether a system is time-invariant by applying the following test:
- **Time-Invariant System**: Delaying the input by `τ` should produce the same result as delaying the output by `τ`.
- **Time-Variant System**: The above property does not hold.

The script compares two systems:
1. **LTI**: $\dot{y}(t) + y(t) = u(t)$
2. **LTV**: $\dot{y}(t) + t \cdot y(t) = u(t)$

## Time-Invariance Criterion
A system $T$ is time-invariant if:
$$T\left[u(t - \tau)\right] = y(t - \tau)$$
for all delays $\tau$.

## Code Overview
### Parameters
- Time step: $h = 0.01$
- Simulation time: $t = [0, 10]$ seconds
- Delay: $\tau = 1$ second
- Input function: $u(t) = \sin(t)$

### Systems and ODEs
- **LTI**:
  ```matlab
  f_LTI = @(y, t) input(t) - y;          % dy/dt = u(t) - y
  f_LTI_ID = @(y, t) input_d(t) - y;     % Delayed input
  ```
- **LTV**:
  ```matlab
  f_LTV = @(y, t) input(t) - t*y;        % dy/dt = u(t) - t*y
  f_LTV_ID = @(y, t) input_d(t) - t*y;   % Delayed input
  ```

### Analysis Steps
1. Solve ODEs for both systems using `lsode`.
2. Compute delayed outputs by shifting the original system's response.
3. Compare:
   - Response to delayed input (`y_LTI_ID`, `y_LTV_ID`).
   - Delayed output of the original system (`y_LTI_OD`, `y_LTV_OD`).

## Usage
1. Run the script in Octave:
   ```bash
   octave lti_ltv_comparison.m
   ```
2. Two figures will be generated:
   - **Figure 1**: LTI system comparison. If the red (`Delayed u(t)`) and blue dashed (`Delayed y(t)`) lines overlap, the system is time-invariant.
   - **Figure 2**: LTV system comparison. The red and blue lines will not overlap, indicating time-variance.

## Results
- **LTI System**: The plots for `Delayed u(t)` and `Delayed y(t)` will coincide, confirming time-invariance.
- **LTV System**: The plots will diverge, confirming time-variance.
