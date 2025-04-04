# Visualización de Estabilidad de Lyapunov en GNU Octave

Este repositorio contiene un script de GNU Octave que anima la trayectoria de un sistema lineal estable junto con las **cotas de Lyapunov**, demostrando cómo las funciones de Lyapunov garantizan estabilidad asintótica.

![Ejemplo de animación](animation_screenshot.gif) *(Ejecuta el código para ver la animación en tiempo real)*

## Características
- Simula un sistema lineal autónomo con matriz Hurwitz (`A`).
- Resuelve la ecuación de Lyapunov para obtener la matriz `P`.
- Grafica:
  - **Trayectoria del sistema** (línea roja).
  - **Curvas de nivel de la función de Lyapunov** (elipses).
  - **Cota exponencial** basada en el análisis de Lyapunov (círculo azul).
- Animación en bucle continuo hasta que se cierre la ventana.

## Uso
1. Abre el script `lyapunov_animation.m` en GNU Octave.
2. Ejecuta el script (menú `Ejecutar` o tecla `F5`).
3. Observa la animación:
   - **Línea roja**: Trayectoria del sistema desde la condición inicial `x0 = [3; 3]`.
   - **Elipses grises**: Niveles de energía constante `V(x) = c`.
   - **Círculo azul**: Cota superior teórica `||x(t)|| ≤ x_bound(t)`.

## Explicación del Código
### Configuración Inicial
```matlab
A = [-1 2; 0 -3];  % Matriz del sistema (Hurwitz)
Q = eye(2);
P = lyap(A', Q);    % Solución de la ecuación de Lyapunov
```

### Simulación
- Se utiliza `ode45` para resolver numéricamente las ecuaciones diferenciales.
- La cota `x_bound` se calcula usando los autovalores de `P`:
  ```matlab
  x_bound = sqrt(V0/lambda_min) * exp(-t/(2*lambda_max));
  ```

### Animación
- **Bucle continuo**: La animación se repite hasta que se cierra la ventana.
- **Actualización en tiempo real**:
  ```matlab
  set(traj_plot, 'XData', x(1:k,1), 'YData', x(1:k,2));  % Trayectoria
  set(bound_plot, 'XData', x_circle, 'YData', y_circle); % Cota
  ```

## Personalización
- **Cambiar el sistema**: Modifica la matriz `A` (asegúrate de que sea Hurwitz).
- **Ajustar condición inicial**: Edita `x0 = [3; 3]`.
- **Modificar velocidad de animación**: Cambia `pause(0.05);` (tiempo en segundos).

### Notas Adicionales
1. **Interpretación Física**:
   - Las **elipses** representan niveles de "energía" (`V(x) = c`).
   - La **cota azul** garantiza que la trayectoria nunca escape del círculo (estabilidad).
2. **Soporte**:
   - Si el círculo no se contrae, verifica que `A` sea Hurwitz (autovalores con parte real negativa).
