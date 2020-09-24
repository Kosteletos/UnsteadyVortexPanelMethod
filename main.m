%    foil.m
%
%  Script to analyse an aerofoil section using potential flow calculation
%  
%

clear all
addpath(genpath(pwd))

%  Read in the parameter file
%caseref = input('Enter case reference: ','s');
%parfile = ['Parfiles/' caseref '.txt'];
parfile = ['Parfiles/FlatPlate.txt'];
%parfile = ['Parfiles/test.txt'];
fprintf(1, '%s\n\n', ['Reading in parameter file: ' parfile])
[section, np, Re, alpha_deg, nt] = par_read(parfile);

%  Read in the section geometry
secfile = ['BodyGeom/' section '.surf'];
[xk, yk] = textread ( secfile, '%f%f' );

xfsVortex = [];
yfsVortex = [];
gamfsVortex = [];

%Generate flat plate surface description:
xs = linspace(0,1,np);
ys = zeros(1,np);

dt = 1;
for t = 1:nt 
    %  Assemble the lhs of the equations for the potential flow calculation
    A = build_lhs ( xs, ys );
    Am1 = inv(A);


    %    rhs of equations
    alpha_rad = pi * alpha_deg/180;
    b = build_rhs ( xs, ys, alpha_rad );

    %    solve for surface vortex sheet strength
    gam = Am1 * b;

    %    calculate cp distribution and overall circulation
    [cp, TotalCirc, FinalPanelCirc] = potential_op ( xs, ys, gam );

    [xfsVortex, yfsVortex, gamfsVortex] = BiotSavart(FinalPanelCirc, xs, ys, xfsVortex, yfsVortex, gamfsVortex);

    %    locate stagnation point and calculate stagnation panel length
    [ipstag, fracstag] = find_stag(gam);
    dsstag = sqrt((xs(ipstag+1)-xs(ipstag))^2 + (ys(ipstag+1)-ys(ipstag))^2);

    streamfunction_plotting(gam, xs, ys, alpha_rad,ipstag);
end
