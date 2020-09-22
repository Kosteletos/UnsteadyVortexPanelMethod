%    foil.m
%
%  Script to analyse an aerofoil section using potential flow calculation
%  
%

clear all

global Re

%  Read in the parameter file
caseref = input('Enter case reference: ','s');
parfile = ['Parfiles/' caseref '.txt'];
fprintf(1, '%s\n\n', ['Reading in parameter file: ' parfile])
[section np Re alpha] = par_read(parfile);

%  Read in the section geometry
secfile = ['Geometry/' section '.surf'];
[xk yk] = textread ( secfile, '%f%f' );

%  Generate high-resolution surface description via cubic splines
nphr = 5*np;
[xshr yshr] = splinefit ( xk, yk, nphr );

%  Resize section so that it lies between (0,0) and (1,0)
[xsin ysin] = resyze ( xshr, yshr );

%  Interpolate to required number of panels (uniform size)
[xs ys] = make_upanels ( xsin, ysin, np );

%  Assemble the lhs of the equations for the potential flow calculation
A = build_lhs ( xs, ys );
Am1 = inv(A);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%DELETE  THIS%%%%%%%%%%%%%%%%%%%%%%%%%%%%
separation_upper = zeros(1,length(alpha));
separation_lower = zeros(1,length(alpha));
transition_upper = zeros(1,length(alpha));
transition_lower = zeros(1,length(alpha));
lam_separation_upper = zeros(1,length(alpha));
lam_separation_lower = zeros(1,length(alpha));
turb_reattachment_upper = zeros(1,length(alpha));
turb_reattachment_lower = zeros(1,length(alpha));



%  Loop over alpha values
for nalpha = 1:length(alpha)

%    rhs of equations
  alfrad = pi * alpha(nalpha)/180;
  b = build_rhs ( xs, ys, alfrad );

%    solve for surface vortex sheet strength
  gam = Am1 * b;
  
%    calculate cp distribution and overall circulation
  [cp circ] = potential_op ( xs, ys, gam );

%    locate stagnation point and calculate stagnation panel length
  [ipstag fracstag] = find_stag(gam);
  dsstag = sqrt((xs(ipstag+1)-xs(ipstag))^2 + (ys(ipstag+1)-ys(ipstag))^2);
  
%%%%%%%%%%%%%%%% Streamline plotting function: comment out to run fast
if alpha(nalpha) == 7
   streamfunction_plotting_rotated(gam,xs,ys,alfrad, ipstag);
end
%%%%%%%%%%%%%%%%

%    upper surface boundary layer calc

%    first assemble pressure distribution along bl
  clear su cpu
  su(1) = fracstag*dsstag;
  cpu(1) = cp(ipstag);
  for is = ipstag-1:-1:1
    iu = ipstag - is + 1;
    su(iu) = su(iu-1) + sqrt((xs(is+1)-xs(is))^2 + (ys(is+1)-ys(is))^2);
    cpu(iu) = cp(is);
  end

%    check for stagnation point at end of stagnation panel
  if fracstag < 1e-6
    su(1) = 0.01*su(2);    % go just downstream of stagnation
    uejds = 0.01 * sqrt(1-cpu(2));
    cpu(1) = 1 - uejds^2;
  end

%    boundary layer solver
  [iunt iuls iutr iuts delstaru thetau] = bl_solv ( su, cpu );

%    lower surface boundary layer calc

%    first assemble pressure distribution along bl
  clear sl cpl
  sl(1) = (1-fracstag) * dsstag;
  cpl(1) = cp(ipstag+1);
  for is = ipstag+2:np+1
    il = is - ipstag;
    sl(il) = sl(il-1) + sqrt((xs(is-1)-xs(is))^2 + (ys(is-1)-ys(is))^2);
    cpl(il) = cp(is);
  end

%    check for stagnation point at end of stagnation panel
  if fracstag > 0.999999
    sl(1) = 0.01*sl(2);    % go just downstream of stagnation
    uejds = 0.01 * sqrt(1-cpl(2));
    cpl(1) = 1 - uejds^2;
  end

