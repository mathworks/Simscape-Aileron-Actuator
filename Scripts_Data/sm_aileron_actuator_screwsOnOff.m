function sm_aileron_actuator_screwsOnOff(modelname,onOff)
% Copyright 2018-2023 The MathWorks, Inc.

screws_sub_h = find_system(modelname,'regexp','on','MatchFilter',@Simulink.match.allVariants,...
    'IncludeCommented','on','LookUnderMasks','on','BlockType','SubSystem','Name','Screws.*');

for i=1:length(screws_sub_h)
    set_param(char(screws_sub_h{i}),'Commented',onOff)
end
