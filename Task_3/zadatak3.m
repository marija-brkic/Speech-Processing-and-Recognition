clear all;
close all;
clc;
%% 
%recording();
%% 
[W, W1] = cifer_recognition();
%%
%recording_test();
%%
cifer_recognition_test(W, W1);