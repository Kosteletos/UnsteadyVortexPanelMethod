close all
clear all
addpath(genpath(pwd))
tic

global chord rho folder subfolder

t = 1; % Simulation time [s]
dt = 0.01; % Time step [s]
rho = 1000; % Density [kg/m^3]
% Simulation Options
np = 100; % Number of pane
chord = 1; % [m]
LEVortex = 0; %1 = true, 0 = false 
TEVortex = 1; %1 = true, 0 = false 
Optimise = 0; %1 = true, 0 = false 
startOptimiseTime = 1.0; %[s]
stopOptimiseTime = 5; %[s]
solveForces = 1;
maxError = 5e-3;

%Plotting options
folder = "C:\Users\Tom\OneDrive - University of Cambridge\Uni Notes\IIB\Project\Low-Order Model\Figures\Comparison\Steady State Acceleration";
subfolder = "test";
% Streamfunction Plotter
Plot = 1; % true or false
Streamlines = 0;  % true or false
Vortices = 1;     % true or false 
frames = 20;   % How often a frame is saved.
% Other Plotters
plotLiftCoef = 1; %1 = true, 0 = false 
plotAoA = 0; %1 = true, 0 = false
plotTranslation = 0; %1 = true, 0 = false
%load("PIVData/PIV-Vel_322_Angle_15_Acc_50") % Load PIV data if needed

% Initialisations
targetLift = 0;
prevToc = 0;
tn = round(t/dt);
h = figure('Renderer', 'painters', 'Position', [10 10 1800 600]); % Figure size
M(tn) = struct('cdata',[],'colormap',[]);
[h, M, xm, ym, nx, ny] = preparePlots(h,M);
xygFSVortex_rel = [];
totalBoundCirc = zeros(tn+1,1);
totalBoundCirc_am = zeros(tn+1,1);
Ix = zeros(tn+1,1); Iy = zeros(tn+1,1); Ix_am = zeros(tn+1,1); Iy_am = zeros(tn+1,1);
Ixb = zeros(tn+1,1); Iyb = zeros(tn+1,1); Ixb_am = zeros(tn+1,1); Iyb_am = zeros(tn+1,1);
Ixf = zeros(tn+1,1); Iyf = zeros(tn+1,1);
optimisationFlag = 0;
deltaLift = 0;
alphaDot = zeros(tn+1,1);
%alphaDot = alphaDotModel;
alpha = zeros(tn+1,1);
%alpha = alphaModel;
lift = zeros(tn+1,1);
lift_am = zeros(tn+1,1);
alpha_dLift_vec = zeros(tn+1,500,2);
drag = zeros(tn+1,1);


% Assemble lhs of the equation in relative coords (i.e doesn't change)
[xyPanel_rel, xyCollocation_rel, xyBoundVortex_rel, normal_rel] = makePanels(0, [0,0], np);
A = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np);
 
% Plate Kinematics
t_array = 0:dt:t;
[pos, vel] = translation(t_array);


tc = 1;
iterationCounter = 0;

while tc <= tn    
    t = tc*dt;

    %[pos, vel, alpha(tc+1), alphaDot(tc+1)] = kinematicsFromPIV(t, PIV);
    [alpha(tc+1), alphaDot(tc+1)] = rotation(t, dt, optimisationFlag, deltaLift, alpha(tc+1), alpha(tc), vel(tc,:));     
    
    
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
    b = buildRHS(normal_rel, xyCollocation_rel, np, vel(tc+1,:), alphaDot(tc+1), alpha(tc+1), xygFSVortex_rel, totalBoundCirc(tc));
    b_am = buildRHS(normal_rel, xyCollocation_rel, np, vel(tc+1,:), alphaDot(tc+1), alpha(tc+1), [], totalBoundCirc_am(tc));  
    
    % Solve for surface vortex sheet strength
    gam = A\b; 
    gam_am = A\b_am;

    %uv_vec = testUV(alpha(tc+1), pos, np, gam, chord);
    
    totalBoundCirc(tc+1) = totalBoundCirculation(LEVortex, TEVortex, gam, np);
    totalBoundCirc_am(tc+1) = totalBoundCirculation(LEVortex, TEVortex, gam_am, np);
    
    if solveForces == 1
        [lift(tc+1), drag(tc+1), Ix(tc+1), Iy(tc+1), Ixf(tc+1), Iyf(tc+1), Ixb(tc+1), Iyb(tc+1)] = Forces(dt, alpha(tc+1), xygFSVortex_rel, xyBoundVortex_rel, gam, Ix(tc), Iy(tc), Ixf(tc), Iyf(tc), Ixb(tc), Iyb(tc));
        [lift_am(tc+1), ~, Ix_am(tc+1), Iy_am(tc+1), ~,~, Ixb_am(tc+1), Iyb_am(tc+1)] = Forces(dt, alpha(tc+1), [], xyBoundVortex_rel, gam_am, Ix_am(tc), Iy_am(tc), 0, 0, Ixb_am(tc), Iyb_am(tc));  %added mass
        
        if (t>startOptimiseTime) && (Optimise == 1) && (optimisationFlag == 0)
            optimisationFlag = 1;
            targetLift = (lift(tc)+lift(tc-1)+lift(tc-2))/3;
        end
          
        deltaLift = targetLift - lift(tc+1);
        alpha_dLift_vec(tc,iterationCounter+1,:) = [alpha(tc+1),deltaLift]; %--------------------------------------------------------

    end
    
    itToc = toc;
    disp(['simTime=',num2str(t),',  iteration=',num2str(iterationCounter), ',  itTime=',num2str(itToc-prevToc)]);
    prevToc = itToc; 
         
 
    iterationCounter = iterationCounter + 1;
    if (abs(deltaLift)< maxError) || (optimisationFlag == 0) % delta lift to be sent to an appropriate value for the problem
        if (mod(tc,frames) == 0 || t == dt) && Plot == 1
            [M,h] = streamfunctionPlotting(M, h, xm, ym, nx, ny, alpha(tc+1), pos(tc+1,:), vel(tc+1,:), gam, xygFSVortex_rel, np, t, dt, Streamlines);
        end
        if (t > stopOptimiseTime) && (Optimise == 1)
           optimisationFlag = 2; 
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % for testing what the lift-alpha plots look like
        %if optimisationFlag == 1 && t == 0.516
        %    plotLiftAlpha(alpha_dLift_vec, tc);
        %end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Trailing edge vortex is released, wake moves with flow
        [xygFSVortex_rel] = biotSavart(LEVortex, TEVortex, dt, np, vel(tc+1,:), alpha(tc+1), alphaDot(tc+1), xyBoundVortex_rel, gam, xygFSVortex_rel);
        tc = tc + 1;
        iterationCounter = 0;
    end
    
end



toc
if solveForces == 1 && plotLiftCoef == 1
    plotForces(lift, lift_am, LEVortex, alpha, alphaDot, pos, vel, dt);
end
if plotAoA == 1
    plotAlpha(alpha, alphaDot, LEVortex, pos, dt);
end
if plotTranslation == 1
    plotKinematics(dt,pos,vel);
end

[M,h] = streamfunctionPlotting(M, h, xm, ym, nx, ny, alpha(tc), pos(tc,:), vel(tc,:), gam, xygFSVortex_rel, np, t, dt, Streamlines);





