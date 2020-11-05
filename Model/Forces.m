function [Lift, Drag, Ix, Iy, cl] = Forces(dt, alpha_rad, rho, xygFSVortex_rel, xyBoundVortex_rel, gam, IxPrev, IyPrev, vel, chord)

Ix = 0; Iy = 0;

% Note vorticity = 2*angular velocity

% Free Stream Vortices
[noFreeVortices,~] = size(xygFSVortex_rel);
if noFreeVortices ~= 0
    Ix = Ix + sum(xygFSVortex_rel(:,2).*xygFSVortex_rel(:,3));
    Iy = Iy + sum(xygFSVortex_rel(:,1).*xygFSVortex_rel(:,3));
end

% Bound Vorticity
Ix = Ix + sum(xyBoundVortex_rel(:,2).*gam);
Iy = Iy + sum(xyBoundVortex_rel(:,1).*gam);

Fx = -rho*(Ix - IxPrev)/dt;
Fy = -rho*(Iy - IyPrev)/dt;

% Transform into inertial frame
trans = [sin(alpha_rad), cos(alpha_rad); cos(alpha_rad), sin(alpha_rad)];

Force = trans*[Fx;Fy];
Lift = Force(1);
Drag = Force(2);

cl = Lift/(0.5*rho*0.32257467^2*chord);

end

