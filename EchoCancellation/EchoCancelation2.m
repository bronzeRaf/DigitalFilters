% Author: 	Rafail Brouzos, mprouzo@auth.gr, rnm1816@gmail.com
% Purpose:	Digital Wiener filter for removing the echo of a signal.
% 		Comparison of LMS, normalized LMS and RLS algorithms with the 
%       exact Wiener one.
% 
% IMPORTANT NOTICE 1! The following script is using the clear command to empty workspace. Please 
% make sure you have a backup of your workspace before running the script.
% IMPORTANT NOTICE 2! The following script requires too many computational
% resources if you ucomment the LMS, normalize LMS and RLS sections. Please
% consider the case of an Matlab crash.

clear           % clear workspace

%% Input signal

load('speakerA.mat');
load('speakerB.mat');


%% Parameters
var_v1 = 0.42;      % variance of white noise u1
var_v2 = 0.72;      % variance of white noise u2
n = length(d);      % signal length
m = 6600;           % number of coefficients
mu_lms = 0.49e-07;  % step length of the LMS algorithm
mu_n_lms = 0.49e-07;% step length of the normalized LMS algorithm 


% Initialize some memory
y = zeros(n,1);

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
% mu_domain = [0 2/max(abs(eig(R)))];

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


% The following section requires too many computanional resources!
% Uncoment only if you are ready to wait a couple of hours!

%% LMS adaptive Filter
%                             tic;            % start the clock
% % initialize
% w_lms = zeros(m, 1);
% y_lms = zeros(n, 1);
% e_lms = zeros(n, 1);
% J_lms = zeros(n, 1);
% 
% for i=(m+1):n
%     y_lms(i) = w_lms'*u(i:-1:(i-m+1));
%     e_lms(i) = d(i) - y_lms(i);
%     w_lms = w_lms + mu_lms*e_lms(i)*u(i:-1:(i-m+1));
%     J_lms(i) = e_lms(i)^2;
% end
%                             Tlms = toc;  % stop the clock
% % Apply the filter
% for i = m:n
%   y(i) = u(i:-1:i-m+1)' * w_lms; % filter
% end
% % Remove the noise
% e_lms = d - y;
% 
% %% Normalized LMS adaptive Filter
%                             tic;            % start the clock
% w_n_lms = zeros(m, 1);
% y_n_lms = zeros(n, 1);
% e_n_lms = zeros(n, 1);
% J_n_lms = zeros(n, 1);
% a = 0.001;
% 
% for i=(m+1):n
%     y_n_lms(i) = w_n_lms'*u(i:-1:(i-m+1));
%     e_n_lms(i) = d(i) - y_n_lms(i);
%     normu = (sum(u(i:-1:(i-m+1))))^2;
%     w_n_lms = w_n_lms + (mu_n_lms*e_n_lms(i)*u(i:-1:(i-m+1)))/(a+normu);
%     J_n_lms(i) = e_n_lms(i)^2;
% end
% 
%                             Tnlms = toc;  % stop the clock
% % Apply the filter
% for i = m:n
%   y(i) = u(i:-1:i-m+1)' * w_n_lms; % filter
% end
% % Remove the noise
% e_n_lms = d - y;

%% RLS adaptive Filter
% 
%                             tic;            % start the clock
% lambda = 1;
% delta = 1/1000*var(u);
% 
% % initialize
% w_rls = zeros(m, 1);
% y_rls = zeros(n, 1);
% e_rls = zeros(n, 1);
% J_rls = zeros(n, 1);
% P = (1/delta) * eye(m, m);
% 
% for i = (m+1):n
%         y_rls(i) =   w_rls(:)' * u(i:-1:i-m+1);
%         k = ( (lambda^-1)*P*u(i:-1:i-m+1) / (1 + (lambda^-1)*u(i:-1:i-m+1)'*P*u(i:-1:(i-m+1))) );
%         e_rls(i) = d(i) - y_rls(i);
%         w_rls(:) = w_rls(:) + k * e_rls(i);
%         P = (lambda^-1)*P - (lambda^-1)*k*u(i:-1:(i-m+1))'*P;
%         J_rls(i) = e_rls(i)^2;
% end
%                             Trls = toc;  % stop the clock
% 
% % Apply the filter
% for i = m:n
%   y(i) = u(i:-1:i-m+1)' * w_rls; % filter
% end
% % Remove the noise
% e_rls = d - y;