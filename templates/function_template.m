%-------------------------------------------------------------
% Created: 8/31/2010 by William J. Ebel
%
% Revision History: None
%
% Purpose: This function constructs a sampled periodic (continuous-time) 
%   sawtooth signal where the user inputs are the period T0, the time
%   between samples T, and the number of periods N.
%
% Variables: 
%   A  - peak value of the triangle waveform
%   T0 - signal period
%   T  - time between samples
%   N  - Number of periods to generate (can be fractional)
%   y  - output samples vector (paired with tm)
%   
% function [ty,y] = function_template(A,T0,T,N)
%-------------------------------------------------------------
function [ty,y] = function_template(A,T0,T,N)

% Default the output variables
ty = []; y = [];

% check the input variables
if T0 < 0
  fprintf(2,'*** ERROR in function_template.  The period T0 cannot be negative. \n');
  return;
end

% Construct the output time and sample vectors
Npts = floor(N*T0/T)+1;
ty = (0:Npts-1)*T;
tmmod = mod(ty,T0);    % Fold the time vector into a single period

...

y  = ...

end
