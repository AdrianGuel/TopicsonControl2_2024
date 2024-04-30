close all
clearvars
% Parameters
g = 9.81;   % acceleration due to gravity (m/s^2)
L = 1;      % length of the pendulum (m)
theta0 = pi/3; % initial angle (rad)
fv=0.22;
omega0 = 0; % initial angular velocity (rad/s)
tspan = [0 10]; % time span for simulation (s)
dt = 0.05;  % time step (s)

% Function to calculate derivatives
f = @(t, y) [y(2); -g/L*sin(y(1))-fv*y(2)];

% Initial conditions
y0 = [theta0; omega0];

t = tspan(1):dt:tspan(2);
n = length(t);
y = zeros(length(y0),n);
y(:, 1) = y0;

% Jacobiano
At=[0,1;-(g/L)*cos(y(1,1)),-fv];
dx=zeros(length(y0),n);
% Animation
figure;
for i = 1:length(t)-1
    %non-linear system solution
    k1 = f(t(i), y(:,i));
    k2 = f(t(i) + dt/2, y(:,i) + dt/2 * k1);
    k3 = f(t(i) + dt/2, y(:,i) + dt/2 * k2);
    k4 = f(t(i) + dt, y(:,i) + dt * k3);
    y(:, i+1) = y(:, i) + dt/6 * (k1 + 2*k2 + 2*k3 + k4);
    %linearizarion solution
    dx(:,i+1)=[0,1;-(g/L)*cos(y(1,i)),-fv]*dx(:,i);
    % Pendulum position
    theta = y(1, i+1)+dx(1,i+1);
    xx = L*sin(theta);
    yy = -L*cos(theta);
    plot([0 xx], [0 yy], 'r', 'LineWidth', 2);
    axis([-1.5*L 1.5*L -1.5*L 0.5*L]);
    title(['Simple Pendulum Animation (t = ' num2str(t(i)) ' s)']);
    xlabel('x (m)');
    ylabel('y (m)');
    grid on;
    drawnow;
endfor

figure;
subplot(1,2,1)
plot(t,y(1,:),'k')
hold on
plot(t,y(1,:)+dx(1,:),'b--')
subplot(1,2,2)
plot(t,y(2,:),'k')
hold on
plot(t,y(2,:)+dx(2,:),'b--')
