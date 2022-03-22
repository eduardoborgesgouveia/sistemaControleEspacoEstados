%%x'(t+1) = A*x(t) + B*u(t)
%y(t) = H*x(t)
%onde:
%x(t) = Vetor de Estado
%y(t) = vetor de saída
%u(t) = Vetor de Controle ou vetor de entrada
%A - Matriz do Sistema
%B - Matriz de Input
%H - Matriz de Output
clear;
%--------------------------------------------------------------------------
%%
%---------entrada baseada nas coletas----------------------------
data = importdata('1_Brunao_forceSignal.txt');
baseLineForceVal = 0.63;
data = data';
data = data*(3/4096);
forceInput= data - baseLineForceVal;

%%
%----------Iniciando parametos--------------
fa = 200;
dt = 1/fa;
ti = 0;
tf = length(forceInput)*dt;
t = ti:dt:tf;
leftLim = 90;
rightLim = 1296;
deltaLim = rightLim - leftLim;
forceMax = 2.34;
forceMim = baseLineForceVal;
porcentForceMax = 0.4;
deltaForce = (forceMax - forceMim)*porcentForceMax;
%%
%----------Iniciando Matrizes--------------
A = [leftLim];
B = [deltaLim/deltaForce];
H = [1];
%%
%----------Simulação?-----------
xo = [1];
xi = xo;
for i=2:(length(t))
    xi(:,i) = A*xo + B*forceInput(i-1);  
    xo = xi(:,i);
end
y = H*xi + D*forceInput;

figure();
plot(y(1,:));


