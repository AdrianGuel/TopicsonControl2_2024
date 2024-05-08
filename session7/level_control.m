Cc=1600;
R=0.1603;
dt=25.64;
tf=2500;
t=0:dt:tf;
h=zeros(1,length(t));
qi=zeros(1,length(t));
xi=zeros(1,length(t));
A=-1/(R*Cc);
B=1/Cc;
C=1;
h(1)=10;

K_feedback=36.4276;
Ki=-0.3433;
r=30;
for k=2:length(t)
    h(k)=h(k-1)+dt*A*h(k-1)+dt*B*qi(k-1);
    y=h(k);
    xi(k)=xi(k-1)+dt*(r-y);
    qi(k)=-K_feedback*h(k)-Ki*xi(k);
end

plot(t,h)
