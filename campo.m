
function dZdt= campo(t,Z)
global mu;
       
x1 = Z(1);
x2 = Z(2);
x3 = Z(3);
x4 = Z(4);

r13=((mu - x1).^2 + x2.^2).^(3/2);
r23 = ((x1 - mu +1).^2 + x2.^2)^(3/2);

% ecuaciones del RTBP
dxdt = x3;
dydt = x4;
d2xdt = x1 - (1-mu)*(x1-mu)/r13 - mu *(x1-mu+1)/r23 + 2*x4;
d2ydt = x2 *(1-(1-mu)/r13 - mu/r23) - 2*x3;

dZdt = [dxdt;dydt;d2xdt;d2ydt];
end
 