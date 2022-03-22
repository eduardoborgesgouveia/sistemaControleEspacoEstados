%{
Universidade Federal de Uberl�ndia
Laborat�rio de Engenharia Biom�dica

Autor: Eduardo Borges Gouveia
e-mail: eduardoborgesgouveia@gmail.com

Descri��o: Determina��o do systema de controle baseado em estado de espa�os
conhecendo apenas a entrada e a sa�da do sistema. Script desenvolvido
baseado no artigo:

"State-Space System Realization With Input and Output Data
Correlation"
Langley Research Center * Hampton, Virginia * April 1997

INPUT:
u - "forceSignal.txt"

OUTPUT:
x - "position.txt"

%}
clear;
%% Carregando o INPUT E OUTPUT
forceTotal = importdata('forceSignal.txt');
positionTotal = importdata('position.txt');
forceInput = forceTotal(6216:8738,:);
position = positionTotal(6216/10:8738/10,:);

y = position(:,2)';
%% Para que u e y tenham o mesmo tamanho � necessario fazer uma m�dia de 
% a cada 10 amostras de u visto que durante a aquisi��o o mesmo � feito de
% u para gerar y. 
forceInput = forceInput';
POSi = 1;
POSf = 10;
i = 1;
while(POSf<length(forceInput))
    AUXu(i) = mean(forceInput(1,POSi:POSf));
    i = i+1;
    POSi = POSf+1;
    POSf = POSf + 10;
end

%devido ao consumo de dados pela placa Arduino ainda � necessario retirar 
%alguns valores do vetor u 
u = AUXu(1:end - abs(length(y)-length(AUXu)));


baseLineForceVal = 0.63;
u = u*(3/4096);
u = u - baseLineForceVal;

%% Determinando os parametros
fa = 20;
dt = 1/fa;
x = 1:length(u);
t = x.*dt;
t = t - dt;

n = 2; %a ordem desejada do sistema
m = 1; %a quantidade de outputs
p = n/m + 1;
L = length(u);
%N = L - p+1;
N = L - 1 - p + 2;
%% 
z = 0;
for j = 1:p
   for i = 1:N-1
      U(j,i) =  u(1,i+z);
      Y(j,i) = y(1,i+z);
   end
   z = z + 1;
end

%%
Ryy = (Y*Y')/N;
Ryu = (Y*U')/N;
Ruu = (U*U')/N;


%% Calculos da matriz de correla��o

Rhh = Ryy - Ryu*(inv(Ruu))*Ryu';

singularValueDecomposition = svd(Rhh);

[AuxOp,E,TranspAuxOp] = svd(Rhh);

Op = AuxOp(:,1:(end-1));

C = (Op((1:m),:));

A = (Op(1:(p-1)*m,:)')*Op((m+1):p*m,:);

Uo = AuxOp(:,end);

%% tentando fazer a equa��o 61 pg 18

%Tnup(1) = [Uum]*d + [conta doida]*b
Im = [1];
In = [1 0; 0 1];

Uum = Im*u(1);
Uun = In*u(1);

zero = zeros([m n]);

fi = [C Uum zero];

teta = fi'*Y(1,1);

for i=1:n
   X(i) = teta(i,:); 
end

D = teta(n+1,:);
B = teta(n+2:n+3,:);
%% simula��o

xo = X';
xi = xo;
for i=2:(length(t))
    xi(:,i) = A*xo + B*u(i-1);  
    xo = xi(:,i);
end
yReconstruida = C*xi + D*u;

% tempToPlot = 1:length(yReconstruida);
% tempToPlot = tempToPlot.*dt;
% tempToPlot = tempToPlot - dt;

figure();
plot(y);
hold on;
plot(yReconstruida);
legend('original','reconstruida');
xlabel('tempo [s]');
ylabel('posi��o em pixels');
title('Compara��o Sa�das');
r = 19;




















