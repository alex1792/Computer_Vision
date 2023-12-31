clear;
clc

load('TestData.mat');
load('TestLabel.mat');
load('TrainData.mat');
load('TrainLabel.mat');
%%======================================================
%% STEP 1a: Generate data from two 2D distributions.

% mu1 = [1 2];       % Mean
% sigma1 = [ 3 .2;   % Covariance matrix
%           .2  2];
% m1 = 200;          % Number of data points.
% 
% mu2 = [-1 -2];
% sigma2 = [2 0;
%           0 1];
% m2 = 100;
% 
% % Generate sample points with the specified means and covariance matrices.
% R1 = chol(sigma1);
% X1 = randn(m1, 2) * R1;
% X1 = X1 + repmat(mu1, size(X1, 1), 1);
% 
% R2 = chol(sigma2);
% X2 = randn(m2, 2) * R2;
% X2 = X2 + repmat(mu2, size(X2, 1), 1);
% 
% X = [X1; X2];

%%=====================================================
%% STEP 1b: Plot the data points and their pdfs.

% figure(1);
% 
% % Display a scatter plot of the two distributions.
% hold off;
% plot(X1(:, 1), X1(:, 2), 'bo');
% hold on;
% plot(X2(:, 1), X2(:, 2), 'ro');
% 
% set(gcf,'color','white') % White background for the figure.
% 
% % First, create a [10,000 x 2] matrix 'gridX' of coordinates representing
% % the input values over the grid.
% gridSize = 100;
% u = linspace(-6, 6, gridSize);
% [A B] = meshgrid(u, u);
% gridX = [A(:), B(:)];
% 
% % Calculate the Gaussian response for every value in the grid.
% z1 = gaussianND(gridX, mu1, sigma1);
% z2 = gaussianND(gridX, mu2, sigma2);
% 
% % Reshape the responses back into a 2D grid to be plotted with contour.
% Z1 = reshape(z1, gridSize, gridSize);
% Z2 = reshape(z2, gridSize, gridSize);
% 
% % Plot the contour lines to show the pdf over the data.
% [C, h] = contour(u, u, Z1);
% [C, h] = contour(u, u, Z2);
% 
% axis([-6 6 -6 6])
% title('Original Data and PDFs');

%set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2);


%%====================================================
%% STEP 2: Choose initial values for the parameters.

% Set 'm' to the number of data points.
X = PCA_Train_data';
% X = [];
% valiX = [];
% gt_mean = [];
% for i = 1:10
%     X = [X; tmp((i - 1) * 13 + 1:i * 13 - 3, :)];
%     valiX = [valiX; tmp(i * 13 - 2:i * 13, :)];
%     gt_mean = [gt_mean; mean(tmp((i - 1) * 13 + 1:i * 13, :))];
% end
% X = [X, zeros(130,1)];
% X = reshape(X, 2,[])';
% 
% figure(1);
% hold off;
% plot(X(1:1066, 1), X(1:1066, 2), 'bo');
% hold on;
% plot(X(1067:2132, 1), X(1067:2132, 2), 'ro');
% hold on;
% plot(X(2133:3198, 1), X(2133:3198, 2), 'go');
% hold on;
% plot(X(3199:4264, 1), X(3199:4264, 2), 'ko');
% title('Original Data');


m = size(X, 1);

k = 10;  % The number of clusters.
n = 163;  % The vector lengths.

% Randomly select k data points to serve as the initial means.
% indeces = randperm(m);
indeces = randperm(13);
mu = [];
for i = 1:10
%     indeces(i)
   mu = [mu; X((i - 1) * 13 + indeces(i),:)]; 
end
% mu = X(indeces(1:k), :);

sigma = [];

% Use the overal covariance of the dataset as the initial variance for each cluster.
for (j = 1 : k)
    sigma{j} = cov(X) + diag(rand(1, 163) * exp(-6));
