% Code to plot simulation results from sm_aileron_actuator
%% Plot Description:
%
% The plot below shows the actuator force required to follow the desired
% trajectory.
%
% Copyright 2018-2021 The MathWorks, Inc.

% Generate simulation results using the Motion variant
set_param([bdroot '/Actuator'],'OverrideUsingVariant','Motion');
sim('sm_aileron_actuator')

% Reuse figure if it exists, else create new figure
if ~exist('h1_sm_aileron_actuator', 'var') || ...
        ~isgraphics(h1_sm_aileron_actuator, 'figure')
    h1_sm_aileron_actuator = figure('Name', 'sm_aileron_actuator');
end
figure(h1_sm_aileron_actuator)
clf(h1_sm_aileron_actuator)

temp_colororder = get(gca,'defaultAxesColorOrder');

% Get simulation results
simlog_t    = simlog_sm_aileron_actuator.Mechanical.Cyl_MC_BrkLAil.Rz.q.series.time;
simlog_qAil = simlog_sm_aileron_actuator.Mechanical.Cyl_MC_BrkLAil.Rz.q.series.values('deg');
simlog_actFrc = logsout_sm_aileron_actuator.get('force_act');
simlog_qCmd = logsout_sm_aileron_actuator.get('qCmd');

% Plot results
simlog_handles(1) = subplot(2, 1, 1);
plot(simlog_qCmd.Values.Time, simlog_qCmd.Values.Data, 'k-.', 'LineWidth', 1)
hold on
plot(simlog_t, simlog_qAil, 'LineWidth', 1,'Color',temp_colororder(1,:));
hold off
title('Aileron Angle');
ylabel('Angle (deg)');
legend({'Command','Measured'},'Location','North')
box on
grid on

simlog_handles(2) = subplot(2, 1, 2);
plot(simlog_actFrc.Values.Time, simlog_actFrc.Values.Data, 'LineWidth', 1)
title('Actuator Force');
ylabel('Force (N)');
xlabel('Time (s)');
box on
grid on

linkaxes(simlog_handles, 'x')

% Remove temporary variables
clear simlog_t simlog_handles temp_colororder
clear simlog_actFrc simlog_qCmd simlog_qAil

