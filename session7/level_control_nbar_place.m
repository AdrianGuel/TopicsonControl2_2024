Cc=1600;
R=0.1603;
dt=0.001;
tf=2500;
t=0:dt:tf;
h=zeros(1,length(t));
qi=zeros(1,length(t));
xi=zeros(1,length(t));
A=-1/(R*Cc);
B=1/Cc;
C=1;
h(1)=10;

K_feedback=5;
Ki=-0.3433;
Nu=1/R;
Nx=1;
Nbar=Nu+K_feedback*Nx;
r=30;
for k=2:length(t)
    h(k)=h(k-1)+dt*A*h(k-1)+dt*B*qi(k-1);
    y=h(k);
    xi(k)=xi(k-1)+dt*(r-y);
    qi(k)=r-K_feedback*y-Ki*xi(k);
    % if(qi(k)>10)
    %     qi(k)=10;
    % end
end
subplot(3,1,1)
plot(t,h)
subplot(3,1,2)
plot(t,qi)
subplot(3,1,3)
plot(t,e)

Acl=[[0 -C];[0 A]];
Bcl=[0;1];
p = [-0.1, -0.3];
K_feedback = place(Acl,Bcl,p);
h=zeros(1,length(t));
qi=zeros(1,length(t));
xi=zeros(1,length(t));
e= zeros(1,length(t));
for k=2:length(t)
    h(k)=h(k-1)+dt*A*h(k-1)+dt*B*qi(k-1);
    y=h(k);
    e(k)=r-y;
    xi(k)=xi(k-1)+dt*e(k);
    qi(k)=r-K_feedback(1)*xi(k)-K_feedback(2)*h(k);
    % if(qi(k)>10)
    %     qi(k)=10;
    % end
end

subplot(3,1,1)
plot(t,h)
subplot(3,1,2)
plot(t,qi)
subplot(3,1,3)
plot(t,e)
