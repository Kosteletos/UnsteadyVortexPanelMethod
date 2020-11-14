close all
clear all
addpath(genpath(pwd))
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation Options
np = 400; % Number of panels
t = 1; % Simulation time [s]
dt = 0.001; % Time step [s]
rho = 1000; % Density [kg/m^3]
chord = 0.12;
targetLift = 2;
LEVortex = 1; %1 = true, 0 = false 
TEVortex = 1;
Optimise = 0;
stopOptimiseTime = 0.7; %[s]
solveForces = 1;

%Plotting options
Streamlines = 0;
Vortices = 1;
frames = 20;
%load("PIVData/PIV-Vel_322_Angle_15_Acc_50") % Load PIV data if needed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tn = round(t/dt);
h = figure;
M(tn) = struct('cdata',[],'colormap',[]);
[h, M, xm, ym, nx, ny] = preparePlots(h,M);
xygFSVortex_rel = [];
totalBoundCirc = 0;
Ix = 0; Iy = 0;
Ixf = 0; Iyf = 0;
Ixb = 0; Iyb = 0;
optimisationFlag = 0;
deltaLift = 0;
alphaDot = zeros(tn+1,1);
alpha = zeros(tn+1,1);
lift = zeros(tn+1,1);
drag = zeros(tn+1,1);
cl = zeros(tn+1,1);
pos = zeros(tn+1,2);
vel = zeros(tn+1,2);
LiftComponents = zeros(tn+1,2);

% Assemble lhs of the equation in relative coords (i.e doesn't change)
[xyPanel_rel, xyCollocation_rel, xyBoundVortex_rel, normal_rel] = makePanels(0, [0,0], np, chord);
A = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np);
 
tc = 1;
iterationCounter = 0;
while tc <= tn    
    t = tc*dt;
    
    if iterationCounter == 0
        [pos(tc+1,:), vel(tc+1,:), alpha(tc+1), alphaDot(tc+1)] = kinematics(t, dt, optimisationFlag, deltaLift, alpha(tc), alpha(tc), rho, chord, pos(tc,:), vel(tc,:));
        %[pos, vel, alpha(tc+1), alphaDot(tc+1)] = kinematicsFromPIV(t, PIV);
    else
        [pos(tc+1,:), vel(tc+1,:), alpha(tc+1), alphaDot(tc+1)] = kinematics(t, dt, optimisationFlag, deltaLift, alpha(tc+1), alpha(tc), rho, chord, pos(tc,:), [0,0]);
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
    b = buildRHS(normal_rel, xyCollocation_rel, np, vel(tc+1,:), alphaDot(tc+1), alpha(tc+1), xygFSVortex_rel, totalBoundCirc);
    
    % Solve for surface vortex sheet strength
    gam = A\b; 

    %uv_vec = testUV(alpha(tc+1), pos, np, gam, chord);
    
    totalBoundCirc = totalBoundCirculation(LEVortex, TEVortex, gam, np);
    
    if solveForces == 1
        if iterationCounter == 0
            Ix0 = Ix; Iy0 = Iy;
            Ixf0 = Ixf; Iyf0 = Iyf;
            Ixb0 = Ixb; Iyb0 = Iyb;
            [lift(tc+1), drag(tc+1), Ix, Iy, Ixf, Iyf, Ixb, Iyb, cl(tc+1),LiftComponents(tc,:)] = Forces(dt, alpha(tc+1), rho, xygFSVortex_rel, xyBoundVortex_rel, gam, Ix, Iy, Ixf, Iyf, Ixb, Iyb, chord);
        else
            [lift(tc+1), drag(tc+1), Ix, Iy, Ixf, Iyf, Ixb, Iyb, cl(tc+1), LiftComponents(tc,:)] = Forces(dt, alpha(tc+1), rho, xygFSVortex_rel, xyBoundVortex_rel, gam, Ix0, Iy0, Ixf0, Iyf0, Ixb0, Iyb0, chord);
        end
    
        if (lift(tc+1) > targetLift) && (Optimise == 1)
            optimisationFlag = 1;
        end
        
        if (t > stopOptimiseTime) && (Optimise==1)
           optimisationFlag = 2; 
        end
        
        deltaLift = targetLift - lift(tc+1);
    end
    
    
    if (tc == tn && (abs(deltaLift)< 1e-2 || Optimise==0))
        toc
        if solveForces == 1
            plotForces(lift, LiftComponents, drag, cl, alpha, alphaDot, dt);
        end
        [M,h] = streamfunctionPlotting(M, h, xm, ym, nx, ny, alpha(tc+1), pos(tc+1,:), vel(tc+1,:), gam, xygFSVortex_rel, np, t, dt, chord, Streamlines);
    end    

    disp(['time=',num2str(t),', iteration=',num2str(iterationCounter)]); %include time taken for this iteration
  
    iterationCounter = iterationCounter+1;
    if (abs(deltaLift)< 1e-2) || (optimisationFlag == 0 || (optimisationFlag == 2)) %normally 5e-5 
        if mod(tc,frames) == 0
            [M,h] = streamfunctionPlotting(M, h, xm, ym, nx, ny, alpha(tc+1), pos(tc+1,:), vel(tc+1,:), gam, xygFSVortex_rel, np, t, dt, chord, Streamlines, frames);
        end
        % Trailing edge vortex is released, wake moves with flow
        [xygFSVortex_rel] = biotSavart(LEVortex, TEVortex, dt, np, vel(tc+1,:), alpha(tc+1), alphaDot(tc+1), xyBoundVortex_rel, gam, xygFSVortex_rel);
        tc = tc+1;
        iterationCounter = 0;
    end
    
end





