% Wiener coefficients calculation from Augmnented Wiener-Hopf equation
% 
% author: Rafael Brouzos
% date: 18 May 2018

%% Prameters

% Clean workspace
clear all
close all

% Initialize parameters
n = 100;        % number of oefficiens of the filter

%% Simulate an autocorrelation matrix R
r = rand(n,1);     % augmented r vector
R = toeplitz(r);    % augmented autocorrelationmatrix


%% Calculate coefficients

wo = R(2:end,2:end) \ r(2:end); % solve the standart Wiener Hopf Equation
W = [1; -wo];              % add the 1
