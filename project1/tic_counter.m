%--------------------------------------------------------------------------
% Created by:  Addison P. Aque  on 9/11/26
%
% Revision history:
%      Date     Reason
% 
% Purpose:  This function is used to decode the quadraturee shaft encoder
% signals of a wheel into a tic count with direction via signs, flag
% ambiguous state transitions, and convert the tic count into an estimate
% of the wheels angle.
%
% Inputs:
%    A, B  - vectors of sensor A and B voltage samples (same length)
%    Nb    - number of black patches on the encoder wheel
%
% Outputs:
%    cV    - cumulative tic count (+1 per CCW step, -1 per CW step)
%    eV    - 1 where a 2-state (ambiguous) transition occurred, else 0
%    aV    - estimate of wheel angle alpha in radians
%
% Important Variables:  
%    N          - number of samples in A and B
%    vThresh    - voltage threshold separating logic low from high (2.5 V)
%    aMeas      - logical vector, sensor A high (black)
%    bMeas      - logical vector, sensor B LOW (B is inverted so the state
%                 sequence matches the wheels CCW direction)
%    stateV     - encoder state (0-3) at each sample, Gray-code order
%    d          - state change between consecutive samples, mod 4
%    count      - running tic count
%    ticsPerRev - tics per wheel revolution (4*Nb)
% 
% function [cV,eV,aV] = tic_counter(A,B,Nb)
%--------------------------------------------------------------------------
function [cV,eV,aV] = tic_counter(A,B,Nb)

    % Check that the input vectors A,B are same length
    % if isempty(A) || isempty(B) || ~isscalar(Nb) || Nb <= 0
    %     cV = []; eV = []; aV = [];
    %     return;
    % end
    
    if (length(A) ~= length(B)) 
        cV = []; eV = []; aV = [];

        return;
    end

    % Make sure that Nb is a positive, non-zero number
    if Nb <= 0
        cV = []; eV = []; aV = [];
        return;
    end
    
    N = length(A);
    cV = zeros(1,N);
    eV = zeros(1,N);

    % Setting a threshild voltage (assuming the sensor is 5v and not 3.3)
    vThresh = 2.5;
    aMeas = A > vThresh;
    bMeas = B < vThresh;

    % mapping onto states
    stateV = zeros(1,N);
    stateV(~aMeas & ~bMeas)  = 0; % 0,0
    stateV(aMeas & ~bMeas)   = 1; % 1,0 
    stateV(aMeas & bMeas)   = 2; % 1,1
    stateV(~aMeas & bMeas)    = 3; % 0,1
    
    %initialize cV and eV vectors
    count = 0;
    cV(1) = count;
    eV(1) = 0;

    for k = 2:N
        d = mod(stateV(k) - stateV(k-1), 4);

        switch d
            case 1 % CCW
                count = count + 1;
                eV(k) = 0;
            case 3 % CW
                count = count - 1;
                eV(k) = 0;
            case 2 % Unknown State Transition
                eV(k) = 1;
            otherwise % No moevemnt, nothing has changed
                eV(k) = 0;
        end

        cV(k) = count;

    end

    % calculate for alpha
    ticsPerRev = 4*Nb;
    aV = (cV*2*pi) / ticsPerRev;
end