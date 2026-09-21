%--------------------------------------------------------------------------
% Author: William J. Ebel
% Created: 3/19/2022
% Revision History: none
%
% Purpose: This script stops the motors from running.  There is a brief
% moment when the motors are run backwards in order to counteract the robot
% momentum.  This will not cause the motor to run backwards, rather it will
% sap the momentum of the robot so that when the wheels are stopped, the
% robot doesn't continue to move forward.  
%--------------------------------------------------------------------------
if ~exist('sobj','var')
  fprintf(2,"\n*** ERROR in stop.  The serial object does not exist.\n\n");
else
  if ~isa(sobj,'internal.Serialport')
    fprintf(2,"\n*** ERROR in stop.  The variable 'sobj' is not a serial port.\n\n");
    return;
  else
    set_speed(sobj,0,0);
  end
end