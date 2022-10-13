%% Use Parallel Computing and Fast Restart to sweep parameter value
% Copyright 2013-2022 The MathWorks(TM), Inc.

% Move to folder where script is saved
cd(fileparts(which(mfilename)));

% Open model and save under another name for test
orig_mdl = 'sm_aileron_actuator';
open_system(orig_mdl);
mdl = [orig_mdl '_pct_temp'];
save_system(orig_mdl,mdl);

%% Configure model for tests
sm_aileron_actuator_configModel(mdl,'Hydraulic')

%% Generate parameter sets
pcnt_array = linspace(1,0.6,10);
press_array = hydr_supply_pressure*pcnt_array;

for i=1:length(press_array)
    simInput(i) = Simulink.SimulationInput(mdl);
    simInput(i) = simInput(i).setVariable('hydr_supply_pressure',press_array(i));
end

%% Run one simulation to see time used
timerVal = tic;
sim(mdl)
Elapsed_Sim_Time_single = toc(timerVal);
disp(['Elapsed Simulation Time Single Run: ' num2str(Elapsed_Sim_Time_single)]);

%% Adjust settings and save
set_param(mdl,'SimMechanicsOpenEditorOnUpdate','off');
save_system(mdl)

%% Run parameter sweep in parallel
timerVal = tic;
simOut = parsim(simInput,'ShowSimulationManager','on',...
    'ShowProgress','on','UseFastRestart','on',...
    'TransferBaseWorkspaceVariables','on');
Elapsed_Time_Time_parallel  = toc(timerVal);

%% Calculate elapsed time less setup of parallel
Elapsed_Time_Sweep = ...
    (datenum(simOut(end).SimulationMetadata.TimingInfo.WallClockTimestampStop) - ...
    datenum(simOut(1).SimulationMetadata.TimingInfo.WallClockTimestampStart)) * 86400;
disp(['Elapsed Sweep Time Total:       ' sprintf('%5.2f',Elapsed_Time_Sweep)]);
disp(['Elapsed Sweep Time/(Num Tests): ' sprintf('%5.2f',Elapsed_Time_Sweep/length(simOut))]);

%% Reset model
set_param(mdl,'SimMechanicsOpenEditorOnUpdate','on');
save_system(mdl)

%% Plot results
plot_sim_res(simOut,'Parallel Test',Elapsed_Time_Time_parallel)

%% Close parallel pool
delete(gcp);

%% Cleanup directory
bdclose(mdl);
delete([mdl '.slx']);
delete([mdl '*.slmx']);

%%  Plot function
function plot_sim_res(simOut,annotation_str,elapsed_time)

% Plot Results
fig_handle_name =   'h4_sm_aileron_actuator_pct';

handle_var = evalin('base',['who(''' fig_handle_name ''')']);
if(isempty(handle_var))
    evalin('base',[fig_handle_name ' = figure(''Name'', ''' fig_handle_name ''');']);
elseif ~isgraphics(evalin('base',handle_var{:}))
    evalin('base',[fig_handle_name ' = figure(''Name'', ''' fig_handle_name ''');']);
end
figure(evalin('base',fig_handle_name))
clf(evalin('base',fig_handle_name))

for i=1:length(simOut)
    simlogrun = simOut(i).simlog_sm_aileron_actuator;
    logsoutrun = simOut(i).logsout_sm_aileron_actuator;
    
    % Get simulation results
    simlog_t    = simlogrun.Mechanical.Cyl_MC_BrkLAil.Rz.q.series.time;
    simlog_qAil = simlogrun.Mechanical.Cyl_MC_BrkLAil.Rz.q.series.values('deg');
    simlog_actFrc = logsoutrun.get('force_act');
    simlog_qCmd = logsoutrun.get('qCmd');
    
    % Plot results
    simlog_handles(1) = subplot(2, 1, 1);
    hold on
    if(i==1)
        plot(simlog_qCmd.Values.Time, simlog_qCmd.Values.Data, 'k-.', 'LineWidth', 1)
    end
    plot(simlog_t, simlog_qAil, 'LineWidth', 1);
    
    simlog_handles(2) = subplot(2, 1, 2);
    hold on
    plot(simlog_actFrc.Values.Time, simlog_actFrc.Values.Data, 'LineWidth', 1)
end

grid(simlog_handles(1),'on');
box(simlog_handles(1),'on');
grid(simlog_handles(2),'on');
box(simlog_handles(2),'on');

title(simlog_handles(1),'Aileron Angle, Reduced Supply Pressure')
ylabel(simlog_handles(1),'Angle (deg)')

title(simlog_handles(2),'Actuator Force, Reduced Supply Pressure')
ylabel(simlog_handles(2),'Force (N)')
xlabel(simlog_handles(2),'Time (s)')

linkaxes(simlog_handles, 'x')

hold(simlog_handles(1),'off')
hold(simlog_handles(2),'off')

pcnt_array = evalin('base','pcnt_array');
temp_legstr = num2str(round(pcnt_array'*100,1));
temp_legstr = [temp_legstr repmat('%',size(temp_legstr,1),1)];
legend(simlog_handles(2),{temp_legstr});

text(simlog_handles(1),0.1,0.15,sprintf('%s\n%s',annotation_str,['Elapsed Time: ' num2str(elapsed_time)]),'Color',[1 1 1]*0.6,'Units','Normalized');
end
