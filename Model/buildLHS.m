function [A] = buildLHS(xyCollocation_rel, xyBoundVortex_rel, normal_rel, np)
%Build LHS of matrix A.gam = b

    gam = ones(length(xyBoundVortex_rel),1);
    [uv_x, uv_y] = inducedVelocityMat(gam,xyCollocation_rel,xyBoundVortex_rel);
    A = (uv_x.*normal_rel(1) + uv_y.*normal_rel(2)).';
    A(np+1,:) = ones(np+1,1);

end

