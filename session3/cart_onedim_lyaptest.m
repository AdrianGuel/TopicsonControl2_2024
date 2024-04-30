%cart system
n=2;
M=rand(n);
M=0.5*(M+M.');
L=10;
for k=1:n
  M(k,k)=L*rand;
endfor
Q=M;

%Define ssytem
M=1;
b=0.2;
kx=0.9;

A = [0,1;
-k/M,-b/M];
B = [0;1/M];
C = [1 0];
D = 0;

%Find P
%If there is no solution system is unstable
P = lyap (A.', Q)
