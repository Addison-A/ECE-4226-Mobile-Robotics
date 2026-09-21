%--------------------------------------------------------------------------
% Created:  8/4/26 by William J. Ebel (all rights reserved)
% 
% Revision History: 
%      Date     Reason
%
% Purpose: This function sets the pulse width for the servo used in the
%   ECE1001 robot.  The input parameter 'val' must be in the range [0,35].
%   Caution must be exercised in operating the servo beyond it's desired
%   range, so operating below 4 or higher than 31 might damage the servo.
%
% Variables:
%   sobj - arduino object
%   val  - the servo pulse width command, range [0,35].  
%
% function set_servo(sobj,val,mode)
%--------------------------------------------------------------------------
function set_servo(sobj,val)

if nargin == 0
  fprintf("\n*** The set_servo function takes the following form:\n\n")
  fprintf("      set_servo(sobj,val);\n\n")
  fprintf("where 'sobj' is the serial port object\n");
  fprintf("where 'val' is the servo angle value, range [0,35]\n");
  fprintf("This function has no output arguments\n\n");
  return;
end

% cause the serial_receive function to interpret val as a SERVO command
cmd1 = 127;
val = round(val);

% Create the serial port command string and send it across the serial port
command = [char(hex2dec('55')), char(cmd1), char(val), char(hex2dec('AA'))];
write(sobj,command,"char");

end