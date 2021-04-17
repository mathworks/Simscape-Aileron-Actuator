function sm_aileron_actuator_screwsOnOff(modelname,onOff)
% Copyright 2018-2021 The MathWorks, Inc.

screws_sub_h = find_system(modelname,'regexp','on','IncludeCommented','on','LookUnderMasks','on','BlockType','SubSystem','Name','Screws.*');

for i=1:length(screws_sub_h)
    set_param(char(screws_sub_h{i}),'Commented',onOff)
end
