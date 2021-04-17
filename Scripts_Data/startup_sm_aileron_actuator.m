% Startup script for project Aileron_Act.prj
% Copyright 2018-2021 The MathWorks, Inc.

AAC_HomeDir = pwd;

sm_aileron_actuator_PARAM
load sm_aileron_actuator_Ang2Ext

open_start_content = 1;

% If running in a parallel pool
% do not open model or demo script
if(~isempty(ver('parallel')))
    if(~isempty(getCurrentTask()))
        open_start_content = 0;
    end
end

if(open_start_content)
    % Open model and demo script
    sm_aileron_actuator
    open('sm_aileron_actuator_Demo_Script.html');
end
clear open_start_content
