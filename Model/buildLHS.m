function [A] = buildLHS(xyCollocation, xyBoundVortex, normal, np)
%Build LHS of matrix A.gam = b

A = zeros(np+1);

for i = 1:np
    for j = 1:np+1
        uv = inducedVelocity(1,xyCollocation(i,:),xyBoundVortex(j,:));
        A(i,j) = dot(uv,normal);
    end
end

A(np+1,:) = ones(np+1,1);

end

