k1=-1.0000;k2=-1.6567;k3=18.6854;k4=3.4594;
g=9.81;M = 0.5;m = 0.2;b = 0.1;I = 0.006;l = 0.3;laux=100;
r=pi;dt=0.01;F=0;
t=0:dt:10;
n_states=4;
x=zeros(n_states,length(t));
x(:,1)=[10,1,pi+0.01,0.2]';
%Euler method
for k=2:length(t)
x(1,k)=x(1,k-1)+dt*(x(2,k-1));
x(2,k)=x(2,k-1)+dt*(-(b*x(2,k-1)-F)*(I+l*l*m)+l*m*(x(4,k-1)*(I+l*l*m)...
    +g*l*m*cos(x(3,k-1)))*sin(x(3,k-1)))/((I+l*l*m)*(m+M)...
    -l*l*m*m*cos(x(3,k-1))*cos(x(3,k-1)));
x(3,k)=x(3,k-1)+dt*(x(4,k-1));
x(4,k)=x(4,k-1)+dt*(2*l*m*(g*(M+m)*sin(x(3,k-1))...
    +cos(x(3,k-1))*(-b*x(2,k-1)+F+x(4,k-1)*x(4,k-1)*l*m*sin(x(3,k-1)))))/(-2*I*(m+M)...
    -l*l*m*(m+2*M)+l*l*m*m*cos(2*x(3,k-1)));

F=-(k1*x(1,k)+k2*x(2,k)+k3*(x(3,k)-r)+k4*x(4,k));
end

subplot(2,2,1)
plot(t,x(1,:))
subplot(2,2,2)
plot(t,x(2,:))
subplot(2,2,3)
plot(t,x(3,:))
subplot(2,2,4)
plot(t,x(4,:))
