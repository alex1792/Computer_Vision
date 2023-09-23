clear;
clc

%  read 3D and 2D coordinates
file = fopen("pt2d.txt", "r");
file2 = fopen("pt3d.txt", "r");
[a b] = fscanf(file, "%f");
[c d] = fscanf(file2, "%f");
two_x = zeros(b / 2, 1, 1);
two_y = zeros(b / 2, 1, 1);
three_x = zeros(d/3, 1, 1);
three_y = zeros(d/3, 1, 1);
three_z = zeros(d/3, 1, 1);
for i = 1:b
   if(mod(i,2) == 0)
       two_y(i / 2,1) = a(i,1);
   else
       two_x((i + 1) / 2, 1) = a(i, 1);
   end
end

for i = 1:d
   if(mod(i,3) == 1)
       three_x((i+2)/3, 1) = c(i,1);
   elseif(mod(i,3) == 2)
       three_y((i + 1) / 3, 1) = c(i, 1);
   else
       three_z(i/3, 1) = c(i, 1);
   end
end

% fill coordinates into A matrix
A = zeros(b,12,1);
for i = 1:b/2
    A(2 * i - 1, 1:4) = [three_x(i, 1) three_y(i, 1) three_z(i, 1) 1];
    A(2 * i - 1, 9:12) = (-1) * two_x(i, 1) * [  three_x(i, 1) three_y(i, 1) three_z(i, 1) 1];
    A(2 * i, 5:8) = [three_x(i, 1) three_y(i, 1) three_z(i, 1) 1];
    A(2 * i, 9:12) = (-1) * two_y(i, 1) * [  three_x(i, 1) three_y(i, 1) three_z(i, 1) 1];
end

% compute A' * A¡Beigenvalues¡Beigenvectors
ATA = A' * A;
[V, D] = eig(ATA);
[d, ind] = sort(diag(D));
Ds = D(ind, ind);
Vs = V(:,ind);
P = Vs(:,1);
P = reshape(P,[],3)';

% compute calibration(K)¡Btranslation(T)¡Brotation matrix(R) using QR decomposition
M = P(:,1:3);
P4 = P(:,4);
[Q, R] = qr(M);
K = inv(R)
R = inv(Q)
T = inv(K) * P4


% compute 2D coordinates using the projection matrix P
test_xyz1 = zeros(4, 298, 1);
test_xyz1(1,:) = three_x(:,1);
test_xyz1(2,:) = three_y(:,1);
test_xyz1(3,:) = three_z(:,1);
test_xyz1(4,:) = 1;
px = P * test_xyz1;
px(1:2,:) = px(1:2,:) ./ px(3,:);   %   make the thrid dimension become 1
px(3,:) = px(3,:) / px(3,:);        %   make the third dimension become 1

% compute projection error
xnorm = two_x - px(1,:)';
ynorm = two_y - px(2,:)';
xnorm = xnorm .* xnorm;
ynorm = ynorm .* ynorm;
x_pj_error = sqrt(sum(xnorm)) / 298
y_pj_error = sqrt(sum(ynorm)) / 298
