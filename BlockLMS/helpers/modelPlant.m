% Author : Rafail Brouzos, 7945, mprouzos@auth.gr
% 
% This script compares the models of 4 different implemented block LMS
% filters.
% 
% Uses the "blocklms" functions. This means that you need the "blocklms1.m"
% to "blocklms4.m" to be stored in the same directory with the current 
% script.


clear           % clear the workspace
close all

var_v = 0.57;   % variance of white noise
n = 1000000;      % timestep
M = 2^10;
mu1 = 0.0000001;
mu2 = 0.0000001;
mu3 = 0.0001;
mu4 = 0.00001;

v = sqrt(var_v)*randn(n,1); v = v - mean(v); % white noise

d = plant(v')';

% Plant instead of plant! The given plant.p is not workingthrowing error:
% "Index exceeds matrix dimensions.
% Error in plant (line 25)"
% d = sin(v);     % get the desired signal


% Test the 4 implementations of the block LMS algorithm

% Nested loops
tic;
t = cputime;

    [e1, w1] = blocklms1(mu1,M,v,d);

tCcpu1 = cputime-t;
tC1 = toc;

% Expressions of matrices
tic;
t = cputime;

    [e2, w2] = blocklms2(mu2,M,v,d);

tCcpu2 = cputime-t;
tC2 = toc;

% Fast LMS (Frequency domain)
tic;
t = cputime;

    [e3, w3] = blocklms3(mu3,M,v,d);

tCcpu3 = cputime-t;
tC3 = toc;

% Unconstrained Fast LMS (Frequency domain)
tic;
t = cputime;

    [e4, w4] = blocklms4(mu4,M,v,d);

tCcpu4 = cputime-t;
tC4 = toc;


%% Plot
figure; semilogx(e1(1024:end))
title('Learning Curve 1')
xlabel('timestep')
ylabel('Error y-d')

figure; semilogx(e2(1024:end))
title('Learning Curve 2')
xlabel('timestep')
ylabel('Error y-d')

figure; semilogx(e3(1024:end))
title('Learning Curve 3')
xlabel('timestep')
ylabel('Error y-d')

figure; semilogx(e4(1024:end))
title('Learning Curve 4')
xlabel('timestep')
ylabel('Error y-d')