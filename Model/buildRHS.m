function [b] = buildRHS(V, normal, np)
%Build RHS of matrix A.gam = b
b = zeros([np,1]);

for i = 1:np
    uvFS = [V, 0];
    b(i) = -dot(uvFS, normal);
end

end

