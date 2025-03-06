clear all;
close all;
clc;
%%
fs = 8000;
Ts = 1/fs;
nchan = 1;
nbits = 16;
x = audiorecorder(fs, nbits, nchan);
duration = 10;
N = duration * fs;
disp('Start.')
recordblocking(x, duration);
disp('End.')
y = getaudiodata(x);
audiowrite('sekvenca1.wav', y, fs);
%%
clear all;
close all;
clc;
[y, fs] = audioread('sekvenca1.wav');
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
wn = [60 300]/(fs/2);
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

%% formiranje sekvenci
[m1, m2, m3, m4, m5, m6] = formiranje_sekvenci(yf);
n = 1:1000;
figure()
subplot(3,1,1)
stem(n, yf(n));
subplot(3,1,2)
stem(n, m1(n));
subplot(3,1,3)
stem(n, m2(n));

figure()
subplot(4,1,1)
stem(n, m3(n));
subplot(4,1,2)
stem(n, m4(n));
subplot(4,1,3)
stem(n, m5(n));
subplot(4,1,4)
stem(n, m6(n));

%% Procena pitch periode paralelnim procesiranjem

[p1,p2,p3,p4,p5,p6,p] = procena_pitch_periode(fs,length(yf),m1,m2,m3,m4,m5,m6);

disp('Procena pitch frekvencije paralelnim procesiranjem:');
disp([num2str(1/median(p)),'Hz']);
disp('Ugradjena estimacija:');
disp([num2str(median(pitch(yf,fs))),'Hz']);

%% Procena pitch periode pomocu autokorelacione funkcije
clip_level = 0.3*max(yf);
yf_clip = zeros(length(yf),1);

yf_clip(yf>clip_level) = 1;
yf_clip(yf<-clip_level) = -1;

p = 120;
N = length(yf_clip);
rxx = zeros(2*p+1,1);

for k = (p+1):(2*p+1)
    rxx(k) = sum(conj(yf_clip(1:(N-k+p+1))).*yf_clip((1+k-(p+1)):N))/N;
end

rxx(p:-1:1) = conj(rxx(p+2:end));

figure()
plot(rxx)
title('Autokorelaciona funkcija')
xlabel('k[odb]'); 
ylabel('r_x_x[k]')

k = 43;

disp('Estimacija autokorelacionom funkcijom: ');
disp([num2str(fs/k),'Hz']);
