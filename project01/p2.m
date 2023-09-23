clear

% section 2
% Produce the 3*3 Gaussian filter by 2-D Gaussian formula with 
% a) mu=0, sigma = 1 
% b) mu=0, sigma = 4.
gf1 = zeros(3:3);
gf2 = zeros(3:3);   
for i = -1:1:1
    for j = -1:1:1
        %   這邊分母需要變成根號2pi
%         gf1(i+2,j+2) = gaussian(i, 0, 1) * gaussian(j, 0, 1);
%         gf2(i+2,j+2) = gaussian(i, 0, 4) * gaussian(j, 0, 4);
        gf1(i+2, j+2) = gas(j,i,0,4);
        gf2(i+2, j+2) = gas(j,i,0,4);
    end
end
gf1
gf2

% gausian function
function gx = gaussian(x, mu, sigma)
    gx = (1 / (sqrt(2 * pi) * sigma)) * exp(- (x - mu).^2 / (2 * sigma.^2));
end


function gy = gas(x,y, mu, sigma)
    gy = 1 / (2 * pi * sigma * sigma) * exp(-(x * x + y * y) / (2 * sigma * sigma));
end