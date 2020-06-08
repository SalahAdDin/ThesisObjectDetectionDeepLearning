function [x0 y0] = intersectionPoint(m1,m2,b1,b2)
% Insersection point of two lines with known slope and constant
% parameters.
% [x0 y0] = intersectPoints(m1,m2,b1,b1)
% where m's are slope, and b's are constants.
% written by Tutku Öztel in 06.01.2019
x0 = (b2-b1)/(m1-m2); %find the x point
y0 = m1*x0+b1;
end