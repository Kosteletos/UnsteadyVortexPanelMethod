close all
clear all
addpath(genpath(pwd))

np = 400; % Number of panels
t = 0.5; % Simulation time [s]
dt = 0.005; % Time step [s]
plateLength = 0.12;
targetLift = 0.3;
LEVortex = 1; %1 = true, 0 = false 
TEVortex = 1;
Optimise = 0;
solveForces = 1;

tn = round(t/dt);
xygFSVortex_rel = []; %Initial Free stream vortices
totalBoundCirc = 0;
Ix = 0; Iy = 0;
optimisationFlag = 0;
deltaLift = 0;
alphaPrev = 0;
alpha = 0;
lift = zeros(tn+1,1);
drag = zeros(tn+1,1);

% Assemble lhs of the equation in relative coords (i.e doesn't change)
[xyPanel_rel, xyCollocation_rel, xyBoundVortex_rel, normal_rel] = makePanels(0, [0,0], np, plateLength);
A = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np);


%for tc = 0:tn %convert to while loop for optimisation, only move to next time when lift is within bounds
tc = 0;
iterationCounter = 0;
while tc <= tn
    t = tc*dt;
    
    [pos, vel, alpha, alphaDot] = kinematics(t, dt, optimisationFlag, deltaLift, alphaPrev, alpha);

    if iterationCounter == 0
       alphaPrev = alpha; 
    end
% For shedding the LE and TE vortex to a point where to LE and TE were at
% previous time step

%     if exist('xyPanel', 'var') 
%         [A, xyBoundVortex_rel, xyPanel] = updateLHS(xyPanel, alpha, pos, np, normal_rel, xyBoundVortex_rel, xyCollocation_rel, xyPanel_rel, A);
%     else
%         [xyPanel, xyCollocation, xyBoundVortex, ~] = makePanels(alpha, pos, np, panelLength);
% %         Panel postion plotting Tool
% %         panelPosPlotting(xyPanel, xyCollocation, xyBoundVortex);
%     end

    %  Assemble the rhs of the equation for the potential flow calculation
    b = buildRHS(normal_rel, xyCollocation_rel, np, vel, alphaDot, alpha, xygFSVortex_rel, totalBoundCirc);

    % Solve for surface vortex sheet strength
    gam = A\b; 
    

    uv_vec = testUV(alpha, pos, np, gam, plateLength);
    
    totalBoundCirc = totalBoundCirculation(LEVortex, TEVortex, gam, np);
    
    if solveForces == 1
        if iterationCounter == 0
            Ix0 = Ix;
            Iy0 = Iy;
            [lift(tc+1), drag(tc+1), Ix, Iy] = Forces(dt, alpha, xygFSVortex_rel, xyBoundVortex_rel, gam, Ix, Iy);
        else
            [lift(tc+1), drag(tc+1), Ix, Iy] = Forces(dt, alpha, xygFSVortex_rel, xyBoundVortex_rel, gam, Ix0, Iy0);
        end
    
        if (lift(tc+1) > targetLift) && (Optimise == 1)
            optimisationFlag = 1;
        end
        deltaLift = targetLift - lift(tc+1);
    end
    
    if tc == tn % || optimisationFlag ==1
        if solveForces == 1
            plotForces(lift, lift, dt);
        end
        streamfunctionPlotting(alpha, pos, vel, gam, uv_vec, xygFSVortex_rel, np, t, dt, panelLength);
    end
    
    %streamfunctionPlotting(alpha, pos, vel, gam, uv_vec, xygFSVortex_rel, np, t, dt, panelLength);
        
    % Trailing edge vortex is released, wake moves with flow
    [xygFSVortex_rel] = biotSavart(LEVortex, TEVortex, dt, np, vel, alpha, alphaDot, xyBoundVortex_rel, gam, xygFSVortex_rel);
    
    
    iterationCounter = iterationCounter+1;
    if (abs(deltaLift) < 0.01) || (optimisationFlag == 0)
        tc = tc+1;
        iterationCounter = 0;
    end
end





