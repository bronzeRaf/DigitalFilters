 function [e, w] = blocklms3(mu,M,u,d)
% FASTLMS
% Author : Rafail Brouzos, 7945, mprouzos@auth.gr
% Call:
% [e, w] = blocklms3(mu,M,u,d);
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
    W = zeros(2*M,1);
    N = length(u);
    e = zeros(size(d));
    
    % Number of blocks
    Blocks = N/M;
    
    % Loop for Blocks
    for k = 1:Blocks-1
    
        % Block k-1, k; transformed input signal U(k)
        Uvec = fft(u((k-1)*M+1:(k+1)*M),2*M);
    
        % Block k, output signal y(k), last M elements
        yvec = ifft(Uvec.*W);
        yvec = yvec(M+1:2*M,1);
        
        % Block k; desired signal
        dvec = d(k*M+1:(k+1)*M);
        % Block k, error signal, store error
        e(k*M+1:(k+1)*M,1) = dvec - yvec;
        
        % Transformation of estimation error
        Evec = fft([zeros(M,1);e(k*M+1:(k+1)*M)],2*M);
        
        % Estimated gradient (Eq.10.39)
        phivec = ifft(conj(Uvec).*Evec,2*M);
        phivec = phivec(1:M);

        % update of weights
        W = W + mu*fft([phivec;zeros(M,1)],2*M);
    end
    
    % The error vector should have only real values.
    e = real(e(:));
    
    % Transform of final weights to time domain.
    w = ifft(W);
    % Keep the real values
    w = real(w(1:length(W)/2));

 end