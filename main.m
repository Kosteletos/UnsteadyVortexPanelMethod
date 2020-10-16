close all
clear all
addpath(genpath(pwd))

np = 50; % Number of panels
t = 2; % Simulation time [s]
dt = 0.02; % Time step [s]

xygFSVortex_rel = []; %Initial Free stream vortices
totalBoundCirc = 0;

% Assemble lhs of the equation in relative coords (i.e doesn't change)
[xyPanel_rel, xyCollocation_rel, xyBoundVortex_rel, normal_rel] = makePanels(0, [0,0], np);
A = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np);

tn = t/dt;
for tc = 0:tn
    t = tc*dt;
    
    [pos, vel, alpha, alphaDot] = kinematics(t);

% For shedding the LE and TE vortex to a point where to LE and TE were at
% previous time step

%     if exist('xyPanel', 'var') 
%         [A, xyBoundVortex_rel, xyPanel] = updateLHS(xyPanel, alpha, pos, np, normal_rel, xyBoundVortex_rel, xyCollocation_rel, xyPanel_rel, A);
%     else
%         [xyPanel, xyCollocation, xyBoundVortex, ~] = makePanels(alpha, pos, np);
% %         Panel postion plotting Tool
% %         panelPosPlotting(xyPanel, xyCollocation, xyBoundVortex);
%     end

    %  Assemble the rhs of the equation for the potential flow calculation
    b = buildRHS(normal_rel, xyCollocation_rel, np, vel, alphaDot, alpha, xygFSVortex_rel, totalBoundCirc);

    % Solve for surface vortex sheet strength
    gam = A\b; 
    

    uv_vec = testUV(alpha, pos, np, gam);
    
    totalBoundCirc = totalBoundCirculation(gam, np);

    if tc == tn
        streamfunctionPlotting(alpha, pos, vel, gam, uv_vec, xygFSVortex_rel, np, t, dt);
    end
    %streamfunctionPlotting(alpha, pos, vel, gam, uv_vec, xygFSVortex_rel, np, t, dt);
    
    % Trailing edge vortex is released, wake moves with flow
    [xygFSVortex_rel] = biotSavart(dt, np, vel, alpha, alphaDot, xyPanel_rel, xyBoundVortex_rel, gam, xygFSVortex_rel);
    

end





