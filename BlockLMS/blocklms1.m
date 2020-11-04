function [e, w] = blocklms1(mu,M,u,d)
% BLOCKLMS, implemented with 2 nested loops
% Author : Rafail Brouzos, 7945, mprouzos@auth.gr
% Call:
% [e, w] = blocklms1(mu,M,u,d);
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


%Initialization
    w = zeros(M,1);
    N = length(u);
    e = zeros(size(d));
    
    % Number of blocks
    Blocks = N/M;
    %Loop for Blocks
    for k = 1:Blocks-1
        phi = 0;
        % Loop for the points in the Block
        for i = 1:M
            ycur = 0;
            % Sum loop
            for j = 0:M-1
                % Calculate output signal
                ycur = ycur + u(k*M+i-j)*w(j+1);
            end
            % Calculate error
            ecur = d(k*M+i) - ycur;
            % Store error
            e(k*M+i) = ecur;
            % Calculate gradient estimate
            phi = phi + mu*u(k*M+i)*ecur;
        end
        % Update filter coefficients
        w = w + phi;

    end

end