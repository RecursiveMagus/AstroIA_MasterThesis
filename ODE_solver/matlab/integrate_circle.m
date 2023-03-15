clear all;
close all;
clc;

t = 0;
y = [1;0];

points = [y']

y0 = y;

H = 1e-4;


while t < 5*2*pi

    tspan = [t, t + H];

    [t_vec, y_vec] = ode78(@circle, tspan, y0);

    t = t_vec(end);
    y0 = y_vec(end,:);

    dlmwrite('circle_matlab_out.txt',y0, '-append');

    points = [points;y0];

    disp(t);


end

plot(points(:,1),points(:,2),'rx')