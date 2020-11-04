% Author : Rafail Brouzos, 7945, mprouzos@auth.gr
% 
% This script compare the exact Toeplitz with vector multiplication with an
% algorithm using an approximation to reduce complexity at O(N*log(N)).
% 
% Uses the "fastMul" function. This means that you need the "fastMul.m" to
% be stored in the same directory with the current script.


% Get a clean workspace
clear
clf
close all

%iterate for multiple result comparison
for i = 3000:8000
    
% Initialize the parameters
n = i;
m = 1000;
u = randn(n, 1);
w = randn(m, 1);
T = toeplitz( u(m:n), u(m:-1:1) );



%% Exact product
tic;
t = cputime;

    y = T*w;

tAcpuExact(i) = cputime-t;
tAexact(i) = toc;

%% Estimated product
tic;
t = cputime;

    yf = fastMul(T(:,1),T(1,:),w);

tAcpuEstimated(i) = cputime-t;
tAestimated(i) = toc;

%% Calculate error

e(i) = norm( yf - y )/norm(y);

end

%% Plot
% tt=find(tAestimated>0);
% loglog(tt,tAexact(tt))
% hold on;
% loglog(tt,tAestimated(tt))
% title('Run time Matrix*vector(m=1000')
% xlabel('n')
% ylabel('Time (sec)')

% plot(e)
% title('approximation error')
% xlabel('n')
% ylabel('Error')
