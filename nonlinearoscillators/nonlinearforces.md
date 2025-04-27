# Nonlinear Spring and Friction Models

## Nonlinear Spring Models

### General Form

$$
F(x) = k_1 x + k_3 x^3 + k_5 x^5 + \dots
$$

- **Linear term:** \(k_1 x\)
- **Cubic and higher-order terms:** Represent nonlinear behavior.

Common Simplification:

$$
F(x) = k_1 x + k_3 x^3
$$

### Real-World Applications of Nonlinear Springs

| Application | Reason for Nonlinearity |
|:------------|:------------------------|
| Metal springs under large deformation | Material nonlinearity |
| Rubber components | Hyperelastic behavior |
| MEMS devices | Geometric/material nonlinearity |
| Vibration isolators | Designed for performance across ranges |
| Human tendons/ligaments | Biological material response |

### Hardening vs Softening Springs

- **Hardening Spring:** \(k_3 > 0\)
  - Stiffness increases with displacement.
- **Softening Spring:** \(k_3 < 0\)
  - Stiffness decreases with displacement.

Visual effect: Amplitude-frequency curve bends upward (hardening) or downward (softening).

## Nonlinear Friction Models

### Basic Coulomb Friction

$$
F_{\text{friction}} = -F_c \; \text{sign}(v)
$$

- Constant magnitude.
- Discontinuous at \(v = 0\).

### Viscous and Stribeck Friction

**Viscous Friction (Linear):**

$$
F_{\text{friction}} = -b v
$$

Proportional to velocity.

**Stribeck Effect (Nonlinear):**

$$
F_{\text{friction}}(v) = -\left(F_c + (F_s - F_c) e^{-(|v|/v_s)^2}\right) \text{sign}(v) - b v
$$

- Friction decreases at low velocities.
- Smooth transition from static to dynamic friction.

### Pre-sliding (Elastic Hysteresis)

$$
F_{\text{friction}} = k_p x_{\text{stick}}
$$

- Micro-scale spring-like behavior before full sliding.
- Important for precision positioning and micro/nano-systems.

## Applications of Nonlinear Friction

| Application | Type of Nonlinearity |
|:------------|:---------------------|
| Robotics joints | Stribeck + Coulomb |
| Automotive brakes | Stribeck + hysteresis |
| CNC machines | Pre-sliding + Stribeck |
| Hard disk drives | Stribeck effect |
| Human joints | Viscoelastic damping + friction |

## Summary

| Model | Equation | Behavior |
|:------|:---------|:---------|
| Nonlinear spring | $$F(x) = k_1 x + k_3 x^3$$ | Hardening or softening |
| Coulomb friction | $$-F_c \; \text{sign}(v)$$ | Constant force |
| Viscous friction | $$-b v$$ | Proportional to velocity |
| Stribeck friction | Mixed exponential decay | Real-world velocity dependence |
| Pre-sliding | $$k_p x_{\text{stick}}$$ | Elastic before sliding |

---

Let's explore nonlinear dynamics 🚀
