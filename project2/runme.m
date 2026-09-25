%--------------------------------------------------------------------------
% Created by:  William J. Ebel  on 9/8/26
%
% Revision history:
%      Date     Reason
% 
% Purpose:  This script is used to operate the robot under various
%   conditions for the purposes of carrying out the calibration, parameter
%   estimation, and tuning procedures given in tutorial4.pdf.
%
% Important Variables:  
%    ... see the documentation below
% 
%--------------------------------------------------------------------------
clc;  
clear file controlflg runtime Lspeed Rspeed
clear prt_kk prt_rev prt_a prt_x prt_IR prt_AC prt_Z prt_time prt_delay
clear LLmax Lbreaks Kmin Kmax Kp Ki Kd class


% the output file name
file = 'data';       % the file name containing the saved data

% flags to control what aspects of the control loop to include
controlflg = 0;      % 0 = don't control at all (dead-reckon)
                     % 1 = line-following control

runtime = 1;         % (sec) run time for this function

%-----------
% motor speed parameters
Lspeed = 0;          % nominal LEFT motor speed, range [-125,125]
Rspeed = 0;          % nominal RIGHT motor speed, range [-125,125]

%-----------
% print parameters, if all are false, then the control loop prints nothing
prt_kk    = true;    % true = print the loop index, kk
prt_rev   = true;    % true = print Lrev and Rrev
prt_a     = true;    % true = print line-following sensor values
prt_x     = true;    % true = print line position
prt_IR    = true;    % true = print IR ranger value
prt_Z     = true;    % true = print the PID controller parameters, Zp,Zd,Z
prt_time  = true;    % true = print the total operational time
prt_delay = true;    % true = print the loop delay

%-----------
% the following parameters are only used if controlflg = 1
LLmax    = 5;        % # of control loop iterations before declaring lost line 
Lbreaks  = 1;        % stop robot on the nth link break found
Kmin     = 0;        % minimum sensor sum for presence of line
Kmax     = 0;        % maximum sensor sum for pick up/stop sign

%-----------
% controller PID algorithm gain factors for line-following
Kp  = 0;             % proportional controller constant
Ki  = 0;             % integral controller constant (NOT USED)
Kd  = 0;             % differential controller constant

class = 4226;   % DO NOT CHANGE!!!!

%-------------------------- CONTROL LOOP ----------------------------------
control_loop;
%--------------------------------------------------------------------------


% save the data
if CLerr
  fprintf(2,"\n*** ERROR in control_loop.  An error occured, the data was not saved.\n\n")
end

%---------------------------- POST ANALYSIS -------------------------------
if ~CLerr
end