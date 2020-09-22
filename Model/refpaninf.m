function [infa, infb] = refpaninf(del,X,Y) 
% Calculates the influence coefficients at at point (x,y) due to a vortex
% to be used for reference
% sheet between (0,0) and (del, 0)

%Replace all valuse of y less than 1e-8 with 1e-8 
Y(abs(Y)<1e-8)=1e-8; 

I0 = -(1./(4.*pi)).*(X.*log(X.^2+Y.^2) -(X-del).*log((X-del).^2+Y.^2) - 2.*del + 2.*Y.*(atan(X./Y) -atan((X-del)./Y)));
I1 = (1./(8.*pi)).*((X.^2+Y.^2).*log(X.^2+Y.^2)-((X-del).^2+Y.^2).*log((X-del).^2+Y.^2)-2.*X.*del+del.^2);
 
infa = (1-X./del).*I0 - I1./del;
infb = (X./del).*I0 + I1./del;
end

