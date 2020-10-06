%    foil.m
%
%  Script to analyse an aerofoil section using potential flow calculation
%  


close all
clear all
addpath(genpath(pwd))

alpha0_deg = 30; % Initial angle of attack (degrees)
np = 10; % Number of panels
V = 1; % Free-stream velocity

alpha0_rad = alpha0_deg*pi/180;
initital_position = [0,0 ; cos(alpha0_rad), -sin(alpha0_rad)]; %xy_start ; xy_end
%  Interpolate to required number of panels (uniform size)
[xyPanel, xyCollocation, xyBoundVortex] = makePanels(initital_position, np);

%Plot aerofoil
scatter(xyPanel(:,1), xyPanel(:,2), 'filled');
hold on;
scatter(xyCollocation(:,1), xyCollocation(:,2), 'filled');
scatter(xyBoundVortex(:,1), xyBoundVortex(:,2), 'filled');
hold off;

xygFSVortex = [];


dt = 0.01;
for t = 1:nt 
    %  Assemble the lhs of the equations for the potential flow calculation
    A = build_lhs (xs, ys);
    Am1 = inv(A);


    %    rhs of equations
    alpha_rad = pi * alpha_deg/180;
    b = build_rhs ( xs, ys, alpha_rad, xfsVortex, yfsVortex, gamfsVortex);

    %    solve for surface vortex sheet strength
    gam = Am1 * b;

    %    calculate cp distribution and overall circulation
    [cp, TotalCirc, FinalPanelCirc] = potential_op ( xs, ys, gam );

    [xfsVortex, yfsVortex, gamfsVortex] = biotSavart(FinalPanelCirc, dt, xs, ys, gam, xfsVortex, yfsVortex, gamfsVortex);

    %    locate stagnation point and calculate stagnation panel length
    [ipstag, fracstag] = find_stag(gam);
    dsstag = sqrt((xs(ipstag+1)-xs(ipstag))^2 + (ys(ipstag+1)-ys(ipstag))^2);


end

streamfunction_plotting(gam, xs, ys, alpha_rad, ipstag, xfsVortex, yfsVortex);
