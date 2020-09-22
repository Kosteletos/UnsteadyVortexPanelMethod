%    foil.m
%
%  Script to analyse an aerofoil section using potential flow calculation
%  
%

clear all

global Re

%  Read in the parameter file
caseref = input('Enter initial body geometry: ','s');
secfile = ['BodyGeom/' section '.surf'];
fprintf(1, '%s\n\n', ['Reading in geometry file: ' secfile])
[xk yk] = textread ( secfile, '%f%f' );

