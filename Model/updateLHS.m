function [A, xyBoundVortex_rel, xyPanel] = updateLHS(xyPanel, alpha, pos, np, normal_rel, xyBoundVortex_rel,xyCollocation_rel, xyPanel_rel, A)
% Position the new wake vortex and update the LHS matrix accordingly

xyEndPanelPrev = xyPanel(end,:);

position = [-0.5*cos(alpha) + pos(1), 0.5*sin(alpha) + pos(2) ; 0.5*cos(alpha) + pos(1), -0.5*sin(alpha) + pos(2)]; %xy_start ; xy_end

xp = linspace(position(1,1), position(2,1),np+1);
yp = linspace(position(1,2), position(2,2),np+1);
xyPanel = [xp.', yp.'];

% Transform from inertial frame to rel frame
inerToRel = [cos(alpha), -sin(alpha); sin(alpha), cos(alpha)]; % inertial frame to relative frame

dxyEndPanel_iner = xyEndPanelPrev-xyPanel(end,:);
dxyEndPanel_rel = (inerToRel*dxyEndPanel_iner.').';

xyBoundVortex_rel(end,:) = xyPanel_rel(end,:)+ dxyEndPanel_rel;

for i = 1:np
    uv = inducedVelocity(1,xyCollocation_rel(i,:),xyBoundVortex_rel(np+1,:));
    A(i,np+1) = dot(uv,normal_rel); 
end



end

