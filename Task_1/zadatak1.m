clear all;
close all;
clc;

fs = 8000;
Ts = 1/fs;
nchan = 1;
nbits = 16;
x = audiorecorder(fs, nbits, nchan);
duration = 20;
N = duration * fs;
disp('Start.')
recordblocking(x, duration);
disp('End.')
y = getaudiodata(x);
audiowrite('sekvenca.wav', y, fs);

%%
clear all;
close all;
clc;
[y, fs] = audioread('sekvenca.wav');
%sound(y, fs);

%% 
T = 1/fs;
t = 0:T:(length(y)-1)*T;

figure();
plot(t,y);
title('Govorni signal');xlabel('t[s]');ylabel('y');

N = 2^13;
Y = fft(y, N);
Ya = abs(Y(1:N/2));
f = 0:fs/N:fs/2-fs/N;

figure();
plot(f, Ya);
xlabel('f[Hz]');ylabel('fft');title('Amplitudski spektar signala');

%% Filtriranje
wn = [60 3000]/(fs/2);
[b,a]=butter(6, wn,'bandpass');%6 red filtra
yf = filter(b,a, y);

figure();
plot(t,yf);
title('Govorni signal filtriran');xlabel('t[s]');ylabel('yf');

N = 2^13;
Y = fft(yf, N);
Ya = abs(Y(1:N/2));
f = 0:fs/N:fs/2-fs/N;

figure();
plot(f, Ya);
xlabel('f[Hz]');ylabel('fft');title('Amplitudski spektar filtriranog signala');

%% STE i ZCR
wl = fs*20e-3;
E = zeros(1,length(yf));
Z = zeros(1,length(yf));
for i =wl:length(yf)-1
    rng = i-wl+1:i;
    E(i) = sum(yf(rng).^2);
    Z(i) = sum(abs(sign(yf(rng+1))-sign(yf(rng))));
end

Z = Z/2/wl;
figure();
plot(t, yf, t, E);
legend('signal', 'STE');
title('STE');
xlabel('t[s]');
figure();
plot(t, yf, t, Z);
title('ZCR');
legend('signal', 'ZCR');
xlabel('t[s]');

%% Segmentacija
ITU = max(E)*0.01;
ITL = max(E)*0.0004;
niz_pocetaka = [];
niz_kraja = [];
for i = 2:length(E)
    if(E(i-1)<ITU && E(i)>ITU)
        niz_pocetaka = [niz_pocetaka i];
    end
end

for i = 1:length(E)-1
    if(E(i)>ITU && E(i+1)<ITU)
        niz_kraja = [niz_kraja i];
    end    
end

rec = zeros(1, length(yf));
for i =1:length(niz_pocetaka)
    rec(niz_pocetaka(i):niz_kraja(i)) = ones(1,niz_kraja(i)-niz_pocetaka(i)+1);
end
figure()
plot(t, yf, t, rec);
ylim([0 2]);
xlabel('t[s]');
title('Segmentisane reči pre proširenja');

%% Potencijalno prosirenje reci

for i = 1:length(niz_pocetaka)
    while(E(niz_pocetaka(i))>ITL)
        niz_pocetaka(i) = niz_pocetaka(i)-1;
    end
    while(E(niz_kraja(i))>ITL)
        niz_kraja(i) = niz_kraja(i)+1;
    end
end
niz_pocetaka = unique(niz_pocetaka);
niz_kraja = unique(niz_kraja);
rec = zeros(1, length(yf));
for i =1:length(niz_pocetaka)
    rec(niz_pocetaka(i):niz_kraja(i)) = ones(1,niz_kraja(i)-niz_pocetaka(i)+1);
end
figure()
plot(t,yf, t, rec);
ylim([0 2]);
xlabel('t[s]');
title('Segmentisane reči nakon proširenja');

%% preslusavanje
for i =1:length(niz_pocetaka)
    sound(yf(niz_pocetaka(i):niz_kraja(i)),fs);
    pause
end