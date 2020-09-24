function [infau, infav, infbu, infbv ] = RefInfCoeffDerivative(del,X,Y)
%Derivatives in x and y of the influence coefficients

% Calculates the velocity influence coefficients at at point (x,y) due to a
% vortex panel sheet between (0,0) and (del, 0)

%Replace all valuse of y less than 1e-8 with 1e-8 
Y(abs(Y)<1e-8)=1e-8; 

% I0
I0 = -(1./(4.*pi)).*(X.*log(X.^2+Y.^2) -(X-del).*log((X-del).^2+Y.^2) - 2.*del + 2.*Y.*(atan(X./Y) -atan((X-del)./Y)));

%dI0/dy 
a1 = 2.*X.*Y/(X.^2+Y.^2);
a2 = -2.*(X-del).*Y./((X-del).^2 + Y.^2);
a3 = 2.*(atan(X./Y)-atan((X-del)./Y));
a4 = 2.*Y.*log(Y).*(X/(1+(X/Y).^2)+(X-del)./(1+((X-del)/Y).^2));
dI0dy = -(1./(4*pi)).*(a1 + a2 + a3 + a4);

%dI0/dx
b1 = log(X.^2 + Y.^2);
b2 = 2*X.^2 .* (1/(X.^2+Y.^2));
b3 = - log((X-del).^2 + Y.^2);
b4 = -2*(X-del).^2/((X-del).^2 + Y.^2);
b5 = 2*Y.^2 .*(1/(X.^2 + Y.^2) -1/((X-del).^2 + Y.^2));
dI0dx = -(1./(4*pi)).*(b1 + b2 + b3 + b4 + b5);

%dI1/dy
c1 = (X.^2 + 2.*Y).*log(X.^2 + Y.^2);
c2 = -((X-del).^2 + 2.*Y).*log((X-del).^2 + Y.^2);
dI1dy = (1/(8*pi)).*(c1 + c2);

%dI1/dx
d1 = (Y.^2 + 2.*X).*log(X.^2 + Y.^2);
d2 = -(2*(X-del) + Y.^2).*log((X-del).^2 + Y.^2);
dI1dx = (1/(8*pi)).*(d1 + d2);

%Velocity field influence coefficients
infau = (1-X./del)*dI0dy - dI1dy/del;
infbu = (X/del)*dI0dy +dI1dy/del;
infav = -((1-X/del)*dI0dx -I0/del -dI1dx/del);
infbv = -((X/del).*dI0dx +I0/del +dI1dx/del);

end

