% Protect model containing Simscape components
% and test with varying parameters.

% Copyright 2013-2022 The MathWorks(TM), Inc.

% Open model, create copy
orig_mdl = 'sm_aileron_actuator';
mdl = 'sm_aileron_actuator_protected';
refmdl = 'Aileron_System';
refsys = [mdl '/' refmdl];
open_system(orig_mdl);
save_system(orig_mdl,mdl);
set_param(mdl,'SystemTargetFile','grt.tlc');
sm_aileron_actuator_configModel(mdl,'Hydraulic')

%% Configure test and parameters
%Aileron_EH_Final_Values;
sm_aileron_actuator_configRTParams(mdl,'Hydraulic')

%% Create subsystem to be protected
bh(1) = get_param([mdl '/Actuator'],'Handle');
bh(2) = get_param([mdl '/Mechanical'],'Handle');
bh(3) = get_param([mdl '/Aero Load'],'Handle');
bh(4) = get_param([mdl '/qMGoto'],'Handle');
bh(5) = get_param([mdl '/qMFrom1'],'Handle');
bh(6) = get_param([mdl '/qMFrom2'],'Handle');
Simulink.BlockDiagram.createSubSystem(bh);
set_param([mdl '/Subsystem'],...
    'Name',refmdl,...
    'Position',[-250   -24   -25    64]);

set_param([mdl '/Flight Cycle'],...
    'Position',[-315   -81  -270   -39]);
set_param([mdl '/Goto1'],...
    'Position',[25    -8    45     8]);


%% Create Reference Model
set_param(refsys,'TreatAsAtomicUnit','on');

Simulink.SubSystem.convertToModelReference(...
   refsys,refmdl, ...
   'AutoFix',true,...
   'ReplaceSubsystem',true);

%% Configure Reference Model
open_system(refmdl);
set_param(refmdl,'SimscapeLogType','none');
set_param(refmdl,'SimMechanicsOpenEditorOnUpdate','off');
set_param(refmdl,'ModelReferenceNumInstancesAllowed','single');
save_system(refmdl);

%% Create and reference protected model
[harnessHandle, neededVars] = ...
    Simulink.ModelReference.protect(refmdl,...
    'Harness', false,...
    'Webview',true);
set_param(refsys,'ModelName',[refmdl '.slxp']);
bdclose(refmdl);

save_system(mdl);

%% Run simulation with modified parameter value
hydr_supply_pressure.Value = 2e6;
sim(mdl)
y_run1 = Angles_Forces.signals(1).values(:,1);
t_run1 = Angles_Forces.time;
y_ref  = logsout_sm_aileron_actuator.get('qCmd');

hydr_supply_pressure.Value = 2e6*0.7;
sim(mdl);
y_run2 = Angles_Forces.signals(1).values(:,1);
t_run2 = Angles_Forces.time;

if ~exist('h5_sm_aileron_actuator_ipprotect', 'var') || ...
        ~isgraphics(h5_sm_aileron_actuator_ipprotect, 'figure')
    h5_sm_aileron_actuator_ipprotect = figure('Name', 'sm_aileron_actuator');
end
figure(h5_sm_aileron_actuator_ipprotect)
clf(h5_sm_aileron_actuator_ipprotect)

temp_colororder = get(gca,'defaultAxesColorOrder');

plot(y_ref.Values.Time,y_ref.Values.Data,'Color','k','LineWidth',1,'LineStyle','--');
hold on
plot(t_run1, y_run1,'LineWidth',1,'Color',temp_colororder(1,:));
plot(t_run2, y_run2,'LineWidth',1,'Color',temp_colororder(2,:));
hold off
title('Supply Pressure Test');
xlabel('Time (s)');ylabel('Angle (deg)');
legend({'Command','Full','Reduced'},'Location','Best');
grid on


%% Close model and clean up directory
%{
bdclose(mdl); 
delete([mdl '.slx']);
delete([mdl '.slxc']);
bdclose(refmdl);
delete([refmdl '.slx']);
delete([refmdl '.slxp']);
delete([refmdl '_msp.mexw64']);
!rmdir slprj /S/Q
%}

