function [cp, TotalCirc, FinalPanelCirc] = potential_op ( xs, ys, gam )
%
%  function [cp circ] = potential_op ( xs, ys, gam )
%
%    Post-processing function for potential calculation.  Returns surface
%  pressure coefficient array and overall circulation.
%

np = length(xs) - 1;

TotalCirc = 0;

for ip = 1:np

  cp(ip) = 1 - gam(ip)^2;

  dels = sqrt((xs(ip+1)-xs(ip))^2 + (ys(ip+1)-ys(ip))^2);
  TotalCirc = TotalCirc  +  dels * (gam(ip)+gam(ip+1))/2;

end

cp(np+1) = 1 - gam(np+1)^2;

dels = sqrt((xs(np+1)-xs(np))^2 + (ys(np+1)-ys(np))^2);
FinalPanelCirc = dels * (gam(np)+gam(np+1))/2;
