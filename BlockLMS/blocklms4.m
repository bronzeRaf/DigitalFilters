 function [e, w]=blocklms4(mu,M,u,d)
% FASTLMS, implemented without constraints
% Author : Rafail Brouzos, 7945, mprouzos@auth.gr
% Call:
% [e, w] = blocklms4(mu,M,u,d);
%
% Input arguments:
% mu = step size, dim 1x1
% M = filter length, dim 1x1
% u = input signal, dim Nx1
% d = desired signal, dim Nx1
%
% Output arguments:
% e = estimation error, dim Nx1
% w = final filter coefficients, dim Mx1
% 
% The length N is adjusted such that N/M is integer!

% Initialization
    W = zeros(M,1);
    N = length(u);
    e = zeros(size(d));
    
    % Number of blocks
    Blocks = N/M;
    
    % Loop for Blocks
    for k = 1:Blocks-1
    
        % Transformed input signal U(k)
        Uvec = fft(u(k*M+1:(k+1)*M),M);
    
        % Block k, output signal y(k)
        yvec = ifft(Uvec.*W);

        % Block k; desired signal
        dvec = d(k*M+1:(k+1)*M);
        % Block k, error signal, store error
        e(k*M+1:(k+1)*M,1) = dvec - yvec;
        
        % Transformation of estimation error
        Evec = fft(e(k*M+1:(k+1)*M),M);

        % Update of weights without constraints
        W = W + mu*Uvec.*Evec;
    end
    
    % The error vector should have only real values.
    e = real(e(:));
    
    % Transform of final weights to time domain.
    w = ifft(W);
    % Keep the real values
    w = real(w);

 end