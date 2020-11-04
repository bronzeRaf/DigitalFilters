% Author : Rafail Brouzos, 7945, mprouzos@auth.gr
% 
% This script confirms the convolution theory. Calculates the convolution
% of two random signals with 4 different implementations, storing the error
% and the run time each time.
% 
% Uses the "fastMul" function. This means that you need the "fastMul.m" to
% be stored in the same directory with the current script.


% Get a clean workspace
clear
close all

%% Set the parameters
n = 500;
m = 500;

% Check dimensions
if n < m
    temp = n;
    n = m;
    m = temp;
end

y = randn(1,n);
x = randn(1,m);

% Apply zero padding 
xZ = [x zeros(1, n-1)];
yZ = [y zeros(1, m-1)];

%% 1st convolution

tic;                                % start clock
t = cputime;

    c1 = conv(x,y);
    
tBcpu1 = cputime-t;
tB1 = toc;                          % stop clock

%% 2nd convolution 
tic;                                % start clock
t = cputime;

    yT = toeplitz(yZ);
    c2 = (yT*xZ')';
    
tBcpu2 = cputime-t;
tB2 = toc;                          % stop clock
% Error
e2 = norm( c2 - c1 )/norm(c1);


%% 3rd convolution 
tic;                                % start clock
t = cputime;

    % Create circulant
    C = zeros(m+n-1,m+n-1);
    C(:,1) = xZ(:);
    for i = 2:n
        C(i:end,i) = xZ(1:end-i+1);
        C(1:i-1,i) = xZ(end-i+2:end);
    end
    % Make the multiplication
%     c3 = (C*yZ')';                    % exact
    c3 = fastMul(C(:,1),C(1,:),yZ')';   % approximately
    
tBcpu3 = cputime-t;
tB3 = toc;                          % stop clock
% Error
e3 = norm( c3 - c1 )/norm(c1);


%% 4th convolution 
tic;                                % start clock
t = cputime;

    % Multiply into fourrier domain and invert back to time domain
    c4 = ifft(fft(xZ).*fft(yZ));
    
tBcpu4 = cputime-t;
tb4 = toc;                          % stop clock
% Error
e4 = norm( c4 - c1 )/norm(c1);


%% Plot
% 
% plot(c1)
% hold on; plot(c2)
% hold on; plot(c3)
% hold on; plot(c4)
% title('Convolution x*y')
% xlabel('timestep')
% ylabel('Conv')