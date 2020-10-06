function [A] = buildLHS(xyCollocation, xyBoundVortex, normal, np)
%Build LHS of matrix A.gam = b

A = zeros(np);

for i = 1:np
    for j = 1:np
        uv = inducedVelocity(1,xyCollocation(i,:),xyBoundVortex(j,:));
        A(i,j) = dot(uv,normal);
    end
end


end

