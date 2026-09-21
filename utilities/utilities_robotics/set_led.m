%--------------------------------------------------------------------------
% Created:  8/4/26 by William J. Ebel (all rights reserved)
% 
% Revision History: 
%      Date     Reason
%
% Purpose: This function sets the robot LED's.  There are three different
%   modes as indicated in the table below
%       mode   description
%        0     set the LED's ON/OFF pattern according to input 'val'
%        1     flash LED's indicated by the unity bits in 'val'
%        2     light the LED's according to the acoustic ranger distance
%              with 1" for LED #1 up to 6" for LED #6 and all LED's else
%        3     light the LED's using a binary pattern according to the
%              acoustic ranger distance (0"-63")
%   Notes:
%        1. the maximum ranger distance appears to be 44"
%        2. the flashing LED's take precedence over the set LED's
%        3. mode 0 resets the flashing LED's so none are flashing
%        4. the arduino interprets the command as an LED command because
%           the first argument is 126.  This can be adapted for more
%           functionality by using a first argument of 127 or 128
%
% Variables:
%   sobj - arduino object
%   val  - the LED control value according to the integer binary pattern
%   mode - determines how to interpret the input 'val' and how the arduino
%          will light the LED's
%
% function set_led(sobj,val,mode)
%--------------------------------------------------------------------------
function set_led(sobj,val,mode)

if nargin == 0
  fprintf("\n*** The set_led function for the ECE1001 Intro to ECE course.\n");
  fprintf("It takes the following form:\n\n")
  fprintf("      set_led(sobj,val,mode);\n\n")
  fprintf("where 'sobj' is the serial port object\n");
  fprintf("where 'val' is the LED bit pattern\n");
  fprintf("where 'mode' directs the arduino how to light the LED's\n");
  fprintf("The 'mode' input is optional and defaults to zero if omitted.\n");
  fprintf("This function has no output arguments\n\n");
  return;
end

if nargin < 3;  mode = 0;  end

% cause the serial_receive function to interpret val as an LED command
cmd1 = 126;

% add the LED mode to the parameter 'val'
if mode == 0
  cmd2 = val;          % bits 8,7 = 0 ... LEDstate = 0 (set led)
elseif mode == 1
  cmd2 = val + 64;     % bits 8,7 = 1 ... LEDstate = 0 (flash led's)
elseif mode == 2
  cmd2 = 128;          % bits 8,7 = 2 ... LEDstate = 1 (1"/LED #)
elseif mode == 3
  cmd2 = 128 + 64;     % bits 8,7 = 3 ... LED binary pattern for range
else
  fprintf(2,"\n*** ERROR in set_led.  The 3 parameter must be a 0, 1, 2, or 3.\n")
  fprintf(2,"   ... 3rd parameter is: \n");
  disp(mode);
  fprintf(2,"\n");
end

%fprintf("inside set_led:  cmd1(%d)  cmd2(%s)    cmdbits: %d\n",cmd1,dec2bin(cmd2,8),bitshift(cmd2,-6));

% Create the serial port command string and send it across the serial port
command = [char(hex2dec('55')), char(cmd1), char(cmd2), char(hex2dec('AA'))];
write(sobj,command,"char");

end