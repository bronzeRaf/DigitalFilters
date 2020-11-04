% Confirmation of the statement 
% If R * w = r_B, then R_T * w_B = r
% 
% author: Rafael Brouzos
% date: 18 May 2018

%% Prepare Parameters
clear all
close all

% Define matrix size
n = 1000;

% Create the random complex column and the random vector
col = randn(n,1) + 1i*randn(n,1);
w = randn(n,1);

%% Run the calculations

% Get the conjugate row
row = conj(col);
% Reverse the vector
wb = w(end:-1:1);

% Find the Toeplitz matrices
R = toeplitz(col,row);  % create the Toeplitz matrix
Rt = R.';               % get the transpose matrix

% Get the 1st product
rb = R*w;

% Get the 2nd product
r = Rt*wb;

% Reverse the vector
r2 = rb(end:-1:1);

%% Confirm Results

% Check the error
if max(abs(r2-r)) < 10e-10
    disp('Theory Confirmed')
else
    disp 'WRONG THEORY'
end

% Plot the error
plot(r2-r,'.')
title([num2str(n) ' point w, Complex Error'])
xlabel('Re')
ylabel('Im')

% Display the maximun absolute error
max(abs(r2-r))