%--------------------------------------------------------------------------
% Created by:  Addison P. Aque  on 9/28/26
%
% Revision history:
%      Date     Reason
% 
% Purpose:  This script is used to optimize the line-position estimate and
% estimate the current line position using the normalized amin vector.
%
% Important Variables:  
%    aV     - normalized sensor data
%    s      - sum of the sensor data
%    x      - singular value representing the position of the reflectance
%               sensor array
% 
% function x = get_line_position(aV);
%--------------------------------------------------------------------------
function x = get_line_position(aV)

%aV = [400 250 250 250 250 250 250 400];

% can i use dV to get the raw sensor data?
% might also be able to use show_serial_data to generate these values

s = max(1,sum(aV));

switch numel(aV)
    case 2, x = (-50*aV(1) + 50*aV(2))/s;
    case 4, x = (-150*aV(1) + -50*aV(2) + 50*aV(3) + 150*aV(4))/s;
    case 6, x = (-250*aV(1) + -150*aV(2) + -50*aV(3) + 50*aV(4) + ...
                    150*aV(5) + 250*aV(6))/s;
    case 8, x = (-350*aV(1) + -250*aV(2) + -150*aV(3) + -50*aV(4) + ...
                    50*aV(5) + 150*aV(6) + 250*aV(7) + 350*aV(8))/s;
    otherwise, error('aV must be of length 2, 4, 6, or 8')
end
    


%x = (-350*aV(1) + -250*aV(2) + -150*aV(3) + -50*aV(4) + 50*aV(5) + 150*aV(6) + 250*aV(7) + 350*aV(8))/s;

%so far this works all th time and is fully implemented for 8 sensor
%values... how dod i get it to optimally only read 2,4,6, or 8 sensors and
%from the center?

% write code that calcs the line position and stores it in a vectoraV

% check to see if aV is either a length of 2, 4, 6, or 8


% if fewer than 8 values, then assume the line is centered aroudn the
% middle


% use class notes as a guideline


% 
% x =
% 
%    16.0296
% 
%   35 |  0.00  -0.00  |    0     0     0  1742  3386     0     0     0 |  5128    16 |  26.0 |  1.02   29.2
% 
% 