end

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
        pdf(:, j) = gaussianND(X, mu(j, :), sigma{j}) + rand(130,1) * exp(-10);
    end
    
    % Multiply each pdf value by the prior probability for cluster.
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

    % Store the previous means.
    prevMu = mu;    
    
    % For each of the clusters...
    for (j = 1 : k)
    
        % Calculate the prior probability for cluster 'j'.
        phi(j) = mean(W(:, j), 1);
        
        % Calculate the new mean for cluster 'j' by taking the weighted
        % average of all data points.
        mu(j, :) = weightedAverage(W(:, j), X);

        % Calculate the covariance matrix for cluster 'j' by taking the 
        % weighted average of the covariance for each training example. 
        
        sigma_k = zeros(n, n);
        
        % Subtract the cluster mean from all data points.
        Xm = bsxfun(@minus, X, mu(j, :));
        
        % Calculate the contribution of each training example to the covariance matrix.
        for (i = 1 : m)
            sigma_k = sigma_k + (W(i, j) .* (Xm(i, :)' * Xm(i, :)));
        end
        
        % Divide by the sum of weights.
        sigma{j} = sigma_k ./ (sum(W(:, j))) + diag(rand(1, 163) * exp(-6));
    end
    
    % Check for convergence.
    if (mu == prevMu)
        break
    end
            
% End of Expectation Maximization    
end
%%=====================================================
%% STEP 4: validation
% for i = 1:10 
%     vali_pdf(:,i) = gaussianND(valiX, mu(i,:), sigma{i}) + rand(30, 1) * exp(-6);
% end
% vali_pdf_w = bsxfun(@times, vali_pdf, phi);
% W = bsxfun(@rdivide, vali_pdf_w, sum(vali_pdf_w, 2));
% [val, vloc] = max(W');
% vLOC = reshape(vloc, 10, 3);
% dist = [];
% for i = 1:10
%     for j = 1:10
%         dist = [dist; sum(abs(mu(i,:) - gt_mean(j,:)))];
%     end
% end
% DIST = reshape(dist, 10,10);

%%=====================================================
%% STEP 5: Predict
testX = PCA_Test_data';
for i = 1:10
   pdf(:,i) = gaussianND(X, mu(i,:), sigma{i}) + rand(130, 1) * exp(-6); 
end
pdf_w = bsxfun(@times, pdf, phi);
W = bsxfun(@rdivide, pdf_w, sum(pdf_w, 2));

[val, loc] = max(W');
LOC = reshape(loc, 10, 13);

correct = 0;
for i = 1:10
    correct = correct + sum(LOC(i,:) == i);
end
accuracy = correct / 130;
fprintf('accuracy: %f\n', accuracy);

%%=====================================================
%% STEP 5: Plot the data points and their estimated pdfs.

% Display a scatter plot of the two distributions.
% figure(2);
% hold off;
% plot(X(1:1066, 1), X(1:1066, 2), 'bo');
% hold on;
% plot(X(1067:2132, 1), X(1067:2132, 2), 'ro');
% hold on;
% plot(X(2133:3198, 1), X(2133:3198, 2), 'go');
% hold on;
% plot(X(3199:4264, 1), X(3199:4264, 2), 'ko');

% set(gcf,'color','white') % White background for the figure.

% plot(mu1(1), mu1(2), 'kx');
% plot(mu2(1), mu2(2), 'kx');

% First, create a [10,000 x 2] matrix 'gridX' of coordinates representing
% the input values over the grid.
% gridSize = 10000;
% u = linspace(-20000, 20000, gridSize);
% [A B] = meshgrid(u, u);
% gridX = [A(:), B(:)];

% Calculate the Gaussian response for every value in the grid.
% z1 = gaussianND(gridX, mu(1, :), sigma{1});
% z2 = gaussianND(gridX, mu(2, :), sigma{2});

% Reshape the responses back into a 2D grid to be plotted with contour.
% Z1 = reshape(z1, gridSize, gridSize);
% Z2 = reshape(z2, gridSize, gridSize);

% Plot the contour lines to show the pdf over the data.
% [C, h] = contour(u, u, Z1);
% [C, h] = contour(u, u, Z2);
% axis([-20000 20000 -20000 20000])
% 
% title('Original Data and Estimated PDFs');