% Decision making
% MPC control for mobile robot
% The code uses
% fmincon from MATLAB

close all;
clearvars;

%% optimiser
T=0.1; tf=10;
t=0:T:tf;
lb = [0,0];
ub = [10,10];
A = [];
b = [];
Aeq = [];
beq = [];
nonlcon = [];
u0 = [0,0];
yr=[1,1,0];
u=zeros(2,length(t));
x=zeros(3,length(t));
options = optimoptions('fmincon','Algorithm','interior-point');
u(:,1)=u0';
figure
plot(yr(1),yr(2),'rx')
hold on
for k=2:length(t)
    u(:,k)= fmincon(@(du) J_N(t,yr,x(:,k-1),du),u(:,k-1)',A,b,Aeq,beq,lb,ub,nonlcon,options);
    x(:,k)=x(:,k-1)+T*f(x(:,k-1),u(:,k)); 
    plot([x(1,k),x(1,k-1)],[x(2,k),x(2,k-1)],'k-o');
    pause(0.1);
end
xlabel('Time t');
ylabel('Solution y');
legend('goal','pos')

figure
plot(t,u(1,:))
hold on
plot(t,u(2,:))
xlabel('Time t');
ylabel('u');
title('MPC');


function dydt = f(y,u)
    dydt = [u(1)*cos(y(3));u(1)*sin(y(3));u(2)];
end

function cost=J_N(t,yr,y0,u)
N=10;
yc=zeros(3,length(N));
T=diff(t(1:2));
yc(:,1)=y0;
    for k=2:N
        %% Euler
        yc(:,k)=yc(:,k-1)+T*f(yc(:,k-1),u);    
    end
    cost=norm(yr(1)-yc(1,:))^2+norm(yr(2)-yc(2,:))^2+0.08*norm(u)^2;
end
