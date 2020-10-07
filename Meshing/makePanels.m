function [xyPanel, xyCollocation, xyBoundVortex, normal] = makePanels(alpha, pos, np)

position = [-0.5*cos(alpha) + pos(1), 0.5*sin(alpha) + pos(2) ; 0.5*cos(alpha) + pos(1), -0.5*sin(alpha) + pos(2)]; %xy_start ; xy_end

normal = [sin(alpha), cos(alpha)];

xPanLength = (position(2,1)-position(1,1))/np;
yPanLength = (position(2,2)-position(1,2))/np;

%Body Panels
xp = linspace(position(1,1), position(2,1),np+1);
yp = linspace(position(1,2), position(2,2),np+1);
xyPanel = [xp.', yp.'];

%Collocation Points
xc = linspace(position(1,1) + 3*xPanLength/4, position(2,1) - xPanLength/4, np);
yc = linspace(position(1,2) + 3*yPanLength/4, position(2,2) - yPanLength/4, np);
xyCollocation = [xc.', yc.'];

%Bound Vortex Positions
xv = linspace(position(1,1) + xPanLength/4, position(2,1) - 3*xPanLength/4, np);
yv = linspace(position(1,2) + yPanLength/4, position(2,2) - 3*yPanLength/4, np);
xv(np+1) = position(2,1); % Not necessarily true <- should it go beyond TE?
yv(np+1) = position(2,2); % 

xyBoundVortex = [xv.', yv.'];



end

