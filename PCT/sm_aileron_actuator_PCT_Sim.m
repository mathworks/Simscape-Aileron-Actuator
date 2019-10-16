orig_mdl = 'sm_aileron_actuator';
open_system(orig_mdl);
sm_aileron_actuator_configModel(orig_mdl,'Hydraulic')
mdl = [orig_mdl '_pct_temp'];
save_system(orig_mdl,mdl);


%% GENERATE PARAMETER SETS
pcnt_array = linspace(1,0.6,10);
press_array = hydr_supply_pressure*pcnt_array;

for i=1:length(press_array)
    simInput(i) = Simulink.SimulationInput(mdl);
    simInput(i) = simInput(i).setVariable('hydr_supply_pressure',press_array(i));
end

set_param(mdl,'SimMechanicsOpenEditorOnUpdate','off');
save_system(mdl)
%simOut  = sim(simInput,'ShowProgress','on','UseFastRestart','on');
simOut = parsim(simInput,'ShowProgress','on','UseFastRestart','on','TransferBaseWorkspaceVariables','on');
set_param(mdl,'SimMechanicsOpenEditorOnUpdate','on');
save_system(mdl)


if ~exist('h4_sm_aileron_actuator_pct', 'var') || ...
        ~isgraphics(h4_sm_aileron_actuator_pct, 'figure')
    h4_sm_aileron_actuator_pct = figure('Name', 'sm_aileron_actuator');
end
figure(h4_sm_aileron_actuator_pct)
clf(h4_sm_aileron_actuator_pct)

temp_colororder = get(gca,'defaultAxesColorOrder');

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

temp_legstr = num2str(round(pcnt_array'*100,1));
temp_legstr = [temp_legstr repmat('%',size(temp_legstr,1),1)];
legend(simlog_handles(2),{temp_legstr});

%% CLOSE PARALLEL POOL
%delete(gcp);

%% CLEANUP DIR
bdclose(mdl);
%delete('*.mex*')
%!rmdir slprj /S/Q
delete([mdl '.slx']);

% Copyright 2013-2019 The MathWorks(TM), Inc.

clear temp_legstr
