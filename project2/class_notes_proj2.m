serial_start
sobj;
dV = get_serial_data(sobj,4226); % gets the data from the sensors on the robot
        % should be getting a delta of abt 30ms.

show_serial_data(sobj,4226,1); %why does this one not end in the weird single collumn decimal values?
% i'll decide where i want the origin of the IR sensor to be.
% there is going ot be a trafeoff of how many values captured and on which
% distances for the calibration. dont do too many, but also dont do too
% few.

%map_serial_data goals:
% 1) going to use polyfit and poly val to transfor the raw IR data into a
% tangible distance inside the map_serial_data fnc.
%
% 2) Going to take the noisy reflectance sensor values and ensure it does
% not trigger a non 0 value when calibrating on white. (talked abt this in
% the lecture, and in terms of the dV its 4-11). [eliminate the noise
% floor]


show_serial_data(sobj,4226,1);      %does not show the mapped serial data, jus tthe raw
show_serial_data(sobj,4226,1,true); %does the serial data mapping using map_serial_data


%start running the robot and then also measure with the calibrated sensors
set_speed(sobj,30,30); show_serial_data(sobj,4226,1, true);
stop;


%code inside of map_serial_data for normalizig the white background
% eliminate the noise floor of the 
  amin = [400 250 250 250 250 250 250 400];
  a = dV(4:11);
  dV(4:11) = max(0,a-amin);


%to reconnect with robot after unplugging:
clear sobj
serial_start


% runme w cntrl loop is to show serial data
% for get_line_position, has to be of length 2,4,6,or8
% 

%-----------------------
% FOR THE PID CONTROLLER
%-----------------------
% set ki = 0,, set kp = 1, too weak, so increase kp by a factor, choose the
% factor, and then keep increasing by a multiplicitive of that facotr until
% the cntrl is too high, and then whittle it down to a good value of kp.

% want the roboto to oscillate around the line every 4 inches of movement.
% when runnning it and testing, have the robot be offset to the line and
% notice how (should be under 4in of its forward movemnt).


%-----------------------
% WHEEL BASE WIDTH EST: 
%-----------------------
% IF ALWAYS GO Cw, CORD IS GONNA WIND UP, SO IF UP
% THERE & RUNNING 10 TRIEALS, RUN cw, THEN change speeds to do ccw, so u
% wind it then unwind it.

%-----------------------
% motor speed calibration
%-----------------------
% drive from one end of line to other end of line (big foam)
% longer tack gives better est. the wheel rev give you distance, and also
% have the time parameter, for the # of revolutions, so its the avg times
% wheels spun * 2 pi r / time to traverse
%
% use speed indexes from 5 all the way to 80.
%
% let L and R wheels always be the same thing. use polyfit to come up w a
% model

%-----------------------
% speed map
%-----------------------
% takes in desired true speed and maps those (SL, SR) into a speed index that gets
% sent down to the robot.
%
% CAUTION: once speed_map.m is written, the Lspeed and Rspeed are going to
% be interpreted as "true speed"
%
% make sure Rspeed and Lspeed are in terms of in/sec, after the speed map
% fnc is written


