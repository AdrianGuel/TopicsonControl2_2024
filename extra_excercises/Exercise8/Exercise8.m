clc; clear; close all;

% Parámetros
A = [-0.5 -1; 1 -0.5];  % Matriz del sistema
x0 = [1; 1];            % Condición inicial
dt = 0.1;               % Paso de tiempo
t_final = 10;           % Tiempo total
t = 0:dt:t_final;       % Vector de tiempo

% Solución numérica del sistema
x = zeros(2, length(t));
x(:,1) = x0;

for k = 2:length(t)
    x(:,k) = (eye(2) + dt*A) * x(:,k-1);  % Método de Euler para integración
end

% Cálculo de las normas
norm_L2 = vecnorm(x, 2, 1);  % Norma Euclidiana
norm_L1 = sum(abs(x), 1);    % Norma L1 (Manhattan)
norm_Linf = max(abs(x), [], 1);  % Norma L∞ (máximo absoluto)

% Configuración de la figura
fig = figure;
subplot(1,2,1);
hold on; grid on; axis equal;
xlim([-1.5 1.5]); ylim([-1.5 1.5]);
xlabel('x_1'); ylabel('x_2');
title('Evolución del vector de estado');
h_vector = quiver(0, 0, x(1,1), x(2,1), 'r', 'LineWidth', 2, 'MaxHeadSize', 0.1);
h_traj = plot(x(1,1), x(2,1), 'b-', 'LineWidth', 1);

% Subplot de norma Euclidiana
subplot(1,2,2);
hold on; grid on;
xlabel('Tiempo (s)'); ylabel('||x||_2');
title('Normas ');
h_norm_L1 = plot(t(1), norm_L1(1), 'g', 'LineWidth', 2,'DisplayName', 'L1 (Manhattan)');
h_norm_L2 = plot(t(1), norm_L2(1), 'r', 'LineWidth', 2, 'DisplayName', 'L2 (Euclidiana)');
h_norm_Linf = plot(t(1), norm_Linf(1), 'b', 'LineWidth', 2, 'DisplayName', 'L∞ (Máximo)');
legend('show');
axis([0 10 -1 2.5]);

% Animación
while ishandle(fig)
for k = 2:length(t)
    % Actualizar vector de estado
    set(h_vector, 'UData', x(1,k), 'VData', x(2,k));
    set(h_traj, 'XData', x(1,1:k), 'YData', x(2,1:k));

    % Actualizar normas en sus respectivos gráficos
    set(h_norm_L2, 'XData', t(1:k), 'YData', norm_L2(1:k));
    set(h_norm_L1, 'XData', t(1:k), 'YData', norm_L1(1:k));
    set(h_norm_Linf, 'XData', t(1:k), 'YData', norm_Linf(1:k));

    pause(0.05);
end
end
