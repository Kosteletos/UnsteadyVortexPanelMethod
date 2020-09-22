function [xsin ysin] = splinefit(xk,yk,spline_flag)
%
%  function [xsin ysin] = splinefit(xk,y,spline_flag)
% 
%  Depending on spline_flag, produces either ppk*no. of knots or npin panel
%  surface description (xsin,ysin) via cubic spline fit with knots in
%  (xk,yk)
%
  
% parameter u is based on panel lengths
lens = sqrt((xk(2:end)-xk(1:end-1)).^2 + (yk(2:end)-yk(1:end-1)).^2);
u = [0; cumsum(lens)];

% generate uin......
if spline_flag == 1 % for saving to blade.xxx
    nk = length(u);
    ppk = 100; % points per knot
    for i = 1:(nk-1)
        ustart = ppk*(i-1) + 1;
        ufin = ppk*i + 1;
        uin(ustart:ufin) = linspace(u(i),u(i+1),ppk+1);
    end
elseif spline_flag == 0 % for plotting
    npin = 10000;
    uin = linspace(0,u(end),npin+1);
else
    npin = spline_flag;
    uin = linspace(0,u(end),npin+1);
end

% spline fits to x and y as functions of u
xsin = spline(u,xk,uin);
ysin = spline(u,yk,uin);

end