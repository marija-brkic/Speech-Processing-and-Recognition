clear all;
close all;
clc;

%%
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

%% mi companding kvantizator

mi = [100, 500];
b = [4, 8, 12];
aten = 0.01:0.01:1;

ymax = max(abs(y));
M = 2.^b;
d = 2*ymax./M;

for i=1:length(b)
    for j = 1:length(mi)
        xvar=zeros(size(aten));
        SNR_mi = zeros(size(aten));
        for k = 1:length(aten)
            x = aten(k)*y;
            xvar(k) = var(x);
            xq = ymax*log10(1+mi(j)*abs(x)/ymax)/(log10(1+mi(j))).*sign(x);
            xq_mi = round(xq/d(i))*d(i);
            x1 = 1/mi(j)*sign(xq_mi).*((1+mi(j)).^(abs(xq_mi)/ymax)-1)*ymax;
            SNR_mi(k) = var(x)/var(x-x1);
        end
        figure(i);
        semilogx(ymax./sqrt(xvar),10*log10(SNR_mi));
        hold all
        %semilogx(ymax./sqrt(xvar),4.77+6*b(i)-20*log10(log(1+mi(j)))-20*log10(1+(ymax/mi(j))^2./xvar+sqrt(2)*ymax/mi(j)./sqrt(xvar)),'r--');
        legend('mi=100', 'mi=500');
        title(['b=' num2str(b(i))]);
        xlabel('xmax/\sigma_x');
        ylabel('SNR');
    end
end

%% delta kvantizator

Q = 0.035;
ymean = mean(y);
L = length(y);
d = zeros(1,L); %prirastaj
d(1) = y(1);
c = zeros(1,L);
dd = zeros(1,L); %kvantizovani prirastaj
dd(1) = Q;
yy = zeros(1,L); %rekonstruisani signal
yy(1) = ymean +dd(1);

for i =2:L
    d(i) = y(i)-yy(i-1); %predikcija u i je rekosntrukcija iy proslog odbirka(ako je alpha = 1)
    if d(i)>0
        c(i) = 0;
        dd(i) = Q;
    else
        c(i) = 1;
        dd(i) = -Q;
    end
    yy(i) = yy(i-1)+dd(i);
end
figure();
n = round(2.2*fs):round(2.2*fs)+49;
x = y(n);
xx = yy(n);

plot(n, x, n, x, '*', n, xx, 'x', n(2:end), xx(1:end-1), 'o');
legend('Originalni signal', 'Semplovani signal', 'Rekonstrukcija', 'Predikcija');
xlabel('t[s]');

figure();
histogram(d,10);
title('Histogram priraštaja');

d_abs = abs(d);
d_sort = sort(d_abs);
d_opt = d_sort(round(0.9*length(d_sort)));
disp(d_opt);







