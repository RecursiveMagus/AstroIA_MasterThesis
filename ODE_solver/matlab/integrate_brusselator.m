clear all;
close all;
clc;

t = 0;
y = [1;0];

points = [y']

y0 = y;


while t < 3
 
    tspan = [t, t + 1e-4];

    [t_vec, y_vec] = ode78(@brusselator, tspan, y0);

    t = t_vec(end);
    y0 = y_vec(end,:);

    dlmwrite('brusselator_matlab_out.txt',y0, '-append');

    points = [points;y0];

    t

end

plot(points(:,1),points(:,2),'rx')