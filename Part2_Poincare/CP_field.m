function dF = CP_field(t, F, K)

x = F(1);
y = F(2);
px = F(3);
py = F(4);

r = x * x + y*y;

x_dot = px + y;
y_dot = py - x;
px_dot = py - x / (r.^3) - K;
py_dot = -px - y / (r.^3);

dF = [x_dot;y_dot;px_dot;py_dot];


end