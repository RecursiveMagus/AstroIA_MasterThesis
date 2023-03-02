function CJ = jacobi(X,mu)
% global mu CJ;

% Definicion  de la constante de jacobi
r02 = (X(:,1)).^2 + X(:,2).^2;
r0=r02.^(1/2);
r12 = (X(:,1)-mu).^2 + X(:,2).^2;
r1 = r12.^(1/2);
r22 = (X(:,1)+1-mu).^2 + X(:,2).^2;
r2 = r22.^(1/2);
v2 = X(:,3).^2 + X(:,4).^2;

omega = r02./2+mu./r2+(1-mu)./r1+mu*(1-mu)/2;
CJ = 2*omega - v2;
end