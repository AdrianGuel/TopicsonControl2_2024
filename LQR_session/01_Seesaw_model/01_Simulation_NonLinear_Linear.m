%% Balancing Beam Simulation (Nonlinear and Linearized Models)
clear; close all; clc;
pkg load symbolic

% Callback function for toggling vector field display
function toggleQuiver(source, ~)
    val = get(source, 'Value');
    global q1_handle q2_handle current_quiver;

    % Hide both quivers
    set(q1_handle, 'Visible', 'off');
    set(q2_handle, 'Visible', 'off');

    % Show the selected one
    if val == 1
        set(q1_handle, 'Visible', 'on');
        current_quiver = 'q1';
    else
        set(q2_handle, 'Visible', 'on');
        current_quiver = 'q2';
    end
end

%% System Parameters
m1    = 0.35;       % mass at one end [kg]
m2    = 0.2;        % mass at the other end [kg]
mb    = 0.5;        % mass of the beam [kg]
L     = 1;          % beam length [m]
g     = 9.81;       % gravitational acceleration [m/s^2]
b     = 0.08;       % viscous damping coefficient [N*m*s/rad]
u_c   = 0.001;      % Coulomb friction coefficient
u     = 0;          % control input (force or torque)
eps   = 1e-1;       % smoothing parameter for tanh

% Precomputed constants
I = 1/12*mb*L^2 + 1/4*(m1+m2)*L^2;
aa = b/I;
bb = (u_c*g*L)/(2*I);
cc = ((m2-m1)*g*L)/(2*I);
dd = L/(2*I);

%% Equilibrium point for linearization
theta_e = -pi/2;
theta_e_dot = 0;

%% Simulation settings
tspan = linspace(0, 20, 1000)';       % simulation time [s]
x0    = [4*pi/10; -4];                % initial state [theta (rad); theta_dot (rad/s)]
x0_lin = x0 - [theta_e; theta_e_dot]; % initial conditions for linearized system
animation_step = 5;                   % Animation step size
mass_scale = 50;                      % Scale factor for marker size

%% ODE Models
% Nonlinear Model
nonlinear_ode = @(t, x) [
    x(2);
    -aa*x(2) - bb*tanh(x(2)/eps) - cc*cos(x(1))
];

% Linearized Model
A = [0, 1; -cc*sin(theta_e), -aa - bb/eps];
B = [0; dd];
linear_ode = @(t, x) A * x + B*u;

%% Solve ODEs
[t_nl, x_nl] = ode45(nonlinear_ode, tspan, x0);
[~, x_lin] = ode45(linear_ode, tspan, x0_lin);

% Adjust linear solution to match equilibrium point
x_lin(:,1) = x_lin(:,1) + theta_e;
x_lin(:,2) = x_lin(:,2) + theta_e_dot;

% Extract solutions for readability
theta_nl = x_nl(:,1);        % Nonlinear position
theta_dot_nl = x_nl(:,2);    % Nonlinear velocity
theta_lin = x_lin(:,1);      % Linear position
theta_dot_lin = x_lin(:,2);  % Linear velocity

% Pre-calculate axis limits (once, not in the loop)
x_lims = [min(min(theta_nl), min(theta_lin))-0.1, max(max(theta_nl), max(theta_lin))+0.1];
xp_lims = [min(min(theta_dot_nl), min(theta_dot_lin))-0.1, max(max(theta_dot_nl), max(theta_dot_lin))+0.1];

%% Setup animation figure and subplots
fig = figure('Name', 'Balancing Beam Simulation');

% Setup phase space grid (compute once outside the loop)
[theta_grid, omega_grid] = meshgrid(linspace(x_lims(1), x_lims(2), 20), linspace(xp_lims(1), xp_lims(2), 20));
dtheta = omega_grid;
domega_nl = -aa*omega_grid - bb*tanh(omega_grid/eps) - cc*cos(theta_grid);
domega_lin = -cc*sin(theta_e).*(theta_grid - theta_e) - aa.*(omega_grid - theta_e_dot);

% Initialize beam coordinates (reused in the animation)
beam_local = [-L/2, 0, 0; L/2, 0, 0];
offset = 0.2;  % Y-offset for the linear model visualization

%% Create all subplot handles
% 1. Angular velocity plot
subplot(2,2,1);
h1_nl = plot(tspan(1), theta_dot_nl(1), 'b', 'LineWidth', 1.5);
hold on;
h1_lin = plot(tspan(1), theta_dot_lin(1), 'g', 'LineWidth', 1.5);
h1_marker_nl = plot(tspan(1), theta_dot_nl(1), 'ro', 'MarkerFaceColor', 'r');
h1_marker_lin = plot(tspan(1), theta_dot_lin(1), 'mo', 'MarkerFaceColor', 'm');
title("x'(t) vs t");
xlabel('t'); ylabel("x'(t)");
xlim([tspan(1) tspan(end)]);
ylim(xp_lims);
grid on;

