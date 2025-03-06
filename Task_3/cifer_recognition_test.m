function [] = cifer_recognition_test(W, W1)
    devet = [];
    jedan = [];
    pet = [];
    K1 = [];
    K2 = [];
    K3 = [];
    for i =1:5
        [y, fs] = audioread(['devet_test\sekvenca'  num2str(i) '.wav']);
        devet = [devet; y'];
    end
    for i =1:5
        [y, fs] = audioread(['jedan_test\sekvenca'  num2str(i) '.wav']);
        jedan = [jedan; y'];
    end
    for i =1:5
        [y, fs] = audioread(['pet_test\sekvenca'  num2str(i) '.wav']);
        pet = [pet; y'];
    end

    for i =1:5
        x = preprocessing(devet(i,:), fs);
        [x1, x2] = feature_extraction(x, fs, 50);
        K1 = [K1, [x1 ; x2]];
    end
    for i =1:5
        x = preprocessing(jedan(i,:), fs);
        [x1, x2] = feature_extraction(x, fs, 50);
        K2 = [K2, [x1 ; x2]];
    end
    for i =1:5
        x = preprocessing(pet(i,:), fs);
        [x1, x2] = feature_extraction(x, fs, 50);
        K3 = [K3, [x1 ; x2]];
    end
    
    figure();
    plot(K1(1,:), K1(2,:),'sb', K2(1,:), K2(2,:),'hg', K3(1,:), K3(2,:),'ro');
    legend('devet', 'jedan', 'pet');
    xlabel('x1');
    ylabel('x2');
    title('Klase');
    grid on;

    classification_test(K1', K2', K3', W, W1);
end