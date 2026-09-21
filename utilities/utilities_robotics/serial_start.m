%--------------------------------------------------------------------------
% Created: 1/13/2017  by William J. Ebel
%
% Revision History: 
%     date     reason
%    8/27/23   modified to eliminate the serial_reset function which is
%              being deprecated in matlab.
%    10/3/23   Eliminated the call to initialize get_serial_data which is
%              no longer needed. 
%     9/15/26  Modified to make it work faster
%
% Purpose: This script creates an object that is connected to the serial
%   port.
%
% Operation:  The COM port for the Arduino must be known and hardcoded into
%   this script as the first executable line.  Start by letting port be an
%   empty string.  The serial ports will be listed and the one connected to
%   the Arduino needs to be set. 
%     One way to find the port is to open the Arduino code and look
%   to see which port the Arduino IDE connects to for the ATmega328P.
%--------------------------------------------------------------------------
port = 'COM4';    % use this for the office laptop, ECE4226
%port = 'COM14';    % use this for the office laptop, ECE1001
%port = 'COM9';     % use this for the classroom laptop, ECE4226

% ECE4226 com ports for robots
%port = 'COM10';   % robot #1
%port = 'COM11';   % robot #2
%port = 'COM20';   % robot #3
%port = 'COM13';   % robot #4
%port = 'COM15';   % robot #5
%port = 'COM20';   % robot #6
%port = 'COM17';   % robot #7
%port = 'COM18';   % robot #8
%port = 'COM19';   % robot #9

%-------------------------------
% find all the serial ports and check to make sure 'port' is available
p = serialportlist('all');

if isempty(port)
  fprint(2,'\n*** WARNING in serial_start.  Choose a serial port from the list below: \n');
  disp(p)
  fprint(2,'\n');
  return;
end

%port = upper(port);
if isempty(find(p == port,1))
  fprintf(2,'\n*** ERROR in serial_start.  The com port %s is not found \n\n',port);
  fprintf(2,"  execute the following command twice, with and without the robot serial port plugged in.\n");
  fprintf(2,"      >> serialportlist('all')\n");
  fprintf(2,"  leave off the ';' character at the end so the serial ports are displayed.\n");
  fprintf(2,"  Find the serial port that changes and that is the one for the robot.\n");
  fprintf(2,"  Place that serial port in serial_start at the top.\n");
  return;
elseif exist('sobj','var')
  ok = false;
  if ~isa(sobj,'internal.Serialport')
    fprintf(2,'\n*** WARNING in serial_start.  The variable sobj is not a serial port ... overwriting \n\n');
    clear sobj;
    sobj = serialport(port,57600);
    ok = true;
  else
    serial_isrunning;
    if ~serialflg;  return;  end
  end
else
  disp('* serial_start:  starting the serial object');
  sobj = serialport(port,57600);
  ok = true;
end

try
  N = sobj.NumBytesAvailable;
  if N > 0
    fprintf("* serial_start:  flushing %d bytes from the serial port buffer\n",N);
    read(sobj,N,'char');
  end
catch
  fprintf(2,"\n*** ERROR in serial_start.  The serial port object 'sobj' is not valid.\n");
  fprintf(2,"   ...  try clearing it by executing the following statement:\n\n");
  fprintf(2,"        >> clear sobj\n\n");
  fprintf(2,"   ...  then try again.\n\n");
  return;
end

serial_isrunning;
if ~serialflg
  fprintf(2,"\n... go through the following:  \n\n");
  fprintf(2,"  1. Verify that the COM port is correct in serial_start.  \n");
  fprintf(2,"     Find your COM port by executing the following command, with and without the robot plugged in.\n");
  fprintf(2,"        >> serialportlist('all')\n");
  fprintf(2,"     leave off the ';' character at the end so the serial ports are displayed.\n");
  fprintf(2,"\n  2. try clearing the sobj object by typing:\n");
  fprintf(2,"        >> clear sobj\n");
  fprintf(2,"     then unplug the robot USB from the computer, replug it back in and try again.\n");
  fprintf(2,"\n  3. try resetting the ATmega328P by pressing the reset button. \n");
  fprintf("\n");
end