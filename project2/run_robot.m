%--------------------------------------------------------------------------
% Created by:  William J. Ebel  on 9/8/26
%
% Revision history:
%      Date     Reason
% 
% Purpose:  This script is used to operate the robot under various
%   conditions for the purposes of calibrating the sensor values and tuning
%   the PID controller for line-following.  
%     This script contains variable initializations which will cause the
%   control_loop to behave differently in order to carry out the various
%   calibration procedures.  
%
% Important Variables:  
%    ... see the documentation below
% 
%--------------------------------------------------------------------------
clc;  

% the output file name
file = 'data';       % the file name containing the saved data

% flags to control what aspects of the control loop to include
controlflg = 0;      % 0 = don't control at all (dead-reckon)
                     % 1 = line-following control
                     % 2 = shaft-encoder control (not implemented yet)
                     % 3 = wall following control (not implemented yet)
                     % 4 = pose estimation drive-straight (not impl yet)

% run parameter
runtime = 1;         % (sec) run time for this function

% motor speed parameters
Lspeed = 0;          % nominal LEFT motor speed, range [-125,125]
Rspeed = 0;          % nominal RIGHT motor speed, range [-125,125]

% print parameters, if all are false, then the control loop prints nothing
prt_kk  = true;      % true = print the loop index, kk
prt_rev = true;      % true = print Lrev and Rrev
prt_a   = true;      % true = print line-following sensor values
prt_x   = true;      % true = print line position
prt_IR  = true;      % true = print IR ranger value
%prt_AC  = true;      % true = print AC ranger value
prt_Z   = true;      % true = print the PID controller turn rate parameters, Zp,Zd,Z
prt_delay = true;    % true = print the loop delay

%-----------
% the following parameters are only used if lineflg = true
LLmax    = 5;        % # of control loop iterations before declaring lost line 
Lbreaks  = 1;        % stop robot on the nth link break found
Kmin     = nan;      % minimum sensor sum for presence of line
Kmax     = nan;      % maximum sensor sum for pick up/stop sign

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