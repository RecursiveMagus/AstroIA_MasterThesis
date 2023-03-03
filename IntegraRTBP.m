clear all;close all; clc
global mu;
% valor de mu
mu=1.215058565139771e-002;

% damos una condicion inicial 
Z0=[-0.8349319295908234D+00,0,0,-0.1685306061315002D-01];
Cj=jacobi(Z0,mu)

% tiempo final de integracion
tf=2.6924234169484906;
tRange=[0:0.001:tf];

options=odeset('AbsTol',1e-10,'RelTol',1e-10);
[t,Z]=ode45(@campo,tRange,Z0, options);
plot(Z(:,1),Z(:,2))


