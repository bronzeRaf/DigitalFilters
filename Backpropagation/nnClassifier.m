% Author: 	Rafail Brouzos, mprouzo@auth.gr, rnm1816@gmail.com
% Purpose:	Neural Network Classifier workning on the Iris dataset
% 
% IMPORTANT NOTICE! The following script is using the clear command to 
% empty workspace. Please make sure you have a backup of your workspace 
% before running the script.


clear           % clear workspace

%% Create Dataset and Subsets

% Call the Iris dataset
[xx, yy] = iris_dataset;

% Size
len = length(xx);
len1 = floor(len/2);

%% Create the Dataset

% Prealocate Dataset
x = zeros(4,len);
y = zeros(3,len);

% Shuffle the Dataset randomly
indx = randperm(len);
for i = 1:3
    y(i,:) = yy(i,indx);
end
for i = 1:4
    x(i,:) = xx(i,indx);
end

% Create subsets
xdata = x(:,1:len1);
ydata = y(:,1:len1);
xtest = x(:,len1+1:end);
ytest = y(:,len1+1:end);

%% Preprocess the Dataset

% Normalize and zeromean data attributes
for q = 1:4
    xdata(q,:) = xdata(q,:)/(norm(xdata(q,:)));
    xdata(q,:) = xdata(q,:)-(mean(xdata(q,:)));
    xtest(q,:) = xtest(q,:)/(norm(xtest(q,:)));
    xtest(q,:) = xtest(q,:)-(mean(xtest(q,:)));
end

%% Train a Neural Network

% Parameters
iter = 1000;     % number of iterations
epsilon = 0.001; % error tolerance
b = 1;           % beta (in sign function)
lambda = 0.8;    % lamda (learning step)
layers = 3;      % number of layers
n1 = 4;          % number of imputs
n2 = 4;          % number of  neurons in layer 1
n3 = 3;          % number of  neurons in layer 2
n4 = 3;          % number of  neurons in layer 3

% Initialize and allocate memory
grad = 0;
J = zeros(iter,1);
dJ = zeros(n2,n1,layers,iter);
dJt = zeros(n2,n1,layers);
in = zeros(4,layers);
e = zeros(n4,1);
w = zeros(n2,n1,layers);
% Randomly initialize weights
w(:,:,1) = 0.000000001*randn(n2,n1);
w(1:n3,1:n2,2) = 0.00000001*randn(n3,n2);
w(1:n4,1:n3,3) = 0.00000001*randn(n4,n3);

% Start the clock
tic

