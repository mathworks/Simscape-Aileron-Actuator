% Commands to start estimation session
% Copyright 2012-2024 The MathWorks, Inc.

load('Hydraulic_System_Param_Est_spesession.mat')
set_param(bdroot,'FastRestart','on')
sdotool(SDOSessionData);