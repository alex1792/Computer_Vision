clear

% section 1 
% Plot the 1-D Gaussian curve for x = -1000 to 1000 with step 
% size=1 (-1000, -999, -998,¡K,998, 999, 1000) and the following 
% mu and sigma:
% a) mu=0, sigma = 5
% b) mu=0, sigma = 150

x1 = linspace(-1000,1000, 2001);
y1 = gaussian(x1, 0, 5);
y2 = gaussian(x1, 0, 150);
% plot(x1, y1)
% plot(x1, y2)

% gausian function
function gx = gaussian(x, mu, sigma)
    gx = (1 / sqrt(2 * pi * sigma.^2)) * exp(- (x - mu).^2 / (2 * sigma.^2));
end



