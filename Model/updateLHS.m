function [A, xyBoundVortex_rel, xyPanel] = updateLHS(xyPanel, alpha, pos, np, normal_rel, xyBoundVortex_rel,xyCollocation_rel, xyPanel_rel,  A)
% Position the new wake vortex and update the LHS matrix accordingly

xyEndPanelPrev = xyPanel(end,:);
xyStartPanelPrev = xyPanel(1,:);

position = [-0.5*cos(alpha) + pos(1), 0.5*sin(alpha) + pos(2) ; 0.5*cos(alpha) + pos(1), -0.5*sin(alpha) + pos(2)]; %xy_start ; xy_end

xp = linspace(position(1,1), position(2,1),np+1);
yp = linspace(position(1,2), position(2,2),np+1);
xyPanel = [xp.', yp.'];

% Transform from inertial frame to rel frame
inerToRel = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)]; % inertial frame to relative frame

dxyEndPanel_iner = xyEndPanelPrev-xyPanel(end,:);
dxyEndPanel_rel = (inerToRel*dxyEndPanel_iner.').';

dxyStartPanel_iner = xyStartPanelPrev-xyPanel(1,:);
dxyStartPanel_rel = (inerToRel*dxyStartPanel_iner.').';

xyBoundVortex_rel(end,:) = xyPanel_rel(end,:) + [1/np/4,0] + dxyEndPanel_rel;
xyBoundVortex_rel(1,:) = xyPanel_rel(1,:) + [1/np/4,0]  + dxyStartPanel_rel;

for i = 1:np
    uv = inducedVelocity(1,xyCollocation_rel(i,:),xyBoundVortex_rel(np+1,:));
    A(i,np+1) = dot(uv,normal_rel); 
end

for i = 1:np
    uv = inducedVelocity(1,xyCollocation_rel(i,:),xyBoundVortex_rel(1,:));
    A(i,1) = dot(uv,normal_rel); 
end



end

