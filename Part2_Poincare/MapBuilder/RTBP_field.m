
function dF = RTBP_field(t, F, mu)

% This function evaluates the CRTBP equations (in the synodic frame of
% reference) on a given point.
% F is a point in the form [x;y;x';y'] where (x,y) are the position and (x',y')
% are the linear velocities. Please note that the Z-axis is ignored here.

% We begin by "unpacking" the function argument F:
x = F(1);
y = F(2);
x_dot = F(3);
y_dot = F(4);

% Radius between the large primary and the planetoid:
r1 = ( (x-mu).^2 + y.^2).^(3/2);
r2 = ( (x-mu + 1).^2 + y.^2).^(3/2);




% Evaluate the acceleration (i.e. x'', y''):
x_ddot = x - (1-mu) * (x - mu) / r1 - mu * (x - mu + 1) / r2 + 2 * y_dot;
y_ddot = y - (1-mu) * y / r1 - mu * y / r2 - 2 * x_dot;



% Return the linear velocities and accelerations:
dF = [x_dot; y_dot; x_ddot; y_ddot];



end