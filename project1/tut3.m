% ========== Part A =========
% A.1
T = 0.0001;
tspan = 2;
index = 1;
[t,alpha] = alpha_gen(index,T,tspan);
figure(1);
plot(t,alpha);
xlabel('wheel position (rad)');
ylabel('wheel position (rad)');
xlabel('time (sec)');
title('Wheel position in radians');

% A.2
Nb = 180;
LvL = 0;
[A,B] = encoder_signals(t,alpha,Nb,LvL);
figure(2);

plot(t, A, '.-b');
hold on; plot(t,B,'.-r'); hold off;
xlabel('time (sec)');
ylabel('voltage');
title('A(blue)   B(red)');

% A.3
alpha = 2*alpha;
figure(1);
plot(t,alpha);
xlabel('time (sec)'); 
ylabel('wheel position (rad)'); 
title('wheel position in radians');

% A.4
LvL = 3;
[A,B] = encoder_signals(t,alpha,Nb,LvL);
figure(3);
plot(t,A,'.-b');
hold on; plot(t,B,'.-r'); hold off;
xlabel('time (sec)'); ylabel('voltage'); title('A(blue)   B(red)');

% ========== Part B =========
%B.1
T = 0.01;
tspan = 1; 
index = 1;
Nb = 4; %number of patches per pi
LvL = 0;

[t,alpha] = alpha_gen(index,T,tspan); %generate {t, alpha}

figure(1); plot(t,alpha*180/pi); %plot in degrees
xlabel('time (sec)');
ylabel('wheel position (deg)');
title('wheel position (degrees)');

%B.2
[A,B] = encoder_signals(t,alpha,Nb,LvL);

figure(2);
plot(t,A,'.-b');
hold on; plot(t,B,'.-r'); hold off;
xlabel('time (sec)');
ylabel('voltage');
title('A(blue)     B(red)');

%B.3
[cV, eV, aV] = tic_counter(A,B,Nb);

figure(3);
plot(t,cV,'.-b');
Ie = find(eV == 1);
hold on; 
plot(t(Ie), cV(Ie), '.r', 'markersize',18); %overlay errors in red
hold off;
xlabel ('time (sec)');
ylabel('count');
title('tic count');

%B.4 
ticsrev = 2*pi/(4*Nb); %number of tics per revolution
alpha_est = cV*ticsrev; % convert from tics to angle (rad)

figure(1); % overlay plot showing {t, alpha}
hold on;
plot(t,alpha_est*180/pi,'.-r'); %plot in red and show in degrees
hold off;

%B.5    - Find the alpha estimate error and plot it
errV = alpha-alpha_est;
figure(4); plot(t, errV*180/pi,'.-b');
xlabel('time (sec)');
ylabel('alpha est error (degrees)');
title('angle (deg)');
