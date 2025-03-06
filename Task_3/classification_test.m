function [] = classification_test(K1, K2, K3, W, W1)
X12 = [K1; K2];
N = 5;

v0 = W(1); v1 = W(2); v2 = W(3);

x11 = 0:0.001:0.25;
x21 = -(v0+v1*x11)/v2;

figure();
plot(K1(:,1), K1(:,2), 'ro', K2(:,1), K2(:,2), 'bx', K3(:,1), K3(:,2), 'gh');
hold all;
plot(x11,x21,'k--');
legend('devet', 'jedan', 'pet', 'Klasifikaciona linija');
xlabel('x1');ylabel('x2');
title('Klasifikacija');
grid on;
xlim([0 0.25]);
ylim([3 6]);

Ylabel = [ones(1,N), 2*ones(1,N), 3*ones(1,N)];
Ypred = ones(1,3*N);

X = [X12; K3];


v_opt = [v1; v2];
for i =1 : 3*N
   x = X(i,:)';
   if (v_opt' * x + v0) > 0
       Ypred(i) = 3;  
       disp('pet');
   end  
end

ind = find(Ypred==1);


v0 = W1(1); v1 = W1(2); v2 = W1(3);

x12 = 0:0.001:0.25;
x22 = -(v0+v1*x11)/v2;

figure();
plot(K1(:,1), K1(:,2), 'ro', K2(:,1),K2(:,2), 'bx', K3(:,1), K3(:,2), 'gh');
hold all;
plot(x11,x21,'k--');
plot(x12,x22,'k--');
xlabel('x1');ylabel('x2');
title('Klasifikacija');
grid on;
xlim([0 0.25]);
ylim([3 6]);
legend('devet', 'jedan', 'pet', 'Klasifikaciona linija 1', 'Klasifikaciona linija 2');

v_opt = [v1; v2];
if ~isempty(ind)
    X = X(ind,:);
    for i =1 :length(X)
        x = X(i,:)';
        if (v_opt' * x + v0) > 0
            disp('jedan');
            Ypred(i) = 2;  
        else
            disp('devet');
        end  
    end
end

C = confusionmat(Ylabel,Ypred);
figure()
cm = confusionchart(Ylabel,Ypred);
end