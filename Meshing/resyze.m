function [xsin,ysin] = resyze(xshr,yshr)
%
%  [xsin,ysin] = resyze(xshr,yshr)
%
%  Takes section of arbitrary chord, at arbitrary angle, and scales/rotates
%  to unit chord and zero incidence.
%  NB! Trailing edge point must be at (1,0).
%

% locate leading edge (point furthest from TE at (1,0))
rte = sqrt((xshr-1).^2 + yshr.^2);
indle = find(rte==max(rte));
indle = indle(1);  % in case of double match
cawd = rte(indle);

% scale section to unit chord, with TE moved to (0,0)
x1 = (xshr-1)/cawd;
y1 = yshr/cawd;

% rotate section to zero incidence
coz = -x1(indle);
zin = y1(indle);
rotmat = [coz zin; -zin coz];
x2y2 = [x1(:) y1(:)] * rotmat;

% extract separate x and y vectors, and relocate TE to (1,0)
xsin = x2y2(:,1) + 1;
ysin = x2y2(:,2);
