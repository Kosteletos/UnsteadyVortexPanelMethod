close all
clear all
addpath(genpath(pwd))
tic

% Simulation Options
np = 100; % Number of panels
t = 1; % Simulation time [s]
dt = 0.005; % Time step [s]
plateLength = 0.12;
targetLift = 1.5e-2;
LEVortex = 0; %1 = true, 0 = false 
TEVortex = 1;
Optimise = 0;
solveForces = 0;

%Plotting options


tn = round(t/dt);
h = figure;
M(tn) = struct('cdata',[],'colormap',[]);
[h, M, xm, ym, nx, ny] = preparePlots(h,M);
xygFSVortex_rel = [];
totalBoundCirc = 0;
Ix = 0; Iy = 0;
optimisationFlag = 0;
deltaLift = 0;
alphaDot = zeros(tn+1,1);
alpha = zeros(tn+1,1);
lift = zeros(tn+1,1);
drag = zeros(tn+1,1);

% Assemble lhs of the equation in relative coords (i.e doesn't change)
[xyPanel_rel, xyCollocation_rel, xyBoundVortex_rel, normal_rel] = makePanels(0, [0,0], np, plateLength);
A = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np);


 
tc = 1;
iterationCounter = 0;
while tc <= tn
    t = tc*dt;
    
    if iterationCounter == 0
        [pos, vel, alpha(tc+1), alphaDot(tc+1)] = kinematics(t, dt, optimisationFlag, deltaLift, alpha(tc), alpha(tc));
    else
        [pos, vel, alpha(tc+1), alphaDot(tc+1)] = kinematics(t, dt, optimisationFlag, deltaLift, alpha(tc+1), alpha(tc));
    end
    
    % For shedding the LE and TE vortex to a point where to LE and TE were at
    % previous time step

    %     if exist('xyPanel', 'var') 
    %         [A, xyBoundVortex_rel, xyPanel] = updateLHS(xyPanel, alpha(tc+1), pos, np, normal_rel, xyBoundVortex_rel, xyCollocation_rel, xyPanel_rel, A);
    %     else
    %         [xyPanel, xyCollocation, xyBoundVortex, ~] = makePanels(alpha(tc+1), pos, np, panelLength);
    % %         Panel postion plotting Tool
    % %         panelPosPlotting(xyPanel, xyCollocation, xyBoundVortex);
    %     end

    %  Assemble the rhs of the equation for the potential flow calculation
    b = buildRHS(normal_rel, xyCollocation_rel, np, vel, alphaDot(tc+1), alpha(tc+1), xygFSVortex_rel, totalBoundCirc);

    % Solve for surface vortex sheet strength
    gam = A\b; 
    

    %uv_vec = testUV(alpha(tc+1), pos, np, gam, plateLength);
    
    totalBoundCirc = totalBoundCirculation(LEVortex, TEVortex, gam, np);
    
    if solveForces == 1
        if iterationCounter == 0
            Ix0 = Ix;
            Iy0 = Iy;
            [lift(tc+1), drag(tc+1), Ix, Iy] = Forces(dt, alpha(tc+1), xygFSVortex_rel, xyBoundVortex_rel, gam, Ix, Iy);
        else
            [lift(tc+1), drag(tc+1), Ix, Iy] = Forces(dt, alpha(tc+1), xygFSVortex_rel, xyBoundVortex_rel, gam, Ix0, Iy0);
        end
    
        if (lift(tc+1) > targetLift) && (Optimise == 1)
            optimisationFlag = 1;
        end
        deltaLift = targetLift - lift(tc+1);
    end
    
    if tc == tn && abs(deltaLift)< 5e-5
        toc
        if solveForces == 1
            plotForces(lift, drag, alpha, alphaDot, dt);
        end
        [M,h] = streamfunctionPlotting(M, h, xm, ym, nx, ny, alpha(tc+1), pos, vel, gam, xygFSVortex_rel, np, t, dt, plateLength);
    end
    
    [M,h] = streamfunctionPlotting(M, h, xm, ym, nx, ny, alpha(tc+1), pos, vel, gam, xygFSVortex_rel, np, t, dt, plateLength);
        

    
    
    iterationCounter = iterationCounter+1;
    if (abs(deltaLift)< 5e-5) || (optimisationFlag == 0)
        % Trailing edge vortex is released, wake moves with flow
        [xygFSVortex_rel] = biotSavart(LEVortex, TEVortex, dt, np, vel, alpha(tc+1), alphaDot(tc+1), xyBoundVortex_rel, gam, xygFSVortex_rel);
        tc = tc+1;
        iterationCounter = 0;
    end
end





