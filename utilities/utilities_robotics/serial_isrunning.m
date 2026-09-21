%--------------------------------------------------------------------------
% Created: 10/3/23 by William J. Ebel
% 
% Revision History: 
%     date     reason
%     9/15/26  Modified to make it work faster
%
% Purpose: This function determines if the serial port is actually running
%   or not by checking to see if the available data is growing.  If it is
%   not then the serial port is not running, or perhaps the wrong serial
%   port has been defined in the serial_start script.    
%   
% Variables:
%   sobj      : serial port object started by the 'serial_start' script
%   serialflg : 1 = serial port is running, 0 = not running
%
% function runflg = serial_isrunning(sobj)
%--------------------------------------------------------------------------
%function runflg = serial_isrunning(sobj)

serialflg = true;

if ~exist('sobj','var')
  serialflg = false;
  fprintf(2,"\n*** ERROR.  The variable 'sobj' is not found.  Please run serial_start.\n");
  return;
end

if ~isa(sobj,'internal.Serialport')
  serialflg = false;
  fprintf(2,"\n*** ERROR.  The variable 'sobj' is not a valid serial port object.\n");
end

% if the serial port is running, the available data bytes will grow
% try up to 10 seconds
if serialflg
  try
    t0 = tic;
    N = sobj.NumBytesAvailable;
    while N == 0
      pause(0.01);  drawnow;
      N = sobj.NumBytesAvailable;
      if toc(t0) > 10
        fprintf(2,"\n*** ERROR.  The serial port is NOT running.\n")
        serialflg = false;
        return;
      end
    end
    disp('  ... The serial port IS running.')
  catch err
    serialflg = false;
    fprintf(2,'\n*** ERROR.  The variable sobj is outdated or is not a valid serial port.\n');
    fprintf(2,'   ... try clearing it and execute serial_start again ...\n\n');
  end
end