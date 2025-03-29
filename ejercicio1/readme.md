# LTI vs LTV System Analysis with Time Delay

This repository contains an Octave script that demonstrates the difference between Linear Time-Invariant (LTI) and Linear Time-Variant (LTV) systems by analyzing their responses to a delayed input and comparing them to their delayed outputs.

## Purpose
The goal is to validate whether a system is time-invariant by applying the following test:
- **Time-Invariant System**: Delaying the input by `τ` should produce the same result as delaying the output by `τ`.
- **Time-Variant System**: The above property does not hold.

The script compares two systems:
1. **LTI**: \(\dot{y}(t) + y(t) = u(t)\)
2. **LTV**: \(\dot{y}(t) + t \cdot y(t) = u(t)\)

Analysis Steps
Solve ODEs for both systems using lsode.

Compute delayed outputs by shifting the original system's response.

Compare:

Response to delayed input (y_LTI_ID, y_LTV_ID).

Delayed output of the original system (y_LTI_OD, y_LTV_OD).

Results
LTI System: The plots for Delayed u(t) and Delayed y(t) will coincide, confirming time-invariance.

LTV System: The plots will diverge, confirming time-variance.
