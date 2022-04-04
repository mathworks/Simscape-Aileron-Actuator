% Copyright 2013-2022 The MathWorks(TM), Inc.

% Initial values
Kp = 0.03;
Ki = 0.03;

% Configure model
set_param('sm_aileron_actuator','FastRestart','on');
set_param('sm_aileron_actuator','SimMechanicsOpenEditorOnUpdate','off');

% Load session
load sm_aileron_actuator_sdosession
sdotool(SDOSessionData);