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
y0 = [1; 0];  % x(0) = 0.5, x'(0) = 0
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

% x'(t) vs t en la posición 1
subplot(2,2,1);
h1 = plot(t_total(1), xprime_total(1), 'b', 'LineWidth', 1.5);
hold on;
h1_marker = plot(t_total(1), xprime_total(1), 'ro', 'MarkerFaceColor', 'r');
title("x'(t) vs t");
xlabel('t'); ylabel("x'(t)");
xlim([t_total(1) t_total(end)]);
ylim(xp_lims);
grid on;

% Espacio de fase
subplot(2,2,2);
h2 = plot(x_total(1), xprime_total(1), 'b', 'LineWidth', 1.5);
hold on;
h2_marker = plot(x_total(1), xprime_total(1), 'ro', 'MarkerFaceColor', 'r');
title('Espacio de Fase');
xlabel('x(t)'); ylabel("x'(t)");
xlim(x_lims);
ylim(xp_lims);
grid on;

% Gráfica rotada de x(t) vs t en posición 4 (x en vertical, t en horizontal)
subplot(2,2,4);
h3 = plot(x_total(1), t_total(1), 'b', 'LineWidth', 1.5);
hold on;
h3_marker = plot(x_total(1), t_total(1), 'ro', 'MarkerFaceColor', 'r');
title("t vs x(t) (rotado 90° antihorario)");
ylabel('t'); xlabel("x(t)");  % Intercambia etiquetas
xlim(x_lims);  % Usa los límites de x(t) para el eje x
ylim([t_total(1) t_total(end)]);  % Usa los límites de tiempo para el eje y
grid on;

% Crear las líneas de conexión
% Línea desde x(t) a espacio de fase (inicialmente vacía)
subplot(2,2,2);
h_line_x_to_phase = line([0, 0], [0, 0], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1.5);

% Línea desde x'(t) a espacio de fase (inicialmente vacía)
subplot(2,2,2);
h_line_xp_to_phase = line([0, 0], [0, 0], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1.5);

% Configurar velocidad de animación (5 segundos total)
num_frames = length(1:10:length(t_total));
pause_time = 5/num_frames;

% Variable para controlar bucle de repetición
running = true;

% Ejecutar animación en bucle hasta cerrar la ventana
while running && ishandle(fig)
    for k = 1:10:length(t_total)
        if ~ishandle(fig)
            running = false;
            break;
        end

        current_t = t_total(k);
        current_x = x_total(k);
        current_xp = xprime_total(k);

        % Actualizar gráfico temporal x'(t)
        set(h1, 'XData', t_total(1:k), 'YData', xprime_total(1:k));
        set(h1_marker, 'XData', current_t, 'YData', current_xp);

        % Actualizar espacio de fase
        set(h2, 'XData', x_total(1:k), 'YData', xprime_total(1:k));
        set(h2_marker, 'XData', current_x, 'YData', current_xp);

        % Actualizar gráfico rotado de x(t) (t en eje y, x en eje x)
        set(h3, 'XData', x_total(1:k), 'YData', t_total(1:k));
        set(h3_marker, 'XData', current_x, 'YData', current_t);

        % Actualizar línea de conexión desde x(t) al espacio de fase
        % Línea horizontal desde el valor de x(t) hasta el punto en el espacio de fase
        set(h_line_x_to_phase, 'XData', [current_x, current_x], 'YData', [xp_lims(1), current_xp]);

        % Actualizar línea de conexión desde x'(t) al espacio de fase
        % Línea vertical desde el valor de x'(t) hasta el punto en el espacio de fase
        set(h_line_xp_to_phase, 'XData', [x_lims(1), current_x], 'YData', [current_xp, current_xp]);

        % Control de velocidad y renderizado
        pause(pause_time);
        drawnow;
    end
end
