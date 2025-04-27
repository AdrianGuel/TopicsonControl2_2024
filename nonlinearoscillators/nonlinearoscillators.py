import numpy as np
import plotly.graph_objs as go
from scipy.integrate import solve_ivp
import webbrowser
import tempfile
import os

# Define different oscillators
def van_der_pol(t, z, mu=1.0):
    x, dx = z
    ddx = mu * (1 - x**2) * dx - x
    return [dx, ddx]

def duffing(t, z, delta=0.2, alpha=-1, beta=1, gamma=0.3, omega=1.2):
    x, dx = z
    ddx = -delta * dx - alpha * x - beta * x**3 + gamma * np.cos(omega * t)
    return [dx, ddx]

def simple_pendulum(t, z, g=9.81, l=1.0):
    theta, dtheta = z
    ddtheta = -(g / l) * np.sin(theta)
    return [dtheta, ddtheta]

def rayleigh(t, z, epsilon=1.0):
    x, dx = z
    ddx = -x - epsilon * (dx - (dx**3)/3)
    return [dx, ddx]

# Simulation function
def simulate(oscillator, t_span, z0, t_eval, params={}):
    return solve_ivp(lambda t, z: oscillator(t, z, **params), t_span, z0, t_eval=t_eval)

# Phase portrait function
def generate_phase_portrait(oscillator, params={}, x_range=(-2, 2), y_range=(-2, 2), density=20):
    x = np.linspace(x_range[0], x_range[1], density)
    y = np.linspace(y_range[0], y_range[1], density)
    X, Y = np.meshgrid(x, y)
    U = np.zeros(X.shape)
    V = np.zeros(Y.shape)

    for i in range(X.shape[0]):
        for j in range(X.shape[1]):
            dx, ddx = oscillator(0, [X[i, j], Y[i, j]], **params)
            U[i, j] = dx
            V[i, j] = ddx

    fig = go.Figure()

    # Normalize arrows for vector field (quiver plot manually)
    magnitude = np.sqrt(U**2 + V**2)
    U_norm = U / (magnitude + 1e-8)
    V_norm = V / (magnitude + 1e-8)

    for i in range(0, density, 2):
        for j in range(0, density, 2):
            fig.add_trace(go.Scatter(
                x=[X[i, j], X[i, j] + 0.1 * U_norm[i, j]],
                y=[Y[i, j], Y[i, j] + 0.1 * V_norm[i, j]],
                mode='lines',
                line=dict(color='black', width=1),
                showlegend=False
            ))

    # Simulate multiple trajectories
    t_span = (0, 20)
    t_eval = np.linspace(*t_span, 500)
    initial_conditions = [
        [-1.5, 0], [1.5, 0], [0, 1.5], [0, -1.5],
        [1.0, 1.0], [-1.0, -1.0], [1.0, -1.0], [-1.0, 1.0],
        [0.5, 0.5], [-0.5, -0.5]
    ]

    for z0 in initial_conditions:
        sol = simulate(oscillator, t_span, z0, t_eval, params)
        fig.add_trace(go.Scatter(x=sol.y[0], y=sol.y[1], mode='lines', line=dict(width=2)))

        # Add arrows along the trajectory
        for k in range(0, len(sol.t) - 1, 50):
            x_start = sol.y[0, k]
            y_start = sol.y[1, k]
            x_end = sol.y[0, k+1]
            y_end = sol.y[1, k+1]

            # Normalize direction for fixed arrow size
            dx = x_end - x_start
            dy = y_end - y_start
            norm = np.sqrt(dx**2 + dy**2) + 1e-8
            dx /= norm
            dy /= norm

            arrow_length = 0.1
            fig.add_trace(go.Scatter(
                x=[x_start, x_start + arrow_length * dx],
                y=[y_start, y_start + arrow_length * dy],
                mode='lines',
                line=dict(color='blue', width=2),
                showlegend=False
            ))

    fig.update_layout(title="Phase Portrait",
                      xaxis_title='x',
                      yaxis_title='dx/dt',
                      xaxis=dict(range=[x_range[0], x_range[1]]),
                      yaxis=dict(range=[y_range[0], y_range[1]]),
                      width=800,
                      height=600)

    with tempfile.NamedTemporaryFile(delete=False, suffix='.html') as tmp:
        tmp_path = tmp.name
        fig.write_html(tmp_path)
        webbrowser.open('file://' + os.path.realpath(tmp_path))

# Main function
def main():
    print("Choose an oscillator:")
    print("1. Van der Pol")
    print("2. Duffing")
    print("3. Simple Pendulum")
    print("4. Rayleigh")
    choice = input("Enter number (1-4): ")

    if choice == '1':
        params = {'mu': 1.0}
        generate_phase_portrait(van_der_pol, params, x_range=(-2,2), y_range=(-2,2))
    elif choice == '2':
        params = {'delta': 0.2, 'alpha': -1, 'beta': 1, 'gamma': 0.3, 'omega': 1.2}
        generate_phase_portrait(duffing, params, x_range=(-2,2), y_range=(-2,2))
    elif choice == '3':
        params = {'g': 9.81, 'l': 1.0}
        generate_phase_portrait(simple_pendulum, params, x_range=(-4,4), y_range=(-4,4))
    elif choice == '4':
        params = {'epsilon': 1.0}
        generate_phase_portrait(rayleigh, params, x_range=(-2,2), y_range=(-2,2))
    else:
        print("Invalid choice.")

if __name__ == "__main__":
    main()