% Joint Process estimator for broadband signal recovery in music.mat
% 
% author: Rafael Brouzos
% date: 18 May 2018
% 
% NOTE! This script uses music.mat, LevinsonDurbin_iterative.m and 
% jointProcessFilter.m files. You have to keep these files in the same
% directory with the script.

%% Set Parameters
clear all
close all

load('music.mat');  % load s (audio signal) and fs (sample rate)
delta = 24;       % number of coefficients and lags
n = length(s);
y1 = zeros(n,1);    % preallocate the Wiener filtered signal
y2 = zeros(n,1);    % preallocate the Joint Process estimated signal

%% Calulate r, R
                                                    tic;
[rfull, lags] = xcorr(s,delta); % autocorrelation

r = rfull(delta+1:end);
R = toeplitz(r);

%% Calculate Wiener Coefficients

wo = R(2:end,2:end) \ r(2:end); % solve the standart Wiener Hopf Equation
w = [1; -wo];                   % add the 1
                                                    Twiener = toc

%% Clean The Signal

% Filter application loop
for i=delta+1:n
  y1(i) = s(i:-1:i-delta)' * w;  % apply filter (Wiener)
end

%% Levison Durbin algorithm
                                                    tic;
% Iterative version of Levinson-Durbin algorithm
[a, g, L, D] = LevinsonDurbin_iterative(delta, r);
                                                    Tlevin = toc

%% Regression  filter

% Calculate gamma for the regression filter
gammav = L' \ w;

% Apply the filter
y2 = jointProcessFilter(s, g, gammav);
                                                    Treg = toc

%% Plot the signals

plot(s(1000:end))
hold on
plot(y2(1000:end))
legend('s','u')
title([num2str(delta) ' coefficients'])