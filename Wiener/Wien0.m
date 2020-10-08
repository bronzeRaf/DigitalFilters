% Author: 	Rafail Brouzos, mprouzo@auth.gr, rnm1816@gmail.com
% Purpose:	Digital Wiener filter demo for removing the noise static noise of a signal.
% 		Comparison of a steepest descent converged filter with the exact Wiener one.
% 
% IMPORTANT NOTICE! The following script is using the clear command to empty workspace. Please 
% make sure you have a backup of your workspace before running the script.


clear

%% Prameters

% Initialize parameters
n = 100000;     % number of time steps
num_coef = 2;   % number of coefficiens of the filter
max_iter = 1000;% number of iteration of the training process

%% Input signal

x = zeros(n,1);
for i = 1:n
    x(i) = cos(pi*i)*sin (pi*i/25 + pi/3 );
end

var_x = var(x); % The variance of input (x)
var_v = 0.19;   % The variance of white noise (v)
alpha = -0.78;  % The coefficient of H(z)

%% Noise

v = sqrt(var_v)*randn(n,1); v = v - mean(v); % white noise

u = zeros(n,1); % initialize sensor
% Noise measured
u(1) = v(1);
for i=2:n
  u(i) = alpha * u(i-1) + v(i); % sensor's output
end

% Add the noise
d = x + v;

%% Calculate R, p

tic;            % start the clock
% Calculate autocorrelation
U = [u [0; u(1:n-1)]];
Rt = U'*U / n;

ps = zeros(2,1);
% Cross correlation from the differential equation
ps(1) = Rt(1,1) - alpha*Rt(1,2);
ps(2) = Rt(1,2) - alpha*Rt(1,1);

R = Rt;
p = ps;
timeRP = toc  % stop the clock

%% Run the steepest descent algorithm

% Wiener solution
wo = R \ p;
w = [-3; -3];   % initialize for SD algorithm

tic;            % start the clock

% Adaptation step selection
mu = 2*0.1 / max(abs(eig(R)));
% mu = 3.1;
mu_domain = [0 2/max(abs(eig(R)))];

% Initialize some memory
wt = zeros([2,max_iter]); wt(:,1) = w;
y = zeros(n, 1);

% Training loop
for i = 1:max_iter
    w = w + mu*(p-R*w); % adaptation step
    wt(:,i) = w;        % store train history
end

timeSD = toc    % stop the clock

s = u;  % input of the filter
% Filter application loop
for i=2:n
  y(i) = s(i:-1:i-1)' * w;  % apply filter
end

% Remove the noise
e = d - y;

% Plot filter
figure(1); clf
plot(x-e)
title('Output error (desired-output)')
xlabel('timestep')
ylabel('x-e');


%% Parameter error
figure(2); clf
we = (wt - wo*ones(1,max_iter)).^2;
pe = sqrt(sum(we));

semilogy(pe);
xlabel('time step n');
ylabel('Parameter error');
title('Parameter error');


%% contour curves and trajectories
L = 50;
ww = linspace(-2.5,2.5,L);

J = zeros([L,L]);

% Construct the error surface
for i=1:L
  for k=1:L
    wp = [ww(i); ww(k)];
    J(k,i) = var_v - 2*p'*wp + wp'*R*wp;
  end
end

min_J = min(J(:));
max_J = max(J(:));

levels = linspace(min_J,max_J,12);

figure(3)
contour(ww, ww, J, levels); axis square
hold on

plot(wt(1,:), wt(2,:), '.r-');
plot(wo(1), wo(2), 'ob')
hold off
colorbar
xlabel('w(1)');
ylabel('w(2)');
title('Error Surface and Adaptation process');

%% Calculate Jw during the train process

Jw = zeros(max_iter,1);

for k=1:max_iter
    wp = [wt(1,k); wt(2,k)];
    Jw(k) = var_v - 2*p'*wp + wp'*R*wp;
end

% Plot the Jw
figure(4);
semilogx(Jw)
xlabel('training step (logscale)');
ylabel('Jw');
title('Jw during the training process');

