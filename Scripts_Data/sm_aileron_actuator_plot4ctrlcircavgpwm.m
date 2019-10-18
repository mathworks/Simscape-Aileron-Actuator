% Code to plot simulation results from sm_aileron_actuator
%% Plot Description:
%
% The plots below show the effects of implementing the control algorithm
% using an analog circuit.
%
% Copyright 2018 The MathWorks, Inc.

% Reuse figure if it exists, else create new figure
if ~exist('h4_sm_aileron_actuator', 'var') || ...
        ~isgraphics(h4_sm_aileron_actuator, 'figure')
    h4_sm_aileron_actuator = figure('Name', 'sm_aileron_actuator');
end
figure(h4_sm_aileron_actuator)
temp_colororder = get(gca,'defaultAxesColorOrder');
clf(h4_sm_aileron_actuator)

config_set = {'E Cir Avg','E Cir PWM'};
stopti_set = {'0.002','0.002'};
clrind_set = [4 5];
modelname = 'sm_aileron_actuator';

open_system('sm_aileron_actuator/Actuator/Electric');
for i=1:length(config_set)
    sm_aileron_actuator_configModel(modelname,config_set{i})
    set_param(modelname,'StopTime',stopti_set{i});
    sim(modelname)
    % Get simulation results
    simlog_t    = simlog_sm_aileron_actuator.Mechanical.Cyl_MC_BrkLAil.Rz.q.series.time;
    simlog_qAil = simlog_sm_aileron_actuator.Mechanical.Cyl_MC_BrkLAil.Rz.q.series.values('deg');
    simlog_actFrc = logsout_sm_aileron_actuator.get('force_act');
    simlog_qCmd = logsout_sm_aileron_actuator.get('qCmd');
    simlog_iMot = simlog_sm_aileron_actuator.Actuator.Electric.Leadscrew_1.DC_Motor.i.series.values('A');
    
    % Plot results
    simlog_handles(1) = subplot(2, 1, 1);
    hold on
    %if(i==1)
    %    plot(simlog_qCmd.Values.Time, simlog_qCmd.Values.Data, 'k-.', 'LineWidth', 1)
    %end
    plot(simlog_t, simlog_qAil, 'LineWidth', 1,'Color',temp_colororder(clrind_set(i),:));
    
    simlog_handles(2) = subplot(2, 1, 2);
    hold on
    plot(simlog_t,simlog_iMot, 'LineWidth', 1, 'Color',temp_colororder(clrind_set(i),:))
end
set_param(modelname,'StopTime','10');

grid(simlog_handles(1),'on');
box(simlog_handles(1),'on');
grid(simlog_handles(2),'on');
box(simlog_handles(2),'on');

title(simlog_handles(1),'Aileron Angle')
ylabel(simlog_handles(1),'Angle (deg)')
legend(simlog_handles(1),{'Average','PWM'},'Location','Best');

title(simlog_handles(2),'Motor Current')
ylabel(simlog_handles(2),'Current (A)')
xlabel(simlog_handles(2),'Time (s)')

linkaxes(simlog_handles, 'x')

set(simlog_handles(2),'XLim',[0 str2num(stopti_set{2})]);

hold(simlog_handles(1),'off')
hold(simlog_handles(2),'off')

% Remove temporary variables
%clear simlog_t simlog_handles temp_colororder
clear simlog_actFrc simlog_qCmd simlog_qAil
