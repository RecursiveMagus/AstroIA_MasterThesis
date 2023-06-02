clear all;
close all; 
clc;

%Set global random seed:
rng(42);

% Define the system constants:
global K;
K = 0.0015749; 
h = -1.7; % Energy level

% Integration constants, options and Poincare Section:
TF=10;
tRange = [0:0.001:TF];
options = odeset('AbsTol',1e-12,'RelTol',1e-12, 'Events', @orbitEvents);

% Array to store the intersection points with the Poincare Section:
PS = [];


% Generate the poincare map:
for x0 = -0.63:0.01:-0.36

    % We will always ignore x0 = 0, since it's a singularity
    if x0 == 0
        continue
    end

    % Display x0 to track progress:
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

    % Initialize an empty array. We will store each intersection here.
    PS = [];

    % Try to find 5000 intersections with the defined Poincare Section:
    for i=1:5000

        % Integrate the system @CP_field and save the last point: 
        [t, F] = ode78(@CP_field, tRange, F0, options);
        Ff = F(end,:);
        
        % Recall that ode78 will stop integrating if one of two things
        % happen:
        % 1- We reach max time, as specified by the last value of tRange.
        % 2- There is an intersection with the poincare section (and the
        % @orbitEvents function, specified in 'options', returns true).
        % Therefore, we should check if Ff (the last point calculated by 
        % the integrator) is actually an intersection with the Poincare
        % Section: 
        if   Ff(4) < 0 && abs(Ff(3)) < 1e-10
            PS = [PS; Fi, Ff];
            Fi = Ff;
        end

        % We save the final point as the new initial point, and begin
        % the next iteration:
        F0 = Ff;
    
    end

    dlmwrite('PS_train_equidistant.csv',PS,'delimiter',',','-append');

end
