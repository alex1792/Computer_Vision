

% $Author: ChrisMcCormick $    $Date: 2014/05/19 22:00:00 $    $Revision: 1.3 $



%%======================================================
clear;
clc;
%%======================================================
%% Load data
load('TrainData.mat');
load('TrainLabel.mat');
load('TestData.mat');
load('TestLabel.mat');

%%======================================================
%% STEP 1a: Generate data from two 1D distributions.

% mu1 = 10;      % Mean
% sigma1 = 1;    % Sigma
% m1 = 100;      % Number of points
% 
% mu2 = 20;
% sigma2 = 3;
% m2 = 200;
% 
% % Generate the data.
% X1 = (randn(m1, 1) * sigma1) + mu1;
% X2 = (randn(m2, 1) * sigma2) + mu2;
% 
% X = [X1; X2];

tmp = PCA_Train_data;
X = tmp(:);
m = [];
sigma = [];
for i = 1:10
   m{i} = sum(X((i - 1) * 163 * 13 + 1:i * 163 * 13)) / (163 * 13); 
   sigma{i} = std(X((i - 1) * 163 * 13 + 1:i * 163 * 13));
end

X1 = X(1:163 * 13);
X2 = X(163 * 13 + 1:163 * 13 * 2);
X3 = X(163 * 13 * 2 + 1:163 * 13 * 3);
X4 = X(163 * 13 * 3 + 1:163 * 13 * 4);
X5 = X(163 * 13 * 4 + 1:163 * 13 * 5);
X6 = X(163 * 13 * 5 + 1:163 * 13 * 6);
X7 = X(163 * 13 * 6 + 1:163 * 13 * 7);
X8 = X(163 * 13 * 7 + 1:163 * 13 * 8);
X9 = X(163 * 13 * 8 + 1:163 * 13 * 9);
X10 = X(163 * 13 * 9 + 1:163 * 13 * 10);

%%=====================================================
%% STEP 1b: Plot the data points and their pdfs.
s1 = sigma{1};
x = [-16400:1:17560];
y1 = gaussian1D(x, m{1}, sigma{1});
y2 = gaussian1D(x, m{2}, sigma{2});
y3 = gaussian1D(x, m{3}, sigma{3});
y4 = gaussian1D(x, m{4}, sigma{4});
y5 = gaussian1D(x, m{5}, sigma{5});
y6 = gaussian1D(x, m{6}, sigma{6});
y7 = gaussian1D(x, m{7}, sigma{7});
y8 = gaussian1D(x, m{8}, sigma{8});
y9 = gaussian1D(x, m{9}, sigma{9});
y10 = gaussian1D(x, m{10}, sigma{10});

figure(1)
hold off;
plot(x, y1, 'b-');
hold on;
plot(x, y2, 'r-');
hold on;
plot(x, y3, 'b-');
hold on;
plot(x, y4, 'r-');
hold on;
plot(x, y5, 'b-');
hold on;
plot(x, y6, 'r-');
hold on;
plot(x, y7, 'b-');
hold on;
plot(x, y8, 'r-');
hold on;
plot(x, y9, 'b-');
hold on;
plot(x, y10, 'r-');

plot(X1, zeros(size(X1)), 'bx', 'markersize', 10);
plot(X2, zeros(size(X2)), 'rx', 'markersize', 10);
plot(X3, zeros(size(X3)), 'kx', 'markersize', 10);
plot(X4, zeros(size(X4)), 'gx', 'markersize', 10);
plot(X5, zeros(size(X5)), 'yx', 'markersize', 10);
plot(X6, zeros(size(X6)), 'bx', 'markersize', 10);
plot(X7, zeros(size(X7)), 'rx', 'markersize', 10);
plot(X8, zeros(size(X8)), 'kx', 'markersize', 10);
plot(X9, zeros(size(X9)), 'gx', 'markersize', 10);
plot(X10, zeros(size(X10)), 'yx', 'markersize', 10);

set(gcf,'color','white') % White background for the figure.
title('將資料看成1維');

%%====================================================
%% STEP 2: Choose initial values for the parameters.

% Set 'm' to the number of data points.
tmp = PCA_Test_data;
testX = tmp(:);
m = size(testX, 1);

% Set 'k' to the number of clusters to find.
k = 10;

% Randomly select k data points to serve as the means.
indeces = randperm(m);
mu = zeros(1, k);
for (i = 1 : k)
    mu(i) = X(indeces(i));
end

% Use the overal variance of the dataset as the initial variance for each cluster.
sigma = ones(1, k) * sqrt(var(X));

% Assign equal prior probabilities to each cluster.
phi = ones(1, k) * (1 / k);

