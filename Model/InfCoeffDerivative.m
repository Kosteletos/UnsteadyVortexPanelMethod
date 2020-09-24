function [infau, infav, infbu, infbv ] = InfCoeffDerivative(xa,ya,xb,yb,x,y)
% calculates influence coefficient derivatives at all x,y for panel
% between (xa,ya) and (xb,yb)

t = [xb-xa,yb-ya];
t = t/norm(t);

n = [ya-yb,xb-xa];
n = n/norm(n);

rx = x-xa;
ry = y-ya;

X = rx.*t(1) + ry.*t(2);
Y = rx.*n(1) + ry.*n(2);

del = sqrt((xb-xa)^2+(yb-ya)^2);

[infau, infav, infbu, infbv ] = RefInfCoeffDerivative(del,X,Y);
end