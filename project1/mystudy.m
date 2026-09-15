%--------------------------------------------------------------------------
% Created by:  Addison P. Aque  on 9/15/2026
%
% Revision history:
%      Date     Reason
%
% Purpose:  Study how the number of encoder states per revolution (Ns),
% the sample time (T), and the wheel spin rate (K = d(alpha)/dt) limit
% the ability of a quadrature encoder to track wheel angle. Two constant
% spin rates are tested: one below and one above the tracking limit.
%
% key relationship:
%       K * T  <  2*pi / Ns          (Ns = 4*Nb)
%
% Important Variables:
%    INDEX - alpha_gen conditioner
%    Nb    - number of black patches (assigned)
%    T     - sample time in seconds (assigned)
%    Ns    - number of distinguishable encoder states per revolution
%    Kmax  - fastest spin rate the encoder can track (rad/sec)
%    K1,K2 - trackable and untrackable spin rates (rad/sec)
%--------------------------------------------------------------------------

clear; close all; clc;

% assigned parameters 
INDEX = 1;        
Nb = 8;           
T  = 0.0023;      
LvL = 0;          


% theoretical tracking limit 
Ns   = 4*Nb;                 
Kmax = 2*pi/(Ns*T);          
fprintf('Ns = %d states/rev, Kmax = %.3f rad/sec (%.3f rev/sec)\n', Ns, Kmax, Kmax/(2*pi));

% choose one spin rate on each side of the limit 
K1 = 0.5*Kmax;    
K2 = 1.5*Kmax;    
Krates = [K1 K2];
names  = {'trackable', 'untrackable'};

for i = 1:2
    % alpha_gen with INDEX = 1 makes exactly one revolution over tspan, 
    tspan = 2*pi/Krates(i);
    [t,alpha] = alpha_gen(INDEX,T,tspan);

    % measure the spin rate actually produced (slope of alpha vs. time)
    K = (alpha(end)-alpha(1))/(t(end)-t(1));

    % simulate sensors, then decode with the tic counter
    [A,B] = encoder_signals(t,alpha,Nb,LvL);
    [cV,eV,aV] = tic_counter(A,B,Nb);

    % overlay true angle (blue) and encoder estimate (red)
    figure(i);
    plot(t,alpha*180/pi,'-b'); hold on;
    plot(t,aV*180/pi,'.-r'); hold off;
    xlabel('time (sec)');
    ylabel('wheel angle (deg)');
    title(sprintf('%s case: K = %.2f rad/sec (K*T = %.2f of one state)', names{i}, K, K*T/(2*pi/Ns)));
    legend('alpha (actual)','alpha estimate','Location','northwest');

    % report how well the encoder did
    errV = alpha - aV;
    fprintf('%s: max error = %.2f deg, flagged errors = %d\n', names{i}, max(abs(errV))*180/pi, sum(eV));
end
