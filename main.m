close all
clear all
addpath(genpath(pwd))

np = 100; % Number of panels
t = 0.5; % Simulation time [s]
dt = 0.01; % Time step [s]

xygFSVortex_rel = []; %Initial Free stream vortices
totalBoundCirc = 0;

% Assemble lhs of the equation in relative coords (i.e doesn't change)
[xyPanel_rel, xyCollocation_rel, xyBoundVortex_rel, normal_rel] = makePanels(0, [0,0], np);
% A = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np);

tn = t/dt;
for tc = 0:tn
    t = tc*dt;
    
    [pos, vel, alpha, alphaDot] = kinematics(t);

    exists = exist('xyPanel', 'var');
    if exists == 1 
        xyPanelPrev = xyPanel;
    end
    [xyPanel, xyCollocation, xyBoundVortex, normal] = makePanels(alpha, -pos, np);
    if exists == 1
        xyBoundVortex_rel(end,:) = xyPanel_rel(end,:)+ xyPanelPrev(end,:)-xyPanel(end,:);
    end
    A = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np);


    
    % Panel postion plotting Tool
    %panelPosPlotting(xyPanel, xyCollocation, xyBoundVortex);
    
    %  Assemble the rhs of the equation for the potential flow calculation
    b = buildRHS(normal_rel, xyCollocation_rel, xyCollocation, normal, np, pos, -vel, alphaDot, alpha, xygFSVortex_rel, totalBoundCirc);

    % Solve for surface vortex sheet strength
    gam = A\b; 
    
    uv_vec = testUV(xyCollocation, xyBoundVortex, np, gam);
    
    % Calculate bound circulation
    totalBoundCirc = totalBoundCirculation(gam, np);
    %if tc==0
    %streamfunctionPlotting(alpha, pos, gam, xyPanel, xyBoundVortex, uv_vec, xygFSVortex_rel, xyCollocation, alpha, np);
    %end
    
    % Wake moves with flow, trailing edge vortex is released 
    [xygFSVortex_rel] = biotSavart(dt, np, vel, alpha, alphaDot, xyPanel_rel, xyBoundVortex_rel, gam, xygFSVortex_rel);

end

streamfunctionPlotting(alpha, -pos, gam, xyPanel, xyBoundVortex, uv_vec, xygFSVortex_rel, xyCollocation, alpha, np);



