close all
clear all
addpath(genpath(pwd))

np = 10; % Number of panels
t = 1; % Simulation time [s]
dt = 0.1; % Time step [s]
xygFSVortex = []; %Initial Free stream vortices

tc = t/dt;
for tc = 0:tc
    t = tc*dt;
    
    [pos, vel, alpha, alphaDot] = kinematics(t);

    [xyPanel, xyCollocation, xyBoundVortex, normal] = makePanels(alpha, pos, np);
    
    % Panel Plotting Tools ------------------------------------------------
    %scatter(xyPanel(:,1), xyPanel(:,2), 'filled');
    %plot(xyPanel(:,1), xyPanel(:,2),'-o');
    %axis equal
    %hold on;
    %plot(xyCollocation(:,1), xyCollocation(:,2),'-o');
    %plot(xyBoundVortex(:,1), xyBoundVortex(:,2),'-o');
    %scatter(xyCollocation(:,1), xyCollocation(:,2), 'filled');
    %scatter(xyBoundVortex(:,1), xyBoundVortex(:,2), 'filled');
    % ---------------------------------------------------------------------
    
    
    %  Assemble the lhs of the equations for the potential flow calculation
    A = buildLHS(xyCollocation, xyBoundVortex, normal, np);
    Am1 = inv(A);

    b = buildRHS(xyCollocation, normal, np, pos, vel, alphaDot, alpha, xygFSVortex);

    %    solve for surface vortex sheet strength
    gam = Am1 * b;

    %    calculate cp distribution and overall circulation
    %[cp, TotalCirc, FinalPanelCirc] = potential_op ( xs, ys, gam );

    %[xfsVortex, yfsVortex, gamfsVortex] = biotSavart(FinalPanelCirc, dt, xs, ys, gam, xfsVortex, yfsVortex, gamfsVortex);

end

hold off;
streamfunction_plotting(gam, xyPanel, xyBoundVortex, alpha, np);
