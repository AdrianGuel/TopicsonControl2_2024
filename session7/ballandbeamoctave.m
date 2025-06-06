%% pkg install -forge control %Install the Control package (if not already installed):
%% pkg load control %Load the package before using lqr or place:
%% Then run the code:

ms = 0.1; % "Mass of ball"
rs = 0.015; %"Radius of the ball"
g = -9.8; % "Gravitational Acceleration"
L = 1.0; %"Beam length"
Ib=1e7; %"Beam Inertia, value"
Is = (2/5)*ms*rs^2; %"Sphere's moment of Inertia"
A=[[0,1,0,0];[0,0,-ms*g/(Ib+ms),0];[0,0,0,1];[-5*g/7,0,0,0]];
B=[0,1/(Ib+ms),0,0]';
C=[[1,0,0,0],[0,0,1,0]];
%Q=eye(4);Q(1,1)=500; Q(2,2)=100; Q(3,3)=100; Q(4,4)=50;
%R=10;
%K_feedback = lqr(A,B,Q,R)
dt=0.01;
tf=1000;
t=0:dt:tf;
n_states=4;
x=zeros(n_states,length(t));
tau=zeros(1,length(t));
tau_e=ms*g;
dx=zeros(n_states,length(t));
u=zeros(1,length(t));
%p=[-7,-6,-10,-15]
%K_feedback=place(A,B,p);
K_feedback=[4.8514e+04,9.8503e+05,4.2906e+00,2.1423e+02]; %LQR
%K_feedback=[9.7000e+08,1.7000e+08,1.8000e+08,2.9571e+08]; %Pole placement
dx(:,1)=[0,0,0.03,0]';
x(:,1)=[0,0,1.3,0]';
for k=2:length(t)
    x(1,k)=x(1,k-1)+dt*x(2,k-1);
    x(2,k)=x(2,k-1)+dt*(-2*ms*x(3,k-1)*x(2,k-1)*x(4,k-1)...
        -ms*g*x(3,k-1)*cos(x(1,k-1))+tau(k-1))/(Ib+ms*x(3,k-1)^2);
    x(3,k)=x(3,k-1)+dt*x(4,k-1);
    x(4,k)=x(4,k-1)+dt*(5*x(3,k-1)*x(2,k-1)^2-5*g*sin(x(1,k-1)))/7;
    dx(:,k)=dx(:,k-1)+dt*A*dx(:,k-1)+dt*B*(-K_feedback*dx(:,k-1));
    u(k)=-K_feedback(1)*x(1,k)...
        -K_feedback(2)*x(2,k)...
        -K_feedback(3)*(x(3,k)-1) ...
        -K_feedback(4)*x(4,k);
    tau(k)=(tau_e+u(k));
end
figure
subplot(2,2,1)
plot(t,dx(1,:))
xlabel("t");
ylabel("theta");

subplot(2,2,2)
plot(t,dx(2,:))
xlabel("t");
ylabel("theta_dot");

subplot(2,2,3)
plot(t,dx(3,:))
xlabel("t");
ylabel("r");

subplot(2,2,4)
plot(t,dx(4,:))
xlabel("t");
ylabel("r_dot");

% Optional workaround for sgtitle in Octave
axes('Position',[0 0 1 1],'Visible','off');
text(0.5, 1, 'Linearisation over equilibrium system', ...
     'HorizontalAlignment','center', 'FontWeight','bold');

figure
subplot(2,2,1)
plot(t,x(1,:))
xlabel("t");
ylabel("theta");

subplot(2,2,2)
plot(t,x(2,:))
xlabel("t");
ylabel("theta_dot");

subplot(2,2,3)
plot(t,x(3,:))
xlabel("t");
ylabel("r");

subplot(2,2,4)
plot(t,x(4,:))
xlabel("t");
ylabel("r_dot");

% Optional workaround for sgtitle in Octave
axes('Position',[0 0 1 1],'Visible','off');
text(0.5, 1, 'Nonlinear system', ...
     'HorizontalAlignment','center', 'FontWeight','bold');
