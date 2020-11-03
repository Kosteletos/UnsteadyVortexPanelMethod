function [Lift, Drag, Ix, Iy] = Forces(dt, alpha_rad, rho, xygFSVortex_rel, xyBoundVortex_rel, gam, IxPrev, IyPrev)

Ix = 0; Iy = 0;

% Note vorticity = 2*angular velocity

% Free Stream Vortices
[noFreeVortices,~] = size(xygFSVortex_rel);
if noFreeVortices ~= 0
    Ix = Ix + sum(xygFSVortex_rel(:,2).*xygFSVortex_rel(:,3))/2;
    Iy = Iy + sum(xygFSVortex_rel(:,1).*xygFSVortex_rel(:,3))/2;
end

% Bound Vorticity
Ix = Ix + sum(xyBoundVortex_rel(:,2).*gam)/2;
Iy = Iy + sum(xyBoundVortex_rel(:,1).*gam)/2;

Fx = -rho*(Ix - IxPrev)/dt;
Fy = -rho*(Iy - IyPrev)/dt;

% Transform into inertial frame
trans = [sin(alpha_rad), cos(alpha_rad); cos(alpha_rad), sin(alpha_rad)];

Force = trans*[Fx;Fy];
Lift = Force(1);
Drag = Force(2);

end

