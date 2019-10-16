% Copyright 2018 The MathWorks, Inc.

AAC_HomeDir = pwd;

addpath(AAC_HomeDir)
addpath([AAC_HomeDir filesep 'CAD' filesep 'Geometry']);
addpath([AAC_HomeDir filesep 'CAD' filesep 'Export']);
addpath([AAC_HomeDir filesep 'Images']);
addpath([AAC_HomeDir filesep 'Libraries']);
addpath([AAC_HomeDir filesep 'Scripts_Data']);
addpath([AAC_HomeDir filesep 'IP_Protect']);
addpath([AAC_HomeDir filesep 'Resp_Opt']);
addpath([AAC_HomeDir filesep 'Build_Model']);
addpath([AAC_HomeDir filesep 'html' filesep 'html']);

sm_aileron_actuator_PARAM
load sm_aileron_actuator_Ang2Ext

sm_aileron_actuator
web('sm_aileron_actuator_Demo_Script.html');
