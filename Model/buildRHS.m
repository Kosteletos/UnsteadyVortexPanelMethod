function [b] = buildRHS(V, alpha_rad, normal, np)
%Build RHS of matrix A.gam = b
b = zeros([np,1]);

for i = 1:np
    uvFS = [V*cos(alpha_rad), V*sin(alpha_rad)];
    b(i) = -dot(uvFS, normal);
end

end

