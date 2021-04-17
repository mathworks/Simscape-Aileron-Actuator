function sm_aileron_actuator_configECtrl(modelname,config_name)
% Copyright 2012-2021 The MathWorks(TM), Inc.

actuate_path = char(find_system(modelname,'FollowLinks','on','Name','Actuator'));
econtrl_path = find_system(modelname,'FollowLinks','on','regexp','on','Variants','AllVariants','Name','Leadscrew.*');

switch config_name
    case 'Abstract'
        set_param(actuate_path,'OverrideUsingVariant','Electric');
        for i=1:length(econtrl_path)
            set_param(econtrl_path{i},'popup_ctrl','Simulink')
        end
    case 'Circuit'
        for i=1:length(econtrl_path)
            set_param(econtrl_path{i},'popup_ctrl','Circuit')
        end
    otherwise
        warning('Unexpected Configuration setting.')
end

set_param(actuate_path,'Name',get_param(actuate_path,'Name'));
