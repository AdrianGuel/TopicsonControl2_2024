clearvars;
%% Example 1
Am=[[1,1];[0,1]];
Bm=[0.5,1]';
Cm=[1,0];
n=2;
Om=[0,0];
A=[[Am,Om'];[Cm*Am,1]];
B=[Bm;Cm*Bm];
C=[Om,1];
lambda=eig(A);

%% Example 2
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
rki=1;
%first case
Rs=ones(Np,1)*rki;
R=0*eye(Nc);
xki=[0.1,0.2]';
DU=(Phi'*Phi+R)\Phi'*(Rs-F*xki);

%second case
Rs=ones(Np,1)*rki;
R=10*eye(Nc);
xki=[0.1,0.2]';
DU=(Phi'*Phi+R)\Phi'*(Rs-F*xki);

%plot second example
x=zeros(2,Np);
y=zeros(1,Np);
u=zeros(1,Np);
x(:,1)=xki;
for k=1:Np
    if k<=Nc
        x(:,k+1)=A*x(:,k)+B*DU(k);
        if k>1
            u(k)=DU(k)+u(k-1);
        else
            u(k)=DU(k);         
        end        
    else
        x(:,k+1)=A*x(:,k)+B*0;
        u(k)=u(k-1);
    end
 y(k)=C*x(:,k);
end
figure
plot(u)
hold on 
plot(DU)
hold on
plot(y)
legend('u(k)','\Deltau(k)','y(k)');
xticklabels({'10','11','12','13','14','15','16','17','18','19'})
