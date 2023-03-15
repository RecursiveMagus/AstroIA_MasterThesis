function [y_out] = brusselator(t,y)
%BRUSSELATOR Summary of this function goes here
%   Detailed explanation goes here
A = 1;
B = 2.5;

d_x = A + y(1)*y(1)*y(2) - B * y(1) - y(1);
d_y = B * y(1) - y(1) * y(1) * y(2);

y_out = [d_x;d_y];

end

