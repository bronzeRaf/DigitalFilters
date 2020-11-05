% Author: 	Rafail Brouzos, mprouzo@auth.gr, rnm1816@gmail.com
% Purpose:	Digital Wiener filter demo for removing the echo of a fake signal.
% 		Comparison of LMS, normalized LMS and RLS algorithms with the 
%       exact Wiener one.
% 
% IMPORTANT NOTICE! The following script is using the clear command to empty workspace. Please 
% make sure you have a backup of your workspace before running the script.


clear           % clear workspace

%% Parameters
var_v1 = 0.42;  % variance of white noise u1
var_v2 = 0.72;  % variance of white noise u2
n = 1000;       % signal length
m = 2;          % number of coefficients

% Initialize some memory
s = zeros(n,1);
u = zeros(n,1);
x = zeros(n,1);
d = zeros(n,1);
y = zeros(n,1);

%% Input signal Generation

fs = 526.3;  % sampling frequency
phase = 0:1/fs:19;
uu = 10*sin(2*pi*50*phase)';

xx = 15*sin(2*pi*23*phase + 11)';

%% System modeling

% Noise
v1 = sqrt(var_v1)*randn(n,1); v1 = v1 - mean(v1); % white noise 1
v2 = sqrt(var_v2)*randn(n,1); v2 = v2 - mean(v2); % white noise 2

% System's equations
s(1:3) = uu(1:3);
u(1:3) = uu(1:3) + v1(1:3);
x(1:3) = xx(1:3) + v2(1:3);
for i = 4:n
    s(i) = -0.13*uu(i) + 0.67*uu(i-1) - 0.18*uu(i-2) + 0.39*uu(i-3);
    u(i) = -0.87*uu(i-1) - 0.22*uu(i-2) - 0.032*uu(i-3) + v1(i);
    x(i) = -0.57*xx(i-1) - 0.16*xx(i-2) - 0.08*xx(i-3) + v2(i);
end
d = s + x;

%% Calculate R, p

                            tic;            % start the clock
% Calculate autocorrelation
[rfull, lags] = xcorr(u, m);    % autocorrelation
r = rfull(m+1:end-1);
R = toeplitz(r);
[pfull, lags] = xcorr(d, u, m);        % cross correlation
p = pfull(m+1:end-1);
                            Twiener = toc;  % stop the clock
                            
% mu domain based on the convergence criterion
mu_domain = [0 2/max(abs(eig(R)))];

%% Optimal Wiener Filter
                            tic;            % start the clock
wo = R \ p;
                            Toptimal = toc;  % stop the clock
% Apply the filter
for i = m:n
  y(i) = u(i:-1:i-m+1)' * wo; % filter
end
% Remove the noise
eo = d - y;

%% LMS adaptive Filter
                            tic;            % start the clock
% Parameters
mu_lms = 18e-07;        % step length of the LMS algorithm
T = 100;
av_J_lms = zeros(n,1);  % MSE

for t=1:T
    % Initialize
    w_lms = zeros(m, 1);
    y_lms = zeros(n, 1);
    e_lms = zeros(n, 1);
    J_lms = zeros(n, 1);
    
    for i=(m+1):n
        
        y_lms(i) = w_lms'*u(i:-1:(i-m+1));
        e_lms(i) = d(i) - y_lms(i);
        w_lms = w_lms + mu_lms*e_lms(i)*u(i:-1:(i-m+1));
        J_lms(i) = e_lms(i)^2;
        av_J_lms(i) = av_J_lms(i) + J_lms(i);

    end
end

                            Tlms = toc;  % stop the clock
% Apply the filter
for i = m:n
  y(i) = u(i:-1:i-m+1)' * w_lms; % filter
end
% Remove the noise
e_lms = d - y;              % system output
av_J_lms(i) = av_J_lms(i)/T;% MSE

%% Normalized LMS adaptive Filter
                            tic;            % start the clock
% Parameters
T = 100;
av_J_n_lms = zeros(n,1);% MSE
a = 0.001;
mu_n_lms = 18e-06;      % step length of the normalized LMS algorithm 

for t=1:T
    % Initialize
    w_n_lms = zeros(m, 1);
    y_n_lms = zeros(n, 1);
    e_n_lms = zeros(n, 1);
    J_n_lms = zeros(n, 1);
    
    for i=(m+1):n
        y_n_lms(i) = w_n_lms'*u(i:-1:(i-m+1));
        e_n_lms(i) = d(i) - y_n_lms(i);
        normu = (sum(u(i:-1:(i-m+1))))^2;
        w_n_lms = w_n_lms + (mu_n_lms*e_n_lms(i)*u(i:-1:(i-m+1)))/(a+normu);
        J_n_lms(i) = e_n_lms(i)^2;
        av_J_n_lms(i) = av_J_n_lms(i) + J_n_lms(i);
    end
end

                            Tnlms = toc;  % stop the clock
% Apply the filter
for i = m:n
  y(i) = u(i:-1:i-m+1)' * w_n_lms; % filter
end
% Remove the noise
e_n_lms = d - y;                % system output
av_J_n_lms(i) = av_J_n_lms(i)/T;% MSE

%% RLS adaptive Filter

                            tic;            % start the clock
% Parameters
T = 100;
av_J_rls = zeros(n,1);% MSE
a = 0.001;
lambda = 1;
delta = 1/1000*var(u);


for t=1:T
    % Initialize
    % initialize
    w_rls = zeros(m, 1);
    y_rls = zeros(n, 1);
    e_rls = zeros(n, 1);
    J_rls = zeros(n, 1);
    P = (1/delta) * eye(m, m);
    
    for i = (m+1):n
        y_rls(i) =   w_rls(:)' * u(i:-1:i-m+1);
        k = ( (lambda^-1)*P*u(i:-1:i-m+1) / (1 + (lambda^-1)*u(i:-1:i-m+1)'*P*u(i:-1:(i-m+1))) );
        e_rls(i) = d(i) - y_rls(i);
        w_rls(:) = w_rls(:) + k * e_rls(i);
        P = (lambda^-1)*P - (lambda^-1)*k*u(i:-1:(i-m+1))'*P;
        J_rls(i) = e_rls(i)^2;
        av_J_rls(i) = av_J_rls(i) + J_rls(i);
    end
end
                            Trls = toc;  % stop the clock
% Apply the filter
for i = m:n
  y(i) = u(i:-1:i-m+1)' * w_rls; % filter
end
% Remove the noise
e_rlms = d - y;                % system output
av_J_rls(i) = av_J_rls(i)/T;% MSE