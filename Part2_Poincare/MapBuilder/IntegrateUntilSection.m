function Ff = IntegrateUntilSection(Fi, mu)
%------------------------------
% Given an initial condition Fi = [x;y;x';y'], this function integrates
% this initial condition until it reaches the predefined poincare section
% 
%------------------------------

options = odeset('AbsTol',1e-10,'RelTol',1e-10, 'Events',@(t, F) event_PS(t, F, mu));

tRange=[0:100];

[t,F] = ode78(@(t,F) RTBP_field(t,F,mu),tRange,Fi, options);

Ff = F(end,:);


end