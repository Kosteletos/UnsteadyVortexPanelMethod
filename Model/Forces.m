function [Lift, Drag, Ix, Iy, Ixf, Iyf, Ixb, Iyb, cl] = Forces(dt, alpha_rad, xygFSVortex_rel, xyBoundVortex_rel, gam, IxPrev, IyPrev, IxfPrev, IyfPrev, IxbPrev, IybPrev)

global chord rho

Ixb = 0; Iyb = 0; % bound
Ixf = 0; Iyf = 0; % free-stream

% Transform into inertial frame
trans = [sin(alpha_rad), cos(alpha_rad); cos(alpha_rad), sin(alpha_rad)];

% Note vorticity = 2*angular velocity

% Free Stream Vortices
[noFreeVortices,~] = size(xygFSVortex_rel);
if noFreeVortices ~= 0
    Ixf = sum(xygFSVortex_rel(:,2).*xygFSVortex_rel(:,3));
    Iyf = sum(xygFSVortex_rel(:,1).*xygFSVortex_rel(:,3));
end


% Bound Vorticity
Ixb = sum(xyBoundVortex_rel(:,2).*gam);
Iyb = sum(xyBoundVortex_rel(:,1).*gam);

%%
% Added Mass
Fxb = -rho*(Ixb - IxbPrev)/dt;
Fyb = -rho*(Iyb - IybPrev)/dt;

Forceb = trans*[Fxb;Fyb];
Liftb = Forceb(1);
% Circulatory
Fxf = -rho*(Ixf - IxfPrev)/dt;
Fyf = -rho*(Iyf - IyfPrev)/dt;

Forcef = trans*[Fxf;Fyf];
Liftf = Forcef(1);


LiftComponents = [Liftb, Liftf];

%%
% Total
Ix = Ixb + Ixf;
Iy = Iyb + Iyf;

Fx = -rho*(Ix - IxPrev)/dt;
Fy = -rho*(Iy - IyPrev)/dt;

Force = trans*[Fx;Fy];
Lift = Force(1);
Drag = Force(2);

cl = Lift/(0.5*rho*0.32257467^2*chord);

end

