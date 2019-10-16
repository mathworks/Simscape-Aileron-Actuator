%% Open model, save copy
orig_mdl = 'Aileron_EH';
variant = 'EMech Impl Avg';
open_system(orig_mdl);
mdl = [orig_mdl '_rttest_temp'];
Aileron_EH_setconfig(orig_mdl,variant)
save_system(orig_mdl,mdl);
set_param([mdl '/Actuation/Electromechanical'],'LinkStatus','inactive');    
set_param([mdl '/Actuation/Electromechanical/Speed and Current Control/Circuit'],'LinkStatus','inactive');

%% Configure for test
Aileron_EH_Final_Values
set_param(mdl,'SimscapeLogType','None');
Aileron_EH_Configure_rtParams(mdl,variant);

%% Get reference results
Aileron_EH_setsolver(mdl,'desktop');
sim(mdl)
t_ref = tout; y_ref = yout;
clear tout yout

%% Create plot
figure(1)
temp_colororder = get(gca,'DefaultAxesColorOrder');
set(gcf,'Position',[552    50   472   301]);
plot(t_ref,y_ref,'k','LineWidth',3)
title('Comparing Simulation Results','FontSize',14,'FontWeight','Bold');
xlabel('Time (s)','FontSize',12);ylabel('Results');
legend({'Reference'},'Location','NorthEast')
set(gca,'YLim',[-5 20]);
%% Get results with real-time solver settings
Aileron_EH_setsolver(mdl,'realtime');
sim(mdl)
t_fs = tout; y_fs = yout;

%% Compare desktop and real-time results
figure(1)
hold on
h2=stairs(tout, yout,'Color',temp_colororder(2,:),'LineWidth',2.5);
hold off
legend({'Reference','Fixed-Step'},'Location','NorthEast')

%% Select run-time parameter
tune_bpth = [mdl '/Actuation/Electromechanical/Speed and Current Control/Circuit/Speed Controller/R7'];
set_param(tune_bpth,'R_conf','runtime');

% Highlight block
open_system(get_param(tune_bpth,'Parent'),'force')
set_param(tune_bpth,'Selected','on');

%% Build and download to real-time target
slbuild(mdl);

%% Set simulation mode to External
set_param(mdl,'SimulationMode','External');

%% Connect to target and run
set_param(mdl, 'SimulationCommand', 'connect')
set_param(mdl, 'SimulationCommand', 'start')

open_system(mdl);
disp('Waiting for SLRT to finish...');
pause(1);
disp(get_param(bdroot,'SimulationStatus'));
while(~strcmp(get_param(bdroot,'SimulationStatus'),'stopped'))
    pause(2);
    disp(get_param(bdroot,'SimulationStatus'));
end
pause(2);

t_slrt1 = tg.TimeLog;
y_slrt1 = tg.OutputLog;

%% Plot reference and real-time results
figure(1)
hold on
h3=stairs(t_slrt1,y_slrt1,'c:','LineWidth',2.5);
hold off
legend({'Reference','Fixed-Step','Real-Time'},'Location','NorthEast');

%% Modify area to model blocked hydraulic line
r7res_id = getparamid(tg, '','R7_Res');
disp(['R7 Resistance (current) = ' num2str(getparam(tg,r7res_id))]);
setparam(tg,r7res_id,3);
disp(['R7 Resistance (new)     = ' num2str(getparam(tg,r7res_id))]);

%% Run simulation with new parameter value
start(tg);

disp('Waiting for Simulink Real-Time to finish...');
pause(1);
disp(tg.Status);
while(~strcmp(tg.Status,'stopped'))
    pause(2);
    disp(tg.Status);
end
pause(2);

t_slrt2 = tg.TimeLog; y_slrt2 = tg.OutputLog;

%% Plot results of altered resistance test
figure(1)
hold on
stairs(t_slrt2,y_slrt2,'Color',temp_colororder(4,:),'LineWidth',2);
hold off
legend({'Reference','Fixed-Step','Real-Time','Modified'},'Location','NorthEast');


%% CLEAN UP DIRECTORY
cleanup_rt_test

% Copyright 2013-2019 The MathWorks(TM), Inc.
