% Script for running part2 of the project, extraction of features from 
% written characters on screen

clc
clear all
close all

c = DrawCharacter;
% figure;
% subplot(3,1,1), plot(c(1,:)), title('Evolution of the x-coordinate');
% subplot(3,1,2), plot(c(2,:)), title('Evolution of the y-coordinate');
% subplot(3,1,3), plot(c(3,:),'x'), title('Evolution of mouse button press');
[features,coordinates] = ExtractFeatures(c); % extract the features of the character
%new_data = PreprocessData(features);