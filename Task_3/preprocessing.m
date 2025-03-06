function [x1] = preprocessing(x, fs)
    T = 1/fs;
    t = 0:T:(length(x)-1)*T;
    %{
    figure();
    plot(t,x);
    title('Govorni signal');xlabel('t[s]');ylabel('x');

    N = 2^13;
    X = fft(x, N);
    Xa = abs(X(1:N/2));
    f = 0:fs/N:fs/2-fs/N;

    figure();
    plot(f, Xa);
    xlabel('f[Hz]');ylabel('fft');title('Amplitudski spektar signala');
    %}

    wn = [60 2500]/(fs/2);
    [b,a]=butter(6, wn,'bandpass');%6 red filtra
    xf = filter(b,a, x);
    
    %{
    figure();
    plot(t,xf);
    title('Govorni signal filtriran');xlabel('t[s]');ylabel('xf');

    N = 2^13;
    X = fft(xf, N);
    Xa = abs(X(1:N/2));
    f = 0:fs/N:fs/2-fs/N;

    figure();
    plot(f, Xa);
    xlabel('f[Hz]');ylabel('fft');title('Amplitudski spektar filtriranog signala');
    %}

    wl = fs*20e-3;
    E = zeros(1,length(xf));
    Z = zeros(1,length(xf));
    for i =wl:length(xf)-1
        rng = i-wl+1:i;
        E(i) = sum(xf(rng).^2);
        Z(i) = sum(abs(sign(xf(rng+1))-sign(xf(rng))));
    end

    Z = Z/2/wl;

    %{
    figure();
    plot(t, xf, t, E);
    legend('signal', 'STE');
    title('STE');
    xlabel('t[s]');
    figure();
    plot(t, xf, t, Z);
    title('ZCR');
    legend('signal', 'ZCR');
    xlabel('t[s]');
    %}
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
    
    rec = zeros(1, length(xf));
    for i =1:length(niz_pocetaka)
        rec(niz_pocetaka(i):niz_kraja(i)) = ones(1,niz_kraja(i)-niz_pocetaka(i)+1);
    end
    %{
    figure()
    plot(t, xf, t, rec);
    ylim([0 2]);
    xlabel('t[s]');
    title('Segmentisane reči pre proširenja');
    %}
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
    rec = zeros(1, length(xf));
    for i =1:length(niz_pocetaka)
        rec(niz_pocetaka(i):niz_kraja(i)) = ones(1,niz_kraja(i)-niz_pocetaka(i)+1);
    end
    
    %{
    
    figure()
    plot(t,xf, t, rec);
    ylim([0 2]);
    xlabel('t[s]');
    title('Segmentisane reči nakon proširenja');
    
    %}
    
    x1 = xf(niz_pocetaka(1):niz_kraja(end));
   
end