function [ppe1, ppe2, ppe3, ppe4, ppe5, ppe6, fppe] = procena_pitch_periode(fs,N,m1,m2,m3,m4,m5,m6)

win = round(fs*15e-3);
NN = floor(N/(win/2));

ppe1 = zeros(1,NN);
ppe2 = zeros(1,NN);
ppe3 = zeros(1,NN);
ppe4 = zeros(1,NN);
ppe5 = zeros(1,NN);
ppe6 = zeros(1,NN);
fppe = zeros(1,NN);

lambda = 120/fs; 
tau = round(fs*4e-3);
k = 1;


for k_win = 1:win/2:N-win+1
    x = m1(k_win:k_win+win-1);
    ppe1(k) = estimator(x,lambda,tau,win,fs);
    x = m2(k_win:k_win+win-1);
    ppe2(k) = estimator(x,lambda,tau,win,fs);
    x = m3(k_win:k_win+win-1);
    ppe3(k) = estimator(x,lambda,tau,win,fs);
    x = m4(k_win:k_win+win-1);
    ppe4(k) = estimator(x,lambda,tau,win,fs);
    x = m5(k_win:k_win+win-1);
    ppe5(k) = estimator(x,lambda,tau,win,fs);
    x = m6(k_win:k_win+win-1);
    ppe6(k) = estimator(x,lambda,tau,win,fs);
    fppe(k) = nanmedian([ppe1(k),ppe2(k),ppe3(k),ppe4(k),ppe5(k),ppe6(k)]);
    k = k+1;
end
end