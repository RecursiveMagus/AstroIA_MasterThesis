function dF = CP_field(t, F)

global K;

x = F(1);
y = F(2);
x_dot = F(3);
y_dot = F(4);

r = sqrt(x*x + y*y);

x_2dot = 2 * y_dot + x - x / (r.^3) - K;
y_2dot = -2 * x_dot + y - y / (r.^3);

dF = [x_dot;y_dot;x_2dot;y_2dot];


end