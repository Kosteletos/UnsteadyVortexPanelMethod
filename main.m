close all
clear all
addpath(genpath(pwd))

np = 100; % Number of panels
t = 1; % Simulation time [s]
dt = 0.005; % Time step [s]

xygFSVortex_rel = []; %Initial Free stream vortices
totalBoundCirc = 0;

% Assemble lhs of the equation in relative coords (i.e doesn't change)
[xyPanel_rel, xyCollocation_rel, xyBoundVortex_rel, normal_rel] = makePanels(0, [0,0], np);
A = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np);

tn = t/dt;
for tc = 0:tn
    t = tc*dt;
    
    [pos, vel, alpha, alphaDot] = kinematics(t);

    if exist('xyPanel', 'var') 
        [A, xyBoundVortex_rel, xyPanel] = updateLHS(xyPanel, alpha, pos, np, normal_rel, xyBoundVortex_rel, xyCollocation_rel, xyPanel_rel, A);
    end

    % Panel postion plotting Tool
    %panelPosPlotting(xyPanel, xyCollocation, xyBoundVortex);
    
    %  Assemble the rhs of the equation for the potential flow calculation
    b = buildRHS(normal_rel, xyCollocation_rel, np, -vel, alphaDot, alpha, xygFSVortex_rel, totalBoundCirc);

    % Solve for surface vortex sheet strength
    gam = A\b; 
    
    [xyPanel, xyCollocation, xyBoundVortex, normal] = makePanels(alpha, pos, np);
    uv_vec = testUV(xyCollocation, xyBoundVortex, np, gam);
    
    % Calculate bound circulation
    totalBoundCirc = totalBoundCirculation(gam, np);
    %if tc==0
    %streamfunctionPlotting(alpha, pos, gam, xyPanel, xyBoundVortex, uv_vec, xygFSVortex_rel, xyCollocation, alpha, np);
    %end
    
    % Wake moves with flow, trailing edge vortex is released 
    [xygFSVortex_rel] = biotSavart(dt, np, vel, alpha, alphaDot, xyPanel_rel, xyBoundVortex_rel, gam, xygFSVortex_rel);

end
[xyPanel, xyCollocation, xyBoundVortex, normal] = makePanels(alpha, pos, np);
streamfunctionPlotting(alpha, -pos, gam, xyPanel, xyBoundVortex, uv_vec, xygFSVortex_rel, xyCollocation, alpha, np);



