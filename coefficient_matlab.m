
close all
clear
clc


% Dane 
fc = 20;                 % Częstotliwość odcięcia filtru               % częstotliwośc generownanego sygnału propstokątnego
fs =1000;                 % Częstotliwość próbkowania czyli sygnał
Ts = 1/fs;                  % odstęp między próbkami
n  = 4;                   % Rząd filtru
duty = 50;                  % Wypełnienie   
N = 2000;                  % ilość próbek do przefiltrowania

% Filtr Butterwortha
Wn = fc/(fs/2); % Normalizacja współczynników
[b,a] = butter(n, Wn, 'low');        % Tworzenie współczynników
hz = tf(b,a,Ts,'variable','z^-1');   % Transformata H(Z)
isstable(hz)
hz                                    



% Z-plane
figure; zplane(b,a); grid on; title('Z-plane: poles (x) & zeros (o)');

v_step = [zeros(1,200) ones(1,N-200)];
v_imp = [1 zeros(1,N-1)];
y_step = filter(b,a,v_step);
y_imp = filter(b,a,v_imp);

figure;
subplot(2,1,1);plot(v_step);grid on; title('Skok');
subplot(2,1,2); plot(y_step); grid on; title('Odpowiedź na skok');


figure;
subplot(2,1,1);plot(v_imp);grid on; title('Impuls');
subplot(2,1,2); plot(y_imp);grid on;title('Odpoweidz Impulsowa');

% "Skok średniej + szum"
v = zeros(1,N);
v(1:1000) = 0;
v(1001:end) = 1;

v = v + 0.5*randn(1,N);
y = filter(b,a,v);

figure;
subplot(2,1,1);plot(v);grid on; title('Wejście : skok średniej + szum');
subplot(2,1,2); plot(y); grid on; title('Odpowiedź na skok z szumem');

fprintf("STD wejścia (po ustaleniu): %.4f\n", std(v(6000:end)));
fprintf("STD wyjścia (po ustaleniu): %.4f\n", std(y(6000:end)));

writematrix(v(:),"input.txt");
writematrix([v(:) y(:)], "ref.csv");

data = readmatrix("output.csv");
v_fpga = data(:,1).';
y_fpga = data(:,2).';
k = 0:length(y_fpga)-1

figure;
plot(k, y(1:length(y_fpga)), 'r--', 'LineWidth', 1.5);
hold on;
plot(k, y_fpga, 'b', 'LineWidth', 1);
grid on;
legend('MATLAB (reference)', 'FPGA');
xlabel('Próbka');
ylabel('Amplituda');
title('Porównanie: FPGA vs MATLAB');