% Training Loop
for j = 1:iter
    for i = 1:len1
        % Forward path
        
        
        in(:,1) = xdata(:,i);
        for k = 1:layers    % loop for the layers
            v = w(:,:,k)'*in(:,k);
            % Create u[k] for the next layer
            if k < layers
                % input of the next layer
                in(:,k+1) = 1./(1+exp(-b*v(:)));
            end
        end
        
        % Error
        e(:) = ydata(:,i) - in(1:n4,layers);
        
        % J
        Jt = e'*e;
        J(j) = J(j) + Jt;
        
        
        % Backward path
        
        
        % Derivative of the actuation funtion
        term = (1./(1+exp(-b*in(1:n4,layers)))).*(1-(1./(1+exp(-b*in(1:n4,layers)))));
        % Calculate generalized error of the layer
        delta(1:n4,3) = (ydata(:,i) - in(1:n4,layers)).*term;
        
        % Derivative of the actuation funtion
        term = (1./(1+exp(-b*in(1:n3,2)))).*(1-(1./(1+exp(-b*in(1:n3,2)))));
        % Calculate generalized error of the layer
        delta(1:n3,2) = term.*(w(1:n4,1:n3,3)'*delta(1:n4,3));
        
        % Derivative of the actuation funtion
        term = (1./(1+exp(-b*in(:,1)))).*(1-(1./(1+exp(-b*in(:,1)))));
        % Calculate generalized error of the layer
        delta(1:n2,1) = term.*(w(1:n3,1:n2,2)'*delta(1:n3,2));
        
        % Compute elements of the gradients
        % Layer 1
        dJt(1:n2,1:n1,1) = -delta(1:n2,1)*in(1:n1,1)';
        dJ(1:n2,1:n1,1,j) = dJ(1:n2,1:n1,1,j) + dJt(1:n2,1:n1,1);
        % Layer 2
        dJt(1:n3,1:n2,2) = -delta(1:n3,2)*in(1:n2,2)';
        dJ(1:n3,1:n2,2,j) = dJ(1:n3,1:n2,2,j) + dJt(1:n3,1:n2,2);
        % Layer 3
        dJt(1:n4,1:n3,3) = -delta(1:n4,3)*in(1:n3,3)';
        dJ(1:n4,1:n3,3,j) = dJ(1:n4,1:n3,3,j) + dJt(1:n4,1:n3,3);
        
        % Normalize and zero mean the gradient vectors;
        for q = 1:4
            % Layer 1
            dJ(:,q,1,j) = dJ(:,q,1,j)/(norm(dJ(:,q,1,j)));
            dJ(:,q,1,j) = dJ(:,q,1,j) - (mean(dJ(:,q,1,j)));
            % Layer 2
            if q <= n2
                dJ(1:n3,q,2,j) = dJ(1:n3,q,2,j)/(norm(dJ(1:n3,q,2,j)));
                dJ(1:n3,q,2,j) = dJ(1:n3,q,2,j) - (mean(dJ(1:n3,q,2,j)));

            end
            % Layer 3
            if q <= n4
                dJ(1:n4,q,3,j) = dJ(1:n4,q,3,j)/(norm(dJ(1:n4,q,3,j)));
                dJ(1:n4,q,3,j) = dJ(1:n4,q,3,j) - (mean(dJ(1:n4,q,3,j)));

            end
        end
        
    end
    
    % Update weights in the direction of the gradient
    w(:,:,1) = w(:,:,1) - lambda*dJ(:,:,1,j);
    w(1:n3,1:n2,2) = w(1:n3,1:n2,2) - lambda*dJ(1:n3,1:n2,2,j);
    w(1:n4,1:n3,3) = w(1:n4,1:n3,3) - lambda*dJ(1:n4,1:n3,3,j);
    
    % Stop the learning process if the error is small enough
    if J(j) < epsilon
        break;
    end
end
% Stop the clock
toc

%% Apply the filter

next = zeros(4,len);

% Predict Dataset classes
for i = 1:len1
    next(:,i) = xdata(:,i);
    for k = 1:layers
        f_next = w(:,:,k)'*next(:,i);
        next(:,i) = 1./(1+exp(-b*f_next(:)));
        
        if k == layers
            indx = find(next(1:3,i) == max(next(1:3,i)));
            next(:,i) = 0;
            next(indx(1),i) = 1;
        end
    end
end

% Evaluate Dataset predictions
false_class_data = 0;
for i = 1:len1
    miss_dataset = next(1:n4,i) ~= ydata(:,i);
    false_class_data = false_class_data + sum(miss_dataset)/2;
end
true_class_data = 75 - false_class_data;

% Predict Testset classes
for i = 1:len1
    next(:,i+len1) = xtest(:,i);
    for k = 1:layers
        f_next = w(:,:,k)'*next(:,i+len1);
        next(:,i+len1) = 1./(1+exp(-b*f_next(:)));
        
        if k == layers
            indx = find(next(:,i+len1) == max(next(1:3,i+len1)));
            next(:,i+len1) = 0;
            next(indx(1),i+len1) = 1;
        end
    end
end

% Evaluate Testset predictions
false_class_test = 0;
for i = len1+1:len
    mis_testset = next(1:n4,i) ~= ytest(:,i-len1);
    false_class_test = false_class_test + sum(mis_testset)/2;
    
end
true_class_data = 75 - false_class_test;



%% Plot Results

% Plot learning curve
figure; plot(J);
title('Learning curve');
ylabel('J')
xlabel('iteration')


% Show number missclassified records
false_class_data
false_class_test