% 2. Phase space
subplot(2,2,2);
hold on;

% Draw vector fields
q1 = quiver(theta_grid, omega_grid, dtheta, domega_lin, 'g', 'AutoScale', 'on');
q2 = quiver(theta_grid, omega_grid, dtheta, domega_nl, 'b', 'AutoScale', 'on');

% Make quiver handles global for callback access
global q1_handle q2_handle current_quiver;
q1_handle = q1;
q2_handle = q2;
current_quiver = 'q1';

% Initialize with linear vector field visible
set(q2, 'Visible', 'off');
set(q1, 'Visible', 'on');

% Dropdown menu for vector field selection
uicontrol('Style', 'popupmenu', ...
          'String', {'Vector campo linealizado (q1)', 'Vector campo no lineal (q2)'}, ...
          'Units', 'normalized', ...
          'Position', [0.78, 0.92, 0.2, 0.05], ...
          'Callback', @toggleQuiver);

% Phase space trajectories
h2_nl = plot(theta_nl(1), theta_dot_nl(1), 'b', 'LineWidth', 1.5);
h2_lin = plot(theta_lin(1), theta_dot_lin(1), 'g', 'LineWidth', 1.5);
h2_marker_nl = plot(theta_nl(1), theta_dot_nl(1), 'ro', 'MarkerFaceColor', 'r');
h2_marker_lin = plot(theta_lin(1), theta_dot_lin(1), 'mo', 'MarkerFaceColor', 'm');

% Connecting lines
h_line_x_to_phase_nl = line([0, 0], [0, 0], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5);
h_line_x_to_phase_lin = line([0, 0], [0, 0], 'Color', 'm', 'LineStyle', '-.', 'LineWidth', 1.5);
h_line_xp_to_phase_nl = line([0, 0], [0, 0], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5);
h_line_xp_to_phase_lin = line([0, 0], [0, 0], 'Color', 'm', 'LineStyle', '-.', 'LineWidth', 1.5);

title('Phase Space');
xlabel('x(t)'); ylabel("x'(t)");
xlim(x_lims);
ylim(xp_lims);
grid on;

% 3. 3D Beam Animation
subplot(2,2,3);
axis_lim = L * 0.5;
axis([-axis_lim axis_lim -axis_lim axis_lim -axis_lim axis_lim]);
grid on; hold on;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('3D Beam Animation');
set(gca, 'Projection', 'perspective');
view([70 30]);