%    boundary layer solver
  [ilnt ills iltr ilts delstarl thetal] = bl_solv ( sl, cpl );

%    lift and drag coefficients
  [Cl Cd] = forces ( circ, cp, delstarl, thetal, delstaru, thetau );

%    copy Cl and Cd into arrays for alpha sweep plots

  clswp(nalpha) = Cl;
  cdswp(nalpha) = Cd;
  lovdswp(nalpha) = Cl/Cd;

%    screen output

  disp ( sprintf ( '\n%s%5.3f%s', ...
                   'Results for alpha = ', alpha(nalpha), ' degrees' ) )

  disp ( sprintf ( '\n%s%5.3f', '  Lift coefficient: ', Cl ) )
  disp ( sprintf ( '%s%7.5f', '  Drag coefficient: ', Cd ) )
  disp ( sprintf ( '%s%5.3f\n', '  Lift-to-drag ratio: ', Cl/Cd ) )

  upperbl = sprintf ( '%s', '  Upper surface boundary layer:' );
  if iunt~=0
    is = ipstag + 1 - iunt;
    upperbl = sprintf ( '%s\n%s%5.3f', upperbl, ... 
                        '    Natural transition at x = ', xs(is) );
    transition_upper(nalpha) = xs(is);
     
  end
  if iuls~=0
    is = ipstag + 1 - iuls;
    upperbl = sprintf ( '%s\n%s%5.3f', upperbl, ... 
                        '    Laminar separation at x = ', xs(is) );
    lam_separation_upper(nalpha) = xs(is);
    if iutr~=0
      is = ipstag + 1 - iutr;
      upperbl = sprintf ( '%s\n%s%5.3f', upperbl, ... 
                          '    Turbulent reattachment at x = ', xs(is) );
    turb_reattachment_upper(nalpha) = xs(is);
    end
  end
  if iuts~=0
    is = ipstag + 1 - iuts;
    upperbl = sprintf ( '%s\n%s%5.3f', upperbl, ... 
                        '    Turbulent separation at x = ', xs(is) );
    separation_upper(nalpha) = xs(is);
  end
  upperbl = sprintf ( '%s\n', upperbl );
  disp(upperbl)

  lowerbl = sprintf ( '%s', '  Lower surface boundary layer:' );
  if ilnt~=0
    is = ipstag + ilnt;
    lowerbl = sprintf ( '%s\n%s%5.3f', lowerbl, ... 
                        '    Natural transition at x = ', xs(is) );
    transition_lower(nalpha) = xs(is);
  end
  if ills~=0
    is = ipstag + ills;
    lowerbl = sprintf ( '%s\n%s%5.3f', lowerbl, ... 
                        '    Laminar separation at x = ', xs(is) );
    lam_separation_lower(nalpha) = xs(is);
    if iltr~=0
      is = ipstag + iltr;
      lowerbl = sprintf ( '%s\n%s%5.3f', lowerbl, ... 
                          '    Turbulent reattachment at x = ', xs(is) );
    turb_reattachment_lower(nalpha) = xs(is);
    end
  end
  if ilts~=0
    is = ipstag + ilts;
    lowerbl = sprintf ( '%s\n%s%5.3f', lowerbl, ... 
                        '    Turbulent separation at x = ', xs(is) );
    separation_lower(nalpha) = xs(is);
  end
  lowerbl = sprintf ( '%s\n', lowerbl );
  disp(lowerbl)

%    save data for this alpha
  fname = ['Data/' caseref '_' num2str(alpha(nalpha)) '.mat'];
  save ( fname, 'Cl', 'Cd', 'xs', 'cp', ...
         'sl', 'delstarl', 'thetal', 'lowerbl', ...
         'su', 'delstaru', 'thetau', 'upperbl' )

end

%  save alpha sweep data in summary file

fname = ['Data/' caseref '.mat'];
save ( fname, 'xs', 'ys', 'alpha', 'clswp', 'cdswp', 'lovdswp','separation_upper','separation_lower','transition_upper','transition_lower','lam_separation_upper','lam_separation_lower','turb_reattachment_upper','turb_reattachment_lower')