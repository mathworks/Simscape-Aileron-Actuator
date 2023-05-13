function sn_motor_params_setparams(initialtuned)
% Copyright 2012-2023 The MathWorks(TM), Inc.

if (strcmp(initialtuned,'Initial'))
    evalin('base','DC_Motor_R = 3;');
    evalin('base','DC_Motor_L = 2.0536e-04;');
%    evalin('base','DC_Motor_L = 0.01;'); % Not run time
    evalin('base','DC_Motor_K = 0.02;');
%    evalin('base','DC_Motor_J = 0.01;'); % Not run time
%    evalin('base','DC_Motor_B = 0.5;');  % Not run time
    evalin('base','DC_Motor_J = 0.1306;');
    evalin('base','DC_Motor_B = 1.0630;');
else
    evalin('base','DC_Motor_R = 4.0162;');
    evalin('base','DC_Motor_L = 2.0536e-04;');
    evalin('base','DC_Motor_K = 1.0363;');
    evalin('base','DC_Motor_J = 0.1306;');
    evalin('base','DC_Motor_B = 1.0630;');
end