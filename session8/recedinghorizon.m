%% Receding Horizon
%for graphics
N=10; %experimentation time
xm=zeros(1,N);
x=zeros(2,N);
y=zeros(1,N);
u=zeros(1,N);
du=zeros(1,N);

%initial conditions
xm(1)=0.2;
y(1)=0.2; % output of extended system
dx=0.1;
x(:,1)=[dx,y(1)]';
u(1)=0;
du(1)=7.2;
% model parameters
a=0.8;b=0.1;c=1;Np=10;Nc=4;
Am=a;
Bm=b;
Cm=1.0;
Om=0;
% state space with integral control
A=[[Am,Om'];[Cm*Am,1]];
B=[Bm;Cm*Bm];
C=[Om,1];

%fill up F
F=[];
Phi=[];
for N=1:Np
    F=[F;C*(A^N)];
end
%fillup Phi
for Nu=1:Nc
    vaux=[];
    for N=1:Np
        if N-Nu>=0
            delta=1;
        else
            delta=0;
        end
        vaux=[vaux;C*(A^(N-Nu))*B*delta];
    end
    Phi=[Phi;vaux];
end
Phi=reshape(Phi,Np,Nc);

%reference
rki=1;

Rs=ones(Np,1)*rki;
R=0*eye(Nc);

% Receding horizon
for k=2:N
    u(k)=u(k-1)+du(k-1);
    xm(k)=Am*xm(k-1)+Bm*u(k); %system 
    dx=xm(k)-xm(k-1);
    y(k)=xm(k);
    xki=[dx,y(k)]';
    DU=(Phi'*Phi+R)\Phi'*(Rs-F*xki);
    du(k)=DU(1);
end
figure
plot(u)
hold on
plot(du)
hold on
plot(xm)
legend('control u(k)','control increment \Deltau(k)','x_m')
