%--------------------------------------------------------------------------
% Created: 9/14/26 by William J. Ebel
% 
% Revision History: 
%       Date            Reason
% 
% Purpose: This function takes in a vector, dV0, from get_serial_data and
%   outputs a vector with the same length.  The output vector contains
%   modified values for calibration purposes.  This calibratoion includes:
%
%      1. normalized 'index' variable to start at 1
%      2. modified line-following sensor values to elminate the noise floor
%      3. conversion of ranger values into distance in units of inches
%      4. modified shaft encoder data to give an accumulated value in units
%         of revolutions 
% 
% Variables: 
%   dV0 - (input) the serial data (from get_serial_data)
%   dV  - (output) the serial data with modified values for calibration
%         purposes
%
% function dV = map_serial_data(dV0)
%--------------------------------------------------------------------------
function dV = map_serial_data(dV0)

persistent index0 La0 Ra0 Lang0 Rang0 Lakk Rakk

dV = [];
if nargin == 0
  fprintf("\nThis function maps raw serial port data into calibrated serial\n");
  fprintf("serial port data.  By 'calibrate' we mean that the loop index is normalized\n");
  fprintf("normalized to start at 1, that the line-following sensor array values\n");
  fprintf("have the noise floor removed, and that ranger data is converted to \n");
  fprintf("distance in units of inches\n\n");
  fprintf("The form of this function is:  \n\n");
  fprintf("    dV = map_serial_data(dV);\n\n");
  fprintf("where input 'dV' is a vector containing raw serial port data from\n");
  fprintf("  the 'get_serial_data' function. \n");
  fprintf("and where output 'dV' is a vector that is the same length but where\n");
  fprintf("one ore more values are modified for calibration purposes.\n\n");
  fprintf("This function must be initialized using the following syntax before\n");
  fprintf("using it in a loop.  The initialization syntax is:\n\n");
  fprintf("    map_serial_data('reset');\n\n");
  fprintf("\n");
  return;
end

if isequal(dV0,'reset')
  index0 = [];
  La0 = [];    Lang0 = [];
  Ra0 = [];    Rang0 = [];
  Lakk = 0;    Rakk = 0;
  return;
end

if isempty(dV0)
  fprintf(2,"*** ERROR in map_serial_data.  The input 'dV' vector is empty.\n");
  return;
end

if (length(dV0) ~= 12) && (length(dV0) ~= 9)
  fprintf(2,"*** ERROR in map_serial_data.  The input 'dV' vector is not the correct length.\n");
  return;
end


dV = dV0;

if isempty(index0)
  index0 = dV(1) - 1;
  Lakk = 0;  La0 = dV(2);  Lang0 = La0;
  Rakk = 0;  Ra0 = dV(3);  Rang0 = Ra0;
end


%----------------------
% map the index
dV(1) = dV(1) - index0;


%---------------------------- ECE 1001 ------------------------------------
if length(dV0) == 9
%    dV = [index Ltics Rtics Rmsec IRval a0 a1 a2 a3];

% map the shaft encoder angles into revolutions
  if dV(2)-Lang0 >  pi;  Lakk = Lakk - 1;  end
  if dV(2)-Lang0 < -pi;  Lakk = Lakk + 1;  end
  if dV(3)-Rang0 >  pi;  Rakk = Rakk - 1;  end
  if dV(3)-Rang0 < -pi;  Rakk = Rakk + 1;  end
  
  Ltics = dV(2) - La0;   Lrev = Ltics/300;
  Rtics = dV(3) - Ra0;   Rrev = Rtics/300;
  
  dV(2) = Lrev;
  dV(3) = Rrev;
  
% eliminate the noise floor of the 
  amin = [450 450 450 1300];
  a = dV(6:9);
  dV(6:9) = max(0,a-amin);
  
% map the AC ranger value
  ACval = dV0(4);
  dV(4) = (max(1,ACval/15)+5)/10;

% map the IR ranger value
  IRval = dV(5);
  p = [1 0];   % line of the form y = x (does not change IRval)
  dV(5) = polyval(p,IRval);


%---------------------------- ECE 4226 ------------------------------------
elseif length(dV0) == 12
%    dV = [index La Ra a0 a1 a2 a3 a4 a5 a6 a7 IRval];

% map the shaft encoder angles into revolutions
  if dV(2)-Lang0 >  pi;  Lakk = Lakk - 1;  end
  if dV(2)-Lang0 < -pi;  Lakk = Lakk + 1;  end
  if dV(3)-Rang0 >  pi;  Rakk = Rakk - 1;  end
  if dV(3)-Rang0 < -pi;  Rakk = Rakk + 1;  end
  
  Lang0 = dV(2);
  Rang0 = dV(3);
  
  Lang = dV(2) - La0 + Lakk*2*pi;
  Rang = dV(3) - Ra0 + Rakk*2*pi;
  
  dV(2) = Lang/(2*pi);
  dV(3) = Rang/(2*pi);

% eliminate the noise floor of the 
  amin = [600 350 350 350 350 350 350 600];
  a = dV(4:11);
  dV(4:11) = max(0,a-amin);

% map the IR ranger value
  IRval = dV(12);
  p = [1 0];   % line of the form y = x (does not change IRval)
  dV(12) = polyval(p,IRval);
end

end