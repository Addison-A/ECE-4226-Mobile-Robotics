%--------------------------------------------------------------------------
% Author: William J. Ebel
% Created: 4/12/2022
% Revision History: 
%      Date     Reason
%     9/22/23   Modified the motor speed range to go over [-125,125].  This
%               makes this code consistent with the arduino code the
%               students used in a previous project.
%
% Purpose: This function converts motor speed parameters, both left and
%   right, into characters and sends them down the serial port to the
%   arduino.  The arduino processor monitors the serial port and expects
%   data to be passed to it in a way that is synchronized with this
%   function.   
%
% Variables:
%   sobj - arduino object
%   SL - LEFT motor speed, range [-125,125]
%   SR - RIGHT motor speed, range [-125,125]
%
% function speed_set(sobj,SL, SR)
%--------------------------------------------------------------------------
function set_speed(sobj,SL,SR)

if nargin == 0
  fprintf("\nSet the speed of the motors.\n");
  fprintf("This function takes the following form:\n\n");
  fprintf("      set_speed(sobj,SL,SR);\n\n");
  fprintf("where 'sobj' is the serial port object\n");
  fprintf("where 'SL' is the  left motor speed, range [-125,125]\n");
  fprintf("where 'SR' is the right motor speed, range [-125,125]\n");
  fprintf("\n");
  return;
end

if nargin < 3
  set_speed(sobj,0,0);
  fprintf(2,"\n*** ERROR in set_speed.  One or both of the motor speeds are not found.\n");
  fprintf(2,"   ... stopping the robot and exiting.\n\n");
  return;
end

if isempty(SL) || isempty(SR)
  fprintf(2,"\n*** ERROR in set_speed.  One or both of the motor speeds is empty.\n");
  fprintf(2,"   ... stopping the robot and returning.\n\n");
  set_speed(sobj,0,0);
  return;
end

if SL > 125
  SL = 125;
  fprintf(2,"\n*** WARNING in set_speed.  The LEFT motor speed must be in the range [-125,125].\n\n");
end

if SL < -125
  SL = -125;
  fprintf(2,"\n*** WARNING in set_speed.  The LEFT motor speed must be in the range [-125,125].\n\n");
end

if SR > 125
  SR = 125;
  fprintf(2,"\n*** WARNING in set_speed.  The RIGHT motor speed must be in the range [-125,125].\n\n");
end

if SR < -125
  SR = -125;
  fprintf(2,"\n*** WARNING in set_speed.  The RIGHT motor speed must be in the range [-125,125].\n\n");
end

if SL < 0;  SL = 256+SL;  end
if SR < 0;  SR = 256+SR;  end

% Create the serial port command string and send it across the serial port
command = [char(hex2dec('55')), char(SL), char(SR), char(hex2dec('AA'))];
write(sobj,command,"char");

end