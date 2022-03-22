clear;
%%
data = importdata('1_Brunao_forceSignal.txt');
baseLineForceVal = 0.63;
data = data';
data = data*(3/4096);
forceInput= data - baseLineForceVal;
forceInput = forceInput(942:1356);
fa = 200;
dt = 1/fa;
x = 1:length(forceInput);
t = x.*dt;
t = t - dt;
%% parece n�o funcionar (rs)
p = polyfit(x,forceInput,5);
ondaReconstruida = polyval(p,x);

figure();
plot(t,forceInput,t,ondaReconstruida);
legend('original','reconstruida');
title('compara��o de ondas');
xlabel('time [s]');
ylabel('tens�o [v]');

%%
[X,Y] = meshgrid(forceInput);
figure();
plot(1*X^1);

