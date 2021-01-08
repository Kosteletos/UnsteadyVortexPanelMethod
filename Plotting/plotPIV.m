load("PIVData/PIV-Vel_322_Angle_15_Acc_50")

xGrid = PIV.xi;
yGrid = PIV.yi;

timeIndex = 371;

ui = PIV.Ui(:,:,timeIndex);
vi = PIV.Vi(:,:,timeIndex);

Vorticity = PIV.Vorticity(:,:,timeIndex);

bodySurfaceX = PIV.BodySurfaceX(timeIndex,:);
bodySurfaceY = PIV.BodySurfaceY(timeIndex,:);

% Simulation Data
[xyPanel, xyCollocation, xyBoundVortex, ~] = makePanels(alpha, pos, np, plateLength);
inerToRel = [cos(alpha), sin(alpha); -sin(alpha), cos(alpha)]; % inertial frame to relative frame
% if size(xygFSVortex_rel) ~= 0 
%     xygFSVortex_rel(:,1:2) = (inerToRel*xygFSVortex_rel(:,1:2).').' + pos;
% end



%quiver(xGrid, yGrid, ui, vi);
axis equal
hold on
fill(bodySurfaceX, bodySurfaceY,'g');
c = [-80:10:-10 , 10:10:80];
contour(xGrid,yGrid,Vorticity,c);
% plot(xyPanel(:,1),xyPanel(:,2),'k','linewidth',2);
scatter(xygFSVortex_rel(:,1), xygFSVortex_rel(:,2),[], xygFSVortex_rel(:,3)*1e6, 'x', 'linewidth',2);
%scatter(xygFSVortex_rel(:,1), xygFSVortex_rel(:,2),[], 'r', 'x', 'linewidth',1);
hold off
