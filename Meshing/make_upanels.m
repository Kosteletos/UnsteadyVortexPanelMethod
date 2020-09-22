function [xs, ys] = make_upanels ( xsin, ysin, np )
%
%  function [xs ys] = make_upanels ( xsin, ysin, np )
%
%  Generates surface description (xs,ys) with np uniform panels, from input
%  description (xsin,ysin).  Note that simple linear interpolation is used, 
%  so (xsin,ysin) should be high resolution for good accuracy.
%

%  calculate distance around foil of each input point
npin = length(xsin)-1;
dsin = sqrt ( (xsin(2:npin+1)-xsin(1:npin)).^2 + ...
                     (ysin(2:npin+1)-ysin(1:npin)).^2);
essin(1) = 0;
essin(2:npin+1) = cumsum(dsin);

%  size of uniform panels
ds = essin(npin+1)/np;

%  interpolate for uniformly spaced, coordinates
xs(1) = xsin(1);
ys(1) = ysin(1);
essout = (1:np-1) * ds;
xs(2:np) = interp1(essin,xsin,essout);
ys(2:np) = interp1(essin,ysin,essout);
xs(np+1) = xs(1);
ys(np+1) = ys(1);