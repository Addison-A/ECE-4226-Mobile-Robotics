%-------------------------------------------------------------
% Created: 8/31/2010 by William J. Ebel
%
% Revision History: None
%
% Purpose: This function constructs a sampled periodic (continuous-time) 
%   sawtooth signal where the user inputs are the period T0, the time
%   between samples T, and the number of periods N.
%
% Variables created: 
%   t0  - center of the pi-function
%   tau - width of the pi-function
%   t   - time vector
%   x   - samples vector of the pi-function
%-------------------------------------------------------------
clear; close all; clc;   % clearing all environment variables

disp('* generating a pi-function spanning [0,2]')

t0 = 1;
tau = 2;

t = -4:0.001:4;
x = pif((t-t0)/tau);
