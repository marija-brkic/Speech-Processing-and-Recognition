function [] = recording_test()
    fs = 8000;
    Ts = 1/fs;
    nchan = 1;
    nbits = 16;
    x = audiorecorder(fs, nbits, nchan);
    disp('Jedan')
    for i=1:5
        duration = 3;
        N = duration * fs;
        disp(num2str(i));
        disp('Start.')
        recordblocking(x, duration);
        disp('End.')
        y = getaudiodata(x);
        audiowrite(['jedan_test\sekvenca' num2str(i) '.wav'], y, fs);
    end
    disp('Devet')
    for i=1:5
        duration = 3;
        N = duration * fs;
        disp(num2str(i));
        disp('Start.')
        recordblocking(x, duration);
        disp('End.')
        y = getaudiodata(x);
        audiowrite(['devet_test\sekvenca' num2str(i) '.wav'], y, fs);
    end
    disp('Pet')
    for i=1:5
        duration = 3;
        N = duration * fs;
        disp(num2str(i));
        disp('Start.')
        recordblocking(x, duration);
        disp('End.')
        y = getaudiodata(x);
        audiowrite(['pet_test\sekvenca' num2str(i) '.wav'], y, fs);
    end
end