%%===================================================
%% STEP 3: Run Expectation Maximization

% Matrix to hold the probability that each data point belongs to each cluster.
% One row per data point, one column per cluster.
W = zeros(m, k);

% Loop until convergence.
for (iter = 1:1000)
    
    fprintf('  EM Iteration %d\n', iter);

    %%===============================================
    %% STEP 3a: Expectation
    %
    % Calculate the probability for each data point for each distribution.
    
    % Matrix to hold the pdf value for each every data point for every cluster.
    % One row per data point, one column per cluster.
    pdf = zeros(m, k);
    
    % For each cluster...
    for (j = 1 : k)
        
        % Evaluate the Gaussian for all data points for cluster 'j'.
        pdf(:, j) = gaussian1D(X, mu(j), sigma(j));
    end
    
    % Multiply each pdf value by the prior probability for each cluster.
    %    pdf  [m  x  k]
    %    phi  [1  x  k]   
    %  pdf_w  [m  x  k]
    pdf_w = bsxfun(@times, pdf, phi);
    
    % Divide the weighted probabilities by the sum of weighted probabilities for each cluster.
    %   sum(pdf_w, 2) -- sum over the clusters.
    W = bsxfun(@rdivide, pdf_w, sum(pdf_w, 2));
    
    %%===============================================
    %% STEP 3b: Maximization
    %%
    %% Calculate the probability for each data point for each distribution.

    % Store the previous means so we can check for convergence.
    prevMu = mu;    
    
    % For each of the clusters...
    for (j = 1 : k)
    
        % Calculate the prior probability for cluster 'j'.
        phi(j) = mean(W(:, j));
        
        % Calculate the new mean for cluster 'j' by taking the weighted
        % average of *all* data points.
        mu(j) = weightedAverage(W(:, j), X);
    
        % Calculate the variance for cluster 'j' by taking the weighted
        % average of the squared differences from the mean for all data
        % points.
        variance = weightedAverage(W(:, j), (X - mu(j)).^2);
        
        % Calculate sigma by taking the square root of the variance.
        sigma(j) = sqrt(variance);
    end
    
    % Check for convergence.
    % Comparing floating point values for equality is generally a bad idea, but
    % it seems to be working fine.
    if (mu == prevMu)
        break
    end

% End of Expectation Maximization loop.    
end
%%=====================================================
%% STEP 4: Predict.
testX = PCA_Test_data';
testX = testX(:);

predict = zeros(m, k);

%   for each cluster
for i = 1:10
    %   compute the pdf of each pixel
   predict(:,i) = gaussian1D(testX, mu(i), sigma(i));
end

%   find the highest probability
[val, loc] = max(predict');
LOC = reshape(loc, 163, 130)';

%   summarize each image with highest corresponding probability
answer = zeros(130, 10);
for i = 1:130
    for j = 1:10
        [row, column] = size(find(LOC(i,:) == j));
        answer(i,j) = column;
    end
end
[val, loc] = max(answer');
tmp = reshape(loc, 13, 10)';

%   compute accuracy
correct = 0;
for i = 1:10
    correct = correct + sum(tmp(i,:) == i);
end
fprintf('accuracy: %f\n', correct / 130);

%%=====================================================
%% STEP 5: Plot the data points and their estimated pdfs.

x = [-16400:1:17560];
% tmp = PCA_Test_data;
% x = tmp(:);
y1 = gaussian1D(x, mu(1), sigma(1));
y2 = gaussian1D(x, mu(2), sigma(2));
y3 = gaussian1D(x, mu(3), sigma(3));
y4 = gaussian1D(x, mu(4), sigma(4));
y5 = gaussian1D(x, mu(5), sigma(5));
y6 = gaussian1D(x, mu(6), sigma(6));
y7 = gaussian1D(x, mu(7), sigma(7));
y8 = gaussian1D(x, mu(8), sigma(8));
y9 = gaussian1D(x, mu(9), sigma(9));
y10 = gaussian1D(x, mu(10), sigma(10));


% Plot over the existing figure, using black lines for the estimated pdfs.
figure(2)
hold on;
plot(x, y1, 'r-', 'markersize', 20);
plot(x, y2, 'g-', 'markersize', 20);
plot(x, y3, 'b-', 'markersize', 8);
plot(x, y4, 'k-', 'markersize', 7);
plot(x, y5, 'r:', 'markersize', 6);
plot(x, y6, 'g:', 'markersize', 5);
plot(x, y7, 'b:', 'markersize', 4);
plot(x, y8, 'k:', 'markersize', 3);
plot(x, y9, 'r*', 'markersize', 2);
plot(x, y10, 'g*', 'markersize', 1);
title('結果');
