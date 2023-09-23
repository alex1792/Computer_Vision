clear

% section 3
% Implement the CONVOLUTION operation and apply the two masks 
% a) 3*3, mu=0, sigma = 1
% b) 7*7, mu=0, sigma = 1 
% to 柴犬飛飛.jpeg. Compare the results of a) and b) and draw your conclusion.
path = "resized.jpg";
img = imread(path);

f1 = zeros(3,3);
f2 = zeros(7,7);

for i = -1:1
    for j = -1:1
        f1(i+2, j+2) = gaussian(j, 0, 1) * gaussian(i, 0, 1);
    end
end
for i = -3:1:3
    for j = -3:1:3
        f2(i+4, j+4) = gaussian(j, 0, 1) * gaussian(i, 0, 1);
    end
end
f1
f2

r1 = uint8(conv2(f1, img(:,:,1)));
g1 = uint8(conv2(f1, img(:,:,2)));
b1 = uint8(conv2(f1, img(:,:,3)));
ret1 = cat(3, r1, g1, b1);

r2 = uint8(conv2(f2, img(:,:,1)));
g2 = uint8(conv2(f2, img(:,:,2)));
b2 = uint8(conv2(f2, img(:,:,3)));
ret2 = cat(3, r2, g2, b2);

figure
subplot(1,2,1), imshow(img), title('柴犬飛飛')
subplot(1,2,2), imshow(ret1), title('after 3*3 convolution')

figure
subplot(1,2,1), imshow(img), title('柴犬飛飛')
subplot(1,2,2), imshow(ret2), title('after 7*7 convolution')


% gausian function
function gx = gaussian(x, mu, sigma)
    gx = (1 / sqrt(2 * pi * sigma.^2)) * exp(- (x - mu).^2 / (2 * sigma.^2));
end