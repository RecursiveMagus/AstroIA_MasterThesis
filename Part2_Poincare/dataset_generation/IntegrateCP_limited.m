% This program generates the dataset to train the regressor. It generates
% an equispaced grid of initial conditions (each one according to the energy
% constant h) and integrates until the first intersection with the poincare
% section defined by @orbitEvents.

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
grid_step_x = 1e-3;
grid_step_y = 1e-3;

% Array to store the intersection points with the Poincare Section:
PS = [];

% Generate the poincare map:
for x0 = -0.54:grid_step_x:-0.46

    % Display x0 to track progress:
    disp(x0);

    for y0 = -0.1:grid_step_y:0.1

        % We will always ignore x0 = 0 and x0 = -0.507, since it's a singularity
        if y0 == 0 && (x0 == 0 || x0 == -0.507)
            continue
        end
    
        % Calculate asociated initial velocity on y axis:
        y_dot_0 = -sqrt( 2 * h + x0*x0 + y0*y0 + 2 / sqrt(x0*x0 + y0*y0) - 2 * K * x0);
    
        % If the previous expresion does not yield a real number, we ignore it:
        if ~isreal(y_dot_0)
            continue
        end
    
        % Define the initial condition:
        F0 = [x0,y0,0,y_dot_0];
        Fi = F0;
    

    
        % Try to integrate 50 time ranges in order to find an intersection
        % (we will stop when an intersection is found)
        for i=1:50
    
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
                break;
            end
    
            % We save the final point as the new initial point, and begin
            % the next iteration:
            F0 = Ff;
        
        end
    
        
    end

end

dlmwrite('PS_train_limited.csv',PS,'delimiter',',','-append');

plot(PS(:,1), PS(:,2), '.');
hold on;
plot(PS(:,5), PS(:,6), '.');