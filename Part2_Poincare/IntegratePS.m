clear all;
close all; 
clc;

% Value of parameter mu
mu = 1.215058565139771e-002;

% Initial condition and value of Jacobi constant
%F0 = [-0.8349319295908234D+00,0,0,-0.1685306061315002D-01]; % Perfect circle
F0 = [1,0,-1,3];
%F0 = [7 * mu / 12 + 0.1,0,0,0]; %Very close to L3. Should not move very far.

% Time interval to integrate:
tf = 3;%2.6924234169484906; 
tRange=[0:0.001:tf];

% Set integrator options:
options = odeset('AbsTol',1e-10,'RelTol',1e-10, 'Events',@event_PS);

% Call the integrator
[t,F] = ode78(@(t,F) RTBP_field(t,F,mu),tRange,F0, options);

% Plot the results:
plot(F(:,1),F(:,2))
