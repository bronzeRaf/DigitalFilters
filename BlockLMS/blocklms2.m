function [e, w] = blocklms2(mu,M,u,d)
% BLOCKLMS, implemented with 1 loop and matrix expressions
% Author : Rafail Brouzos, 7945, mprouzos@auth.gr
% Call:
% [e, w] = blocklms2(mu,M,u,d);
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


%initialization
    w = zeros(M,1);
    N = length(u);
    e = zeros(size(d));
    
    % Number of blocks
    Blocks = N/M;
    %Loop for Blocks
    for k = 1:Blocks-1
        % Uncomment section 1 to calculate the exact yvec (comment out 2)
        % 1) Set up input signal matrix, dim. MxM
        umat = toeplitz(u(k*M:1:(k+1)*M-1),u(k*M:-1:(k-1)*M+1));
        % Calculate output signal of the block exactly
        yvec = umat*w;
        % 2) Use the approximation to reduse run time!
%         yvec = fastMul(u(k*M:1:(k+1)*M-1),u(k*M:-1:(k-1)*M+1),w);
        
        % Set up vector with desired signal of the block
        dvec = d(k*M:1:(k+1)*M-1);
        %calculate error vector of the block
        evec = dvec - yvec;
        % Store error
        e(k*M:1:(k+1)*M-1) = evec;
        % Calculate gradient estimate
        phi = evec'*u(k*M:1:(k+1)*M-1);
        % Update filter coefficients
        w = w + mu*phi;

    end

end