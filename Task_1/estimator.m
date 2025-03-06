function Tp = estimator(x,lambda,tau,win,fs)

idx = find(x,1); 
start = idx + tau; 
A = x(idx);
finish = 0;

for i = start:win
   if x(i)>=A*exp(-lambda.*(i-start))
   finish = i;
       break;
   end
end
if finish == 0
    Tp = win/fs; 
else
    Tp = (finish-idx)/fs;
end

end