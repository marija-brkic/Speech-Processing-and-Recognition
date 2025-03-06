function [x1, x2] = feature_extraction(x, fs, p)
    win = 20e-3*fs;
    num = round(length(x)/win);
    lpcs = zeros(num,p+1);
    k=1;
 
    for i=1:win:(length(x)-win)
        lpcs(k,:) = aryule(x(i:(i+win-1)),p);
        k = k+1;
    end
    
    lpcs2 = median(lpcs,1);
    %figure();
    %plot(lpcs2);
    %title('LPC koeficijenti AR modela');
    x1 = lpcs2(8);
    lpcs2 = abs(lpcs2);
    lpcs2 = lpcs2>0.5;
    x2 = sum(lpcs2);
end