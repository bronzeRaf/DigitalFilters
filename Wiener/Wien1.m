clear

%% Prameters

% input signal
load('C:\Users\Raft\Projects & Software\Digital Filtering Project\1\sounds.mat');

% Initialize parameters
n = 20*Fs;          % number of time steps
num_coef = 500;     % number of coefficients
max_iter = 10000;   % number of iteration of the training process

var_d = var(d); % The variance of input (x)

%% Calculate R, p

tic;            % start the clock
%Calculate autocorrelation
U = u;
for i = 1:(num_coef-1)
    zer = zeros(i,1);
    U = [U [zer; u(1:n-i)]];
end
Rt = U'*U / n;

% Cross correlation numerically
pt = xcorr(d, u, 500) / n;
ps = pt(501:end-1);

R = Rt;
p = ps;
timeRP = toc  % stop the clock

%% Run the steepest descent algorithm

% Wiener solution
wo = R \ p;
w = (-1)*ones(num_coef,1); % initialize for SD algorithm

tic;            % start the clock

% Adaptation step selection
mu = 2*0.5 / max(abs(eig(R)));
mu_domain = [0 2/max(abs(eig(R)))];

% Initialize some memory
wt = zeros([num_coef,max_iter]); wt(:,1) = w;
y = zeros(n, 1);

% Training loop
for i = 1:max_iter
    w = w + mu*(p-R*w); % adaptation step
    wt(:,i) = w;        % store train history
end

timeSD = toc   % stop the clock

s = u; % input of the filter
for i = num_coef:n
  y(i) = s(i:-1:i-num_coef+1)' * w; % filter
end

% Remove the noise
e = d - y;

% Plot a metric of error
% Uncomment following lines to plot y-u
figure(1); clf
plot(y-u)
title('Recorded noise, Calculated noise Difference')
xlabel('timestep');
ylabel('Calculated Noise y - Recorded Noise u');

%% parameter error

we = (wt - wo*ones(1,max_iter)).^2;
pe = sqrt(sum(we));

% Plot Parameter error
% figure(2); clf
% semilogy(pe);
% xlabel('time step n');
% ylabel('Parameter error');
% title('Parameter error');

min(pe) % display minimun parameter error

%% Listen to the signal

% Uncomment following lines to listen to the 3 signals
% sound(d, Fs)  % mixed signal
% sound(u, Fs)  % noise signal
% sound(e, Fs)  % clean signal



