function [xyPanel, xyCollocation, xyBoundVortex] = makePanels(position, np);

xPanLength = (position(2,1)-position(1,1))/np;
yPanLength = (position(2,2)-position(1,2))/np;
PanLength = sqrt(xPanLength^2 + yPanLength^2)

%Body Panels
xp = linspace(position(1,1), position(2,1),np);
yp = linspace(position(1,2), position(2,2),np);
xyPanel = [xp.', yp.'];

%Collocation Points
xc = linspace(position(1,1) + 3*xPanLength/4, position(2,1) - xPanLength/4, np-1);
yc = linspace(position(1,2) + 3*yPanLength/4, position(2,2) - yPanLength/4, np-1);
xyCollocation = [xc.', yc.'];

%Bound Vortex Positions
xv = linspace(position(1,1) + xPanLength/4, position(2,1) - 3*xPanLength/4, np-1);
yv = linspace(position(1,2) + yPanLength/4, position(2,2) - 3*yPanLength/4, np-1);
xv(np) = position(2,1);
yv(np) = position(2,2);

xyBoundVortex = [xv.', yv.'];



end

