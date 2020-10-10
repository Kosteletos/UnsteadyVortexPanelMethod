close all
clear all
addpath(genpath(pwd))

np = 100; % Number of panels
t = 0.2; % Simulation time [s]
dt = 0.05; % Time step [s]

xygFSVortex = []; %Initial Free stream vortices
totalBoundCirc = 0;

tn = t/dt;
for tc = 0:tn
    t = tc*dt;
    
    [pos, vel, alpha, alphaDot] = kinematics(t);

    [xyPanel, xyCollocation, xyBoundVortex, normal] = makePanels(alpha, pos, np);
    
    % Panel postion plotting Tool
    %panelPosPlotting(xyPanel, xyCollocation, xyBoundVortex);
    
    %  Assemble the lhs & rhs of the equation for the potential flow calculation
    A = buildLHS(xyCollocation, xyBoundVortex, normal, np);
    b = buildRHS(xyCollocation, normal, np, pos, vel, alphaDot, alpha, xygFSVortex, totalBoundCirc);

    % Solve for surface vortex sheet strength
    gam = A\b; 
    
    uv_vec = testUV(xyCollocation, xyBoundVortex, np, gam);
    
    % Calculate bound circulation
    totalBoundCirc = totalBoundCirculation(gam, np);
    %if tc==0
    %streamfunctionPlotting(gam, xyPanel, xyBoundVortex,uv_vec, xygFSVortex, xyCollocation, alpha, np);
    %end
    
    % Wake moves with flow, trailing edge vortex is released 
    [xygFSVortex] = biotSavart(dt, np, xyPanel, xyBoundVortex, gam, xygFSVortex);

end

streamfunctionPlotting(gam, xyPanel, xyBoundVortex, uv_vec, xygFSVortex,xyCollocation, alpha, np);



