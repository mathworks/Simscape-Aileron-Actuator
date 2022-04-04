%% Open model, save copy
orig_mdl = 'sm_aileron_actuator';
variant = 'E SL Avg';
sm_aileron_actuator_PARAM
open_system(orig_mdl);
mdl = [orig_mdl '_rttest_temp'];
sm_aileron_actuator_configModel(orig_mdl,variant)
save_system(orig_mdl,mdl);
sm_aileron_actuator_configRTParams(mdl,variant);
set_param(mdl,'SimscapeLogType','none');
set_param(mdl,'SaveFormat','StructureWithTime');

%% Get reference results
sm_aileron_actuator_setsolver(mdl,'desktop');
sim(mdl)
t_ref = Angles_Forces.time;
y_ref = Angles_Forces.signals(1).values(:,1);
clear tout yout

%% Create plot
figure(1)
temp_colororder = get(gca,'DefaultAxesColorOrder');
set(gcf,'Position',[552    50   472   301]);
plot(t_ref,y_ref,'k','LineWidth',3)
title('Comparing Simulation Results','FontSize',14,'FontWeight','Bold');
xlabel('Time (s)','FontSize',12);ylabel('Results');
legend({'Reference'},'Location','North')
set(gca,'YLim',[-25 25]);

%% Get results with real-time solver settings
sv_p = sm_aileron_actuator_setsolver(mdl,'realtime');
open_system(get_param(sv_p(1),'Parent'),'force')
set_param(char(sv_p(1)),'Selected','on');
sim(mdl)
t_fs = Angles_Forces.time;
y_fs = Angles_Forces.signals(1).values(:,1);

%% Compare desktop and real-time results
figure(1)
hold on
h2=stairs(t_fs,y_fs,'Color',temp_colororder(2,:),'LineWidth',2.5);
hold off
legend({'Reference','Fixed-Step'},'Location','North')

%% Select run-time parameter
tune_bpth = [mdl '/Actuator/Electric/Leadscrew 1/Bearing Friction'];

% Highlight block
open_system(get_param(tune_bpth,'Parent'),'force')
set_param(tune_bpth,'Selected','on');

%% Build application
% Choose target
cs = getActiveConfigSet(mdl);
cs.switchTarget('slrealtime.tlc',[]);

set_param(mdl,'SimMechanicsOpenEditorOnUpdate','off');
slbuild(mdl);

%% Download to real-time target
tg = slrealtime;
tg.connect;

%% Run application
tg.load(mdl)
tg.start('ReloadOnStop',true,'ExportToBaseWorkspace',true)

open_system(mdl);
disp('Waiting for SLRT to finish...');
pause(1);
while(strcmp(tg.status,'running'))
    pause(2);
    disp(tg.status);
end
pause(2);

%% Extract results from logged data in Simulink Data Inspector
y_slrt1 = logsout_sm_aileron_actuator.getElement('qMeas');

%% Plot reference and real-time results
figure(1)
hold on
h3=stairs(y_slrt1.Values.Time,y_slrt1.Values.Data,'c:','LineWidth',2.5);
hold off
legend({'Reference','Fixed-Step','Real-Time'},'Location','North');

%% Modify area to model increased motor friction
disp(['Motor Bearing Friction (current) = ' num2str(getparam(tg,'','motor_friction'))]);
setparam(tg,'','motor_friction',0.001)
disp(['Motor Bearing Friction (new) = ' num2str(getparam(tg,'','motor_friction'))]);

%% Run simulation with new parameter value
tg.start('ReloadOnStop',true,'ExportToBaseWorkspace',true)

disp('Waiting for Simulink Real-Time to finish...');
pause(1);
while(strcmp(tg.status,'running'))
    pause(2);
    disp(tg.status);
end
pause(2);

%% Extract results from logged data in Simulink Data Inspector
y_slrt1 = logsout_sm_aileron_actuator.getElement('qMeas');

%% Plot results of altered motor friction test
figure(1)
hold on
stairs(y_slrt2.Values.Time,y_slrt2.Values.Data,'Color',temp_colororder(4,:),'LineWidth',2);
hold off
legend({'Reference','Fixed-Step','Real-Time','Modified'},'Location','North');

%save(['sm_aileron_actuator_slrt_elec_res_' datestr(now,'yyddmm_HHMM')],'t_slrt1','y_slrt1','t_slrt2','y_slrt2','t_ref','y_ref','t_fs','y_fs');

%% CLEAN UP DIRECTORY
%cleanup_rt_test

% Copyright 2013-2022 The MathWorks(TM), Inc.
