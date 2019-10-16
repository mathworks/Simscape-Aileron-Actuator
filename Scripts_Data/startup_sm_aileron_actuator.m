% Startup script for project Aileron_Act.prj
% Copyright 2018-2019 The MathWorks, Inc.

AAC_HomeDir = pwd;

sm_aileron_actuator_PARAM
load sm_aileron_actuator_Ang2Ext

sm_aileron_actuator
web('sm_aileron_actuator_Demo_Script.html');
