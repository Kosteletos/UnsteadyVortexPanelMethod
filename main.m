close all
clear all
addpath(genpath(pwd))

np = 100; % Number of panels
t = 1; % Simulation time [s]
dt = 0.01; % Time step [s]
LEVortex = 1; %1 = true, 0 = false 
TEVortex = 1;

tn = t/dt;
xygFSVortex_rel = []; %Initial Free stream vortices
totalBoundCirc = 0;
Ix = 0; Iy = 0;
lift = zeros(tn+1,1);
drag = zeros(tn+1,1);

% Assemble lhs of the equation in relative coords (i.e doesn't change)
[xyPanel_rel, xyCollocation_rel, xyBoundVortex_rel, normal_rel] = makePanels(0, [0,0], np);
A = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np);


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
    
    totalBoundCirc = totalBoundCirculation(LEVortex, TEVortex, gam, np);
    
    [lift(tc+1), drag(tc+1), Ix, Iy] = Forces(dt, alpha, xygFSVortex_rel, xyBoundVortex_rel, gam, Ix, Iy);
   
    if tc == tn
        plotForces(lift, lift, dt);
        streamfunctionPlotting(alpha, pos, vel, gam, uv_vec, xygFSVortex_rel, np, t, dt);
    end
    
    %streamfunctionPlotting(alpha, pos, vel, gam, uv_vec, xygFSVortex_rel, np, t, dt);
        
    % Trailing edge vortex is released, wake moves with flow
    [xygFSVortex_rel] = biotSavart(LEVortex, TEVortex, dt, np, vel, alpha, alphaDot, xyBoundVortex_rel, gam, xygFSVortex_rel);
    

end





