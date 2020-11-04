function [y] = jointProcessFilter(u, k, gamma)
% function [y] = jointProcessFilter(u, k, gamma)
% Joint process estimation using lattice filters
% input:
% u: input signal
% k: reflection coefficients
% output: 
% y: filtered signal

n = length(u);
y = zeros(n, 1);
M = length(k);

f = zeros(M+1,1);
b = zeros(M+1,1);
bo = zeros(M+1,1);
for i=1:n
    f(1) = u(i);
    b(1) = u(i);
    
    %lattice filter
    for m=2:M+1
        f(m) = f(m-1) + k(m-1) * bo(m-1);
        b(m) = k(m-1) * f(m-1) + bo(m-1);
    end
    bo = b;
    
    % regression filter 
    y(i) = gamma' * b;
end

end