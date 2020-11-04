function yf = fastMul(a,b,v)
% Toeplitz matrix with vector multiplication in O(N*log(N)) complexity
% Author : Rafail Brouzos, 7945, mprouzos@auth.gr
% 
% Call: yf = fastMul(a,b,v);
%
% Input arguments:
% a = 1st column of the Toeplitz matrix, dim Nx1
% b = 1st row of the Toeplitz matrix, dim Nx1
% v = vector, dim Nx1
% 
% Output arguments:
% yf = result of the multiplication

    % Ensure a is a column vector
    [m,n] = size(a);
    if (n>m)
        a = a.';
    end
    % Ensure b is a row vector
    [m,n] = size(b);
    if (m>n)
        b=b.';
    end
    
    
    % Make the multiplication
    n = length(a);
    c = [a; 0; fliplr(b(2:end)).'];
    p = ifft(fft(c).*fft([v; zeros(n,1)]));
    % Store result
    yf = p(1:n);
    % Keep the real values
    yf = real(yf);

end