% Fixed pivot point
plot3(0, 0, 0, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');
plot3(0, offset, 0, 'ko', 'MarkerSize', 6, 'MarkerFaceColor', 'k');

% Initial beam transformation and visualization
beam_a_nl = (roty(rad2deg(theta_nl(1))) * beam_local')';
beam_a_lin = (roty(rad2deg(theta_lin(1))) * beam_local')';

% Draw beams
h_beam_nl = plot3(beam_a_nl(:,1), beam_a_nl(:,2), beam_a_nl(:,3), 'b-', 'LineWidth', 2);
h_beam_lin = plot3(beam_a_lin(:,1), beam_a_lin(:,2)+offset, beam_a_lin(:,3), 'g-', 'LineWidth', 2);

% Create handles for balls representing masses
h_balls = [
    plot3(beam_a_nl(1,1), beam_a_nl(1,2), beam_a_nl(1,3), 'o', 'MarkerSize', mass_scale*m2, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k'),
    plot3(beam_a_nl(2,1), beam_a_nl(2,2), beam_a_nl(2,3), 'o', 'MarkerSize', mass_scale*m1, 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k'),
    plot3(beam_a_lin(1,1), beam_a_lin(1,2)+offset, beam_a_lin(1,3), 'o', 'MarkerSize', mass_scale*m1, 'MarkerFaceColor', 'm', 'MarkerEdgeColor', 'k'),
    plot3(beam_a_lin(2,1), beam_a_lin(2,2)+offset, beam_a_lin(2,3), 'o', 'MarkerSize', mass_scale*m2, 'MarkerFaceColor', 'c', 'MarkerEdgeColor', 'k')
];

% 4. Position plot (rotated)
subplot(2,2,4);
h3_nl = plot(theta_nl(1), tspan(1), 'b', 'LineWidth', 1.5);
hold on;
h3_lin = plot(theta_lin(1), tspan(1), 'g', 'LineWidth', 1.5);
h3_marker_nl = plot(theta_nl(1), tspan(1), 'ro', 'MarkerFaceColor', 'r');
h3_marker_lin = plot(theta_lin(1), tspan(1), 'mo', 'MarkerFaceColor', 'm');
title("t vs x(t) (rotated 90° counterclockwise)");
ylabel('t'); xlabel("x(t)");
xlim(x_lims);
ylim([tspan(1) tspan(end)]);
grid on;

% Create global legend
h_dummy_nonlinear = plot(NaN, NaN, 'b-', 'LineWidth', 2, 'Visible', 'off');
h_dummy_linear = plot(NaN, NaN, 'g-', 'LineWidth', 2, 'Visible', 'off');
legend_h = legend([h_dummy_nonlinear, h_dummy_linear], {'Non-Linear', 'Linear'}, 'Orientation', 'horizontal');
set(legend_h, 'Units', 'normalized');
set(legend_h, 'Position', [0.4, 0.02, 0.2, 0.05]);

%% Animation parameters
num_frames = length(tspan);
frame_step = animation_step;
pause_time = frame_step/num_frames;

%% Animation main loop
while ishandle(fig)
    for k = 1:frame_step:num_frames
        if ~ishandle(fig)
            break;
        end

        current_t = tspan(k);

        % Current state values
        current_theta_nl = theta_nl(k);
        current_theta_dot_nl = theta_dot_nl(k);
        current_theta_lin = theta_lin(k);
        current_theta_dot_lin = theta_dot_lin(k);

        % Update velocity plot
        set(h1_nl, 'XData', tspan(1:k), 'YData', theta_dot_nl(1:k));
        set(h1_lin, 'XData', tspan(1:k), 'YData', theta_dot_lin(1:k));
        set(h1_marker_nl, 'XData', current_t, 'YData', current_theta_dot_nl);
        set(h1_marker_lin, 'XData', current_t, 'YData', current_theta_dot_lin);

        % Update phase space plot
        set(h2_nl, 'XData', theta_nl(1:k), 'YData', theta_dot_nl(1:k));
        set(h2_lin, 'XData', theta_lin(1:k), 'YData', theta_dot_lin(1:k));
        set(h2_marker_nl, 'XData', current_theta_nl, 'YData', current_theta_dot_nl);
        set(h2_marker_lin, 'XData', current_theta_lin, 'YData', current_theta_dot_lin);

        % Update connecting lines
        set(h_line_x_to_phase_nl, 'XData', [current_theta_nl, current_theta_nl], 'YData', [xp_lims(1), current_theta_dot_nl]);
        set(h_line_xp_to_phase_nl, 'XData', [x_lims(1), current_theta_nl], 'YData', [current_theta_dot_nl, current_theta_dot_nl]);
        set(h_line_x_to_phase_lin, 'XData', [current_theta_lin, current_theta_lin], 'YData', [xp_lims(1), current_theta_dot_lin]);
        set(h_line_xp_to_phase_lin, 'XData', [x_lims(1), current_theta_lin], 'YData', [current_theta_dot_lin, current_theta_dot_lin]);

        % Update 3D beam animation
        % Calculate transformed beam positions
        beam_a_nl = (roty(rad2deg(current_theta_nl)) * beam_local')';
        beam_a_lin = (roty(rad2deg(current_theta_lin)) * beam_local')';

        % Update beam and ball positions
        set(h_beam_nl, 'XData', beam_a_nl(:,1), 'YData', beam_a_nl(:,2), 'ZData', beam_a_nl(:,3));
        set(h_beam_lin, 'XData', beam_a_lin(:,1), 'YData', beam_a_lin(:,2)+offset, 'ZData', beam_a_lin(:,3));

        % Update mass positions
        set(h_balls(1), 'XData', beam_a_nl(1,1), 'YData', beam_a_nl(1,2), 'ZData', beam_a_nl(1,3));
        set(h_balls(2), 'XData', beam_a_nl(2,1), 'YData', beam_a_nl(2,2), 'ZData', beam_a_nl(2,3));
        set(h_balls(3), 'XData', beam_a_lin(1,1), 'YData', beam_a_lin(1,2)+offset, 'ZData', beam_a_lin(1,3));
        set(h_balls(4), 'XData', beam_a_lin(2,1), 'YData', beam_a_lin(2,2)+offset, 'ZData', beam_a_lin(2,3));

        % Update 3D title with current time and angles
        subplot(2,2,3);
        title(sprintf('Time = %.2f s, θ_{NL} = %.2f, θ_{Lin} = %.2f', current_t, current_theta_nl, current_theta_lin));

        % Update position plot
        set(h3_nl, 'XData', theta_nl(1:k), 'YData', tspan(1:k));
        set(h3_lin, 'XData', theta_lin(1:k), 'YData', tspan(1:k));
        set(h3_marker_nl, 'XData', current_theta_nl, 'YData', current_t);
        set(h3_marker_lin, 'XData', current_theta_lin, 'YData', current_t);

        drawnow;
        pause(pause_time);
    end

    % If we complete one full animation cycle, pause before repeating
    if ishandle(fig)
        pause(1);
    else
        break;
    end
end
