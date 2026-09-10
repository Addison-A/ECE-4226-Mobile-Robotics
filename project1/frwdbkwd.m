T = 0.01;
tspan = 2;      % long enough to cover both the CCW and CW revolution
index = 3;      % CCW then CW, cosine profile
Nb = 4;
LvL = 0;

[t,alpha] = alpha_gen(index,T,tspan);

figure(1);
plot(t,alpha*180/pi);
xlabel('time (sec)');
ylabel('wheel position (deg)');
title('wheel position (degrees) - forward/backward test');

[A,B] = encoder_signals(t,alpha,Nb,LvL);
[cV,eV,aV] = tic_counter(A,B,Nb);

% overlay actual alpha and the encoder's angle estimate to compare
figure(2);
plot(t,alpha*180/pi,'.-b');
hold on;
plot(t,aV*180/pi,'.-r');
hold off;
xlabel('time (sec)');
ylabel('angle (deg)');
title('actual (blue) vs estimated (red) wheel angle');

% also check for spurious errors during the direction reversal
figure(3);
plot(t,cV,'.-b');
Ie = find(eV == 1);
hold on;
plot(t(Ie),cV(Ie),'.r','markersize',18);
hold off;
xlabel('time (sec)');
ylabel('count');
title('tic count - forward/backward test');