%% Balancing Beam Stabilization with Finite-Horizon LQR (Discrete-Time)
clear; close all; clc;
pkg load control;

%% System Parameters (continuous-time)
m1    = 0.2;    % mass at one end [kg]
m2    = 0.35;   % mass at other end [kg]
mb    = 0.5;    % beam mass [kg]
L     = 1;      % beam length [m]
g     = 9.81;   % gravity [m/s^2]
b     = 0.08;   % viscous damping [N*m*s/rad]
u_c   = 0.001; % Coulomb friction coeff
eps   = 1e-3;   % smoothing for tanh

% Inertia and linearization
i  = 1/12*mb*L^2 + 1/4*(m1+m2)*L^2;
aa = b/i;
bb = (u_c*g*L)/(2*i);
cc = ((m2-m1)*g*L)/(2*i);
dd = L/(2*i);
theta_e = -pi/2; theta_dot_e = 0;

% Continuous model
A = [0 1; -cc*sin(theta_e) -aa - bb/eps];
B = [0; dd];

%% Discretize
Ts = 0.01;  % sample time
N  = 500;    % horizon steps
sysc = ss(A,B,eye(2),zeros(2,1));
sysd = c2d(sysc, Ts, 'zoh');
Ad = sysd.A; Bd = sysd.B;

%% Finite-Horizon LQR
Q = diag([5,0.1]);
R = 0.1;
P = zeros(2,2,N+1);
K = zeros(1,2,N);
P(:,:,N+1) = Q;
for k = N:-1:1
    K(:,:,k) = (R + Bd'*P(:,:,k+1)*Bd) \ (Bd'*P(:,:,k+1)*Ad);
    P(:,:,k) = Ad'*P(:,:,k+1)*Ad + Q - Ad'*P(:,:,k+1)*Bd*K(:,:,k);
end

%% Simulate discrete dynamics
x = zeros(2,N+1);
x(:,1) = [4*pi/10; -5];
x_err = x - repmat([theta_e;theta_dot_e],1,N+1);
t = (0:N)*Ts;
u = zeros(1,N);
for k = 1:N
    nu(k) = -K(:,:,k)*x_err(:,k);
    x_err(:,k+1) = Ad*x_err(:,k) + Bd*nu(k);
    x(:,k+1) = x_err(:,k+1) + [theta_e;theta_dot_e];
end
theta = x(1,:);
omega = x(2,:);

%––– Ploteo de K, P y x en nueva figura –––
figure;

% 1) Elementos de K (2 ganancias) vs t
subplot(1,2,1);
plot(t(1:N), squeeze(K(1,1,1:N)), 'LineWidth',1.5); hold on;
plot(t(1:N), squeeze(K(1,2,1:N)), 'LineWidth',1.5);
title('Elementos de K vs t');
xlabel('t [s]'); ylabel('K');
legend('K_{1}','K_{2}');
grid on;

% 2) Elementos de P (P_{11}, P_{12}=P_{21}, P_{22}) vs t
subplot(1,2,2);
plot(t(1:N), squeeze(P(1,1,1:N)), 'LineWidth',1.5); hold on;
plot(t(1:N), squeeze(P(1,2,1:N)), 'LineWidth',1.5);
plot(t(1:N), squeeze(P(2,2,1:N)), 'LineWidth',1.5);
title('Elementos de P vs t');
xlabel('t [s]'); ylabel('P');
legend('P_{11}','P_{12}','P_{22}');
grid on;


%% Pre-calculate limits
theta_lims = [min(theta)-0.1, max(theta)+0.1];
omega_lims = [min(omega)-0.1, max(omega)+0.1];

%% Animation Setup
fig = figure;

% 1) omega vs time
subplot(2,2,1);
h1 = plot(t(1),omega(1),'g','LineWidth',1.5);
hold on;
h1_m = plot(t(1),omega(1),'mo','MarkerFaceColor','m');
title("\omega(t) vs t");
xlabel('t [s]');
ylabel('\omega [rad/s]');
xlim([t(1),t(end)]);
ylim(omega_lims);
grid on;

% 2) Phase space with vector field
subplot(2,2,2);
hold on;
[thg, omg] = meshgrid(linspace(theta_lims(1),theta_lims(2),20), linspace(omega_lims(1),omega_lims(2),20));
dth = omg;
domg = -cc*sin(theta_e).*(thg-theta_e) - (aa+bb/eps).*(omg-theta_dot_e);

quiver(thg,omg,dth,domg, 'k');

h2 = plot(theta(1),omega(1),'g','LineWidth',1.5);
h2_m = plot(theta(1),omega(1),'mo','MarkerFaceColor','m');
h_eq = plot(theta_e,theta_dot_e,'kp','MarkerSize',10,'MarkerFaceColor','y');

title('Phase Space'); xlabel('\theta [rad]'); ylabel('\omega [rad/s]');
xlim(theta_lims); ylim(omega_lims); grid on;

% 3) 3D Beam
subplot(2,2,3);
axis_lim = L/2; axis([-axis_lim axis_lim -axis_lim axis_lim -axis_lim axis_lim]);
grid on; view([70 30]); hold on;
h_beam = plot3(nan,nan,nan,'g-','LineWidth',2);
h_m1 = plot3(nan,nan,nan,'mo','MarkerSize',m1*50,'MarkerFaceColor','m');
h_m2 = plot3(nan,nan,nan,'co','MarkerSize',m2*50,'MarkerFaceColor','c');
beam_pts = [-L/2,0,0; L/2,0,0];
title('3D Beam Animation');
xlabel('X');
ylabel('Y');
zlabel('Z');

% 4) theta vs time
subplot(2,2,4);
h3 = plot(theta(1),t(1),'g','LineWidth',1.5);
hold on;
h3_m = plot(theta(1),t(1),'mo','MarkerFaceColor','m');
title('t vs \theta(t)'); xlabel('\theta [rad]');
ylabel('t [s]');
xlim(theta_lims);
ylim([t(1),t(end)]);
grid on;

% Animation parameters
global frame_step pause_t;
##frame_step = 1;
##num = length(t);
##pause_t = Ts*frame_step;

frame_step = 5;
num = length(t);
pause_t = frame_step/num;

fig_handle = true;

while ishandle(fig)
    for k = 1:frame_step:num
        if ~ishandle(fig)
          fig_handle = false;
        end
        tt = t(k);
        th = theta(k);
        om = omega(k);
        % Update plots
        set(h1,'XData',t(1:k),'YData',omega(1:k));
        set(h1_m,'XData',tt,'YData',om);
        set(h2,'XData',theta(1:k),'YData',omega(1:k));
        set(h2_m,'XData',th,'YData',om);

        % 3D beam
        rot = (roty(rad2deg(th))*beam_pts')';
        set(h_beam,'XData',rot(:,1),'YData',rot(:,2),'ZData',rot(:,3));
        set(h_m1,'XData',rot(2,1),'YData',rot(2,2),'ZData',rot(2,3));
        set(h_m2,'XData',rot(1,1),'YData',rot(1,2),'ZData',rot(1,3));
        title(subplot(2,2,3), sprintf('t=%.2f s, \theta=%.2f rad',tt,th));
        % theta vs t
        set(h3,'XData',theta(1:k),'YData',t(1:k));
        set(h3_m,'XData',th,'YData',tt);
        pause(pause_t);
        drawnow;
    end
    % Break outer loop if figure closed
    if ~fig_handle
        break;
    end
end
