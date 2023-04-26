clear all;
close all; 
clc;

% Define the system constants:
global K;
K = 0.0015749; 
h = -1.7; % Energy level

% Integration constants, options and Poincare Section:
TF=100;
tRange = [0:0.001:TF];
options = odeset('AbsTol',1e-12,'RelTol',1e-12, 'Events', @orbitEvents);

% Array to store the intersection points with the Poincare Section:
PS = [];




for x0 = -0.63:0.001:-0.35

    % We will always ignore x0 = 0, since it's a singularity
    if x0 == 0
        continue
    end

    disp(x0);

    % Calculate asociated initial velocity on y axis:
    y_dot_0 = -sqrt( 2 * h + x0*x0 + 2 / abs(x0) - 2 * K * x0);

    % If the previous expresion does not yield a real number, we ignore it:
    if ~isreal(y_dot_0)
        continue
    end

    % Define the initial condition:
    F0 = [x0,0,0,y_dot_0];
    Fi = F0;

    % Try to find 100 intersections with the defined Poincare Section:
    for i=1:2000
        
        [t, F] = ode45(@CP_field, tRange, F0, options);
    
        Ff = F(end,:);
        if   Ff(4) < 0 && abs(Ff(3)) < 1e-10
            PS = [PS; Fi, Ff];
            Fi = Ff;
        end
        F0 = Ff;
    
    end
end

writematrix(PS,'PS.csv') 

plot(PS(:,5), PS(:,6), '.','MarkerSize',0.5);
