function [ipstag fracstag] = find_stag(gam)
%
%  function [ipstag fracstag] = find_stag(gam)
% 
%    Locates stagnation panel - ipstag - and fractional distance along panel
%  (in anti-clockwise direction) of stagnation point - fracstag.
%

is = 1;

while gam(is)*gam(is+1) > 0
  is = is + 1;
end

ipstag = is;
fracstag = -gam(ipstag)/(gam(ipstag+1)-gam(ipstag));

