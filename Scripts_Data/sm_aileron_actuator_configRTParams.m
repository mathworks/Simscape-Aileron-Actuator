function sm_aileron_actuator_configRTParams(mdl,variant)
% Add Simscape run-time parameters to Aileron example
% Copyright 2013-2022 The MathWorks, Inc.

if strcmp(variant,'Hydraulic')
    %% Define Simulink.Parameter objects
    tval = evalin('base','hydr_supply_pressure');
    evalin('base','hydr_supply_pressure = Simulink.Parameter;');
    evalin('base','hydr_supply_pressure.CoderInfo.StorageClass = ''SimulinkGlobal'';');
    evalin('base',['hydr_supply_pressure.Value = ' num2str(tval) ';']);
    
elseif strcmp(variant,'E SL Avg')
    %% Define Simulink.Parameter objects
    tval = evalin('base','motor_friction');
    evalin('base','motor_friction = Simulink.Parameter;');
    evalin('base','motor_friction.CoderInfo.StorageClass = ''SimulinkGlobal'';');
    evalin('base',['motor_friction.Value = ' num2str(tval) ';']);
    
elseif strcmp(variant,'E Cir Avg')
    %% Define Simulink.Parameter objects
    tval = evalin('base','R7_sctrl');
    evalin('base','R7_sctrl = Simulink.Parameter;');
    evalin('base','R7_sctrl.CoderInfo.StorageClass = ''SimulinkGlobal'';');
    evalin('base',['R7_sctrl.Value = ' num2str(tval) ';']);
end