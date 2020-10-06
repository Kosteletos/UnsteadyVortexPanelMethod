%    foil.m
%
%  Script to analyse an aerofoil section using potential flow calculation
%  


close all
clear all
addpath(genpath(pwd))

alpha0_deg = 10; % Initial angle of attack (degrees)
np = 10; % Number of panels
t = 1; % Simulation time [s]
dt = 0.1; % Time step [s]
V = 1; % Free-stream velocity

alpha0_rad = alpha0_deg*pi/180;
initital_position = [0,0 ; cos(alpha0_rad), -sin(alpha0_rad)]; %xy_start ; xy_end
%  Interpolate to required number of panels (uniform size)
[xyPanel, xyCollocation, xyBoundVortex, normal] = makePanels(initital_position, np);

%Plot aerofoil
%scatter(xyPanel(:,1), xyPanel(:,2), 'filled');
%plot(xyPanel(:,1), xyPanel(:,2),'-o');
%hold on;
%plot(xyCollocation(:,1), xyCollocation(:,2),'-o');
%plot(xyBoundVortex(:,1), xyBoundVortex(:,2),'-o');
%scatter(xyCollocation(:,1), xyCollocation(:,2), 'filled');
%scatter(xyBoundVortex(:,1), xyBoundVortex(:,2), 'filled');
%hold off;

xygFSVortex = [];

nt = t/dt;
for t = 1:1 
    %  Assemble the lhs of the equations for the potential flow calculation
    A = buildLHS(xyCollocation, xyBoundVortex, normal, np);
    Am1 = inv(A);

    b = buildRHS(V, alpha0_rad, normal, np);

    %    solve for surface vortex sheet strength
    gam = Am1 * b;

    %    calculate cp distribution and overall circulation
    %[cp, TotalCirc, FinalPanelCirc] = potential_op ( xs, ys, gam );

    %[xfsVortex, yfsVortex, gamfsVortex] = biotSavart(FinalPanelCirc, dt, xs, ys, gam, xfsVortex, yfsVortex, gamfsVortex);

    %    locate stagnation point and calculate stagnation panel length
    %[ipstag, fracstag] = find_stag(gam);
    %dsstag = sqrt((xs(ipstag+1)-xs(ipstag))^2 + (ys(ipstag+1)-ys(ipstag))^2);


end

streamfunction_plotting(gam, xyPanel, xyBoundVortex, alpha0_rad);
