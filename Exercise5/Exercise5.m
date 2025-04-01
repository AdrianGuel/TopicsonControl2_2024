% Sistema de ecuaciones diferenciales de segundo orden
% \ddot{x} = -0.5\dot{x} -0.5x + sin(t)

% Convertir a sistema de primer orden:
% y1 = x
% y2 = \dot{x}
%
% \dot{y1} = y2
% \dot{y2} = -0.5*y2 - 0.5*y1 + sin(t)

% Definir el sistema de ecuaciones
f = @(y, t) [y(2);             % Primera ecuación: dy1/dt = y2
             -0.5*y(2) - 0.5*y(1) + sin(t)]; % Segunda ecuación

% Condiciones iniciales [x0; x'_0]
y0 = [0.5; 1];  % x(0) = 0.5, x'(0) = 0

% Configurar tiempo de integración
t_total = linspace(0, 20, 1000)';  % Vector temporal columna

% Resolver el sistema
sol = lsode(f, y0, t_total);

% Extraer soluciones
x_total = sol(:,1);      % Posición
xprime_total = sol(:,2); % Velocidad

% Precalcular límites de ejes
x_lims = [min(x_total)-0.1, max(x_total)+0.1];
xp_lims = [min(xprime_total)-0.1, max(xprime_total)+0.1];

% Configurar animación
fig = figure;
set(fig, 'Position', [100 100 800 600]);

% Inicializar gráficos
subplot(2,2,1);
h1 = plot(t_total(1), x_total(1), 'b', 'LineWidth', 1.5);
hold on;
h1_marker = plot(t_total(1), x_total(1), 'ro', 'MarkerFaceColor', 'r');
title('x(t) vs t');
xlabel('t'); ylabel('x(t)');
xlim([t_total(1) t_total(end)]);
ylim(x_lims);
grid on;

subplot(2,2,2);
h2 = plot(x_total(1), xprime_total(1), 'b', 'LineWidth', 1.5);
hold on;
h2_marker = plot(x_total(1), xprime_total(1), 'ro', 'MarkerFaceColor', 'r');
title('Espacio de Fase');
xlabel('x(t)'); ylabel("x'(t)");
xlim(x_lims);
ylim(xp_lims);
grid on;

subplot(2,2,4);
h3 = plot(t_total(1), xprime_total(1), 'b', 'LineWidth', 1.5);
hold on;
h3_marker = plot(t_total(1), xprime_total(1), 'ro', 'MarkerFaceColor', 'r');
title("x'(t) vs t");
xlabel('t'); ylabel("x'(t)");
xlim([t_total(1) t_total(end)]);
ylim(xp_lims);
grid on;

% Configurar velocidad de animación (5 segundos total)
num_frames = length(1:10:length(t_total));
pause_time = 5/num_frames;

% Bucle de animación
for k = 1:10:length(t_total)
    current_t = t_total(k);
    current_x = x_total(k);
    current_xp = xprime_total(k);

    % Actualizar gráfico temporal x(t)
    set(h1, 'XData', t_total(1:k), 'YData', x_total(1:k));
    set(h1_marker, 'XData', current_t, 'YData', current_x);

    % Actualizar espacio de fase
    set(h2, 'XData', x_total(1:k), 'YData', xprime_total(1:k));
    set(h2_marker, 'XData', current_x, 'YData', current_xp);

    % Actualizar gráfico temporal x'(t)
    set(h3, 'XData', t_total(1:k), 'YData', xprime_total(1:k));
    set(h3_marker, 'XData', current_t, 'YData', current_xp);

    % Control de velocidad y renderizado
    pause(pause_time);
    drawnow;
end
