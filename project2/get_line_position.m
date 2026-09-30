%--------------------------------------------------------------------------
% Created by:  Addison P. Aque  on 9/28/26
%
% Revision history:
%      Date     Reason
%      Sept 30 3036 Fixing up the cases so that elements cannot be below 0
%      and fixing arithmetic for aV of length 2,4,6,8 only.
% 
% Purpose:  This script is used to optimize the line-position estimate and
% estimate the current line position using the normalized amin vector.
%
% Important Variables:  
%    aV     - normalized sensor data
%    s      - sum of the sensor data
%    x      - singular value representing the position of the reflectance
%               sensor array
% 
% function x = get_line_position(aV);
%--------------------------------------------------------------------------
function x = get_line_position(aV)

%aV = [400 250 250 250 250 250 250 400]; % Normalized data coming in

% Check that all the components are non-negative
if all(aV(:) >= 0)
    % find the sum of the sensor array and set bottom threshold at 1
    s = max(1,sum(aV));
else 
    fprintf('ERROR in get_line_position.  The input vector ');
    fprintf('aV cannot have negative components.\n');
    x = [];
    return;
end



switch numel(aV)
    case 2, x = (-50*aV(1) + 50*aV(2))/s;
    case 4, x = (-150*aV(1) + -50*aV(2) + 50*aV(3) + 150*aV(4))/s;
    case 6, x = (-250*aV(1) + -150*aV(2) + -50*aV(3) + 50*aV(4) + ...
                    150*aV(5) + 250*aV(6))/s;
    case 8, x = (-350*aV(1) + -250*aV(2) + -150*aV(3) + -50*aV(4) + ...
                    50*aV(5) + 150*aV(6) + 250*aV(7) + 350*aV(8))/s;
    otherwise, fprintf('ERROR: aV must be of length 2, 4, 6, or 8\n');
        x = [];
        return;
end
    
end


% %make sure its the appropriate length
% if ismember(numel(aV), [2, 4, 6, 8])
%    fprintf('ERROR in get_line_position.  The input vector aV does
%  not have an appropriate length.');
%    x = 0;
%    return;
% end