clear all;
close all; 
clc;


K = -1;


F0 = [1,1,-1,0];
PS = [];

n=10;

Xi =-0.838;
Xf =-0.832;
hx =(Xf-Xi)/n;

Yi =

% Time interval to integrate:
tf = 10;
tRange=[0:0.001:tf];

% Generate a grid
for i = 0:10
    X0=Xi+i*hx;
    for j = 0:10
          % initial x0
        Z0=[X0,0,0,0]; % initial point to compute dy0
    end
end




%[t,F] = ode78(@(t,F) CP_field(t,F,K),tRange,F0, odeset('AbsTol',1e-10,'RelTol',1e-10, 'Events',@event_PS));
%PS=[PS;F(end,:)];
%F0 = F(end,:);


% Plot the results:
%plot(PS(:,1:2),PS(:, 1:2), '*')

