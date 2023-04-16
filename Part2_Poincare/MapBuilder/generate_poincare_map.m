clear all;
close all; 
clc;

% Value of parameter mu:
mu = 1.215058565139771e-002;
initial_points = []; %F0'
final_points = [];


x = 0;
x_dot = 0;
Cj = 3.15;

n = 100;

xi = -5;%-0.838;
xf= -2;%-0.832;
hx=(xf-xi)/n;

x_doti = 0.5;
x_dotf = 1.25;
h_xdot = (x_dotf-x_doti) / n;


for x = xi:hx:xf
    for x_dot = x_doti:h_xdot:x_dotf
        % Find y', according to the current x, x' and Cj (and taking into
        % account y = 0.
        r1 = (x-mu);
        r2 = (x-mu+1);
        omega = 0.5*x*x + (1-mu)/r1 + mu/r2 + 0.5*mu*(1-mu);
        y_dot = 0;%sqrt(2*omega - x_dot^2 -Cj);

        

        F0 = [x;0;x_dot; y_dot];
        initial_points = [initial_points; F0'];

        F = IntegrateUntilSection(F0, mu);
        final_points = [final_points; F];
    end
end


plot(final_points(:,1), final_points(:,3), '.');