%% OPEN AND CONFIGURE MODEL
mdl = 'Aileron_EH_LS_Hydr';     % Hydraulic
open_system(mdl);

open_system([bdroot '/Final Values']);  % LOAD TUNED VALUES
%open_system([bdroot '/Vis Off']);       % VISUALIZATION OFF
open_system([bdroot '/tictoc']);        % TIME SIMULATION
sim_time_length = 50;
clc

%% FIND SOLVER CONFIGURATION BLOCKS
SolverConfigBlock_paths = [find_system(bdroot,'LookUnderMasks','all','FollowLinks','on','UseLocalSolver','off'); find_system(bdroot,'LookUnderMasks','all','FollowLinks','on','UseLocalSolver','on')];

% PREPARE FOR VARIABLE-STEP SIMULATION 
% TURN LOCAL SOLVERS AND FIXED COST OFF
set_param(gcs,'Solver','ODE15s')

for i=1:length(SolverConfigBlock_paths)
    set_param(char(SolverConfigBlock_paths(i)),'UseLocalSolver','off','DoFixedCost','off');
end

% SIMULATE VARIABLE STEP 
disp('Running variable-step simulation...');
sim(bdroot, sim_time_length, simset(simget(bdroot), 'Solver', 'ODE15s'))
disp('Simulation complete.');
disp(' ');

% SAVE SIMULATION RESULTS INTO LOCAL VARIABLES
time_vs = Aileron_EH_Force_DATA.time;
Force_Data_vs = Aileron_EH_Force_DATA.signals(1).values;
Angle_Data_vs = Aileron_EH_Angle_DATA.signals(1).values(:,1);
Sim_time_vs = Elapsed_Sim_Time;

% PREPARE FOR FIXED-STEP SIMULATION, NO LOCAL SOLVERS
% TURN LOCAL SOLVERS OFF, FIXED COST ON
for i=1:length(SolverConfigBlock_paths)
    set_param(char(SolverConfigBlock_paths(i)),'UseLocalSolver','off','DoFixedCost','on');
end

% SIMULATE FIXED-STEP, NO LOCAL SOLVERS
disp('Running fixed-step simulation, global stiff implicit solver only...');
open_system([bdroot '/Real Time Settings']);
sampletime = get_param(char(SolverConfigBlock_paths(1)),'LocalSolverSampleTime');
open_system([bdroot '/Desktop Settings']);
sim(bdroot, sim_time_length, simset(simget(bdroot), 'Solver', 'ODE14x', 'FixedStep',str2num(sampletime)));
disp('Simulation complete.');
disp(' ');

% SAVE SIMULATION RESULTS INTO LOCAL VARIABLES
time_nols = Aileron_EH_Force_DATA.time;
Force_Data_nols = Aileron_EH_Force_DATA.signals(1).values;
Angle_Data_nols = Aileron_EH_Angle_DATA.signals(1).values(:,1);
Sim_time_nols = Elapsed_Sim_Time;

% PREPARE FOR FIXED-STEP SIMULATION WITH LOCAL SOLVERS
% TURN LOCAL SOLVERS ON, FIXED COST ON
open_system([bdroot '/Real Time Settings']);

% SIMULATE FIXED-STEP WITH LOCAL SOLVERS
disp('Running fixed-step simulation with local solver (Backward Euler)...');
sim(bdroot, sim_time_length, simset(simget(bdroot)))
disp('Simulation complete.');
disp(' ');

% SAVE SIMULATION RESULTS INTO LOCAL VARIABLES
time_ls = Aileron_EH_Force_DATA.time;
Force_Data_ls = Aileron_EH_Force_DATA.signals(1).values;
Angle_Data_ls = Aileron_EH_Angle_DATA.signals(1).values(:,1);
Sim_time_ls = Elapsed_Sim_Time;

% PREPARE FOR FIXED-STEP SIMULATION WITH LOCAL SOLVERS
% TURN LOCAL SOLVERS ON, FIXED COST ON
open_system([bdroot '/Real Time Settings']);
for i=1:length(SolverConfigBlock_paths)
    set_param(char(SolverConfigBlock_paths(i)),...
        'LocalSolverChoice','NE_TRAPEZOIDAL_ADVANCER');
end

% SIMULATE FIXED-STEP WITH LOCAL SOLVERS
disp('Running fixed-step simulation with local solver (Trapezoidal)...');
sim(bdroot, sim_time_length, simset(simget(bdroot)))
disp('Simulation complete.');
disp(' ');

% SAVE SIMULATION RESULTS INTO LOCAL VARIABLES
time_lst = Aileron_EH_Force_DATA.time;
Force_Data_lst = Aileron_EH_Force_DATA.signals(1).values;
Angle_Data_lst = Aileron_EH_Angle_DATA.signals(1).values(:,1);
Sim_time_lst = Elapsed_Sim_Time;

% PLOT RESULTS FROM ALL THREE SIMULATIONS
colordef black;
figure(1);
clf;

%set(gcf,'Position',[765   405   449   336]);
set(gcf,'Position',[532   334   449   272]);

A_vs_h = plot(time_vs,Angle_Data_vs,'color','y','LineWidth',3);
hold on;
A_nols_h = stairs(time_nols,Angle_Data_nols,'color','m','LineStyle','-.','LineWidth',3);
A_ls_h = stairs(time_ls,Angle_Data_ls,'color','c','LineStyle',':','LineWidth',3);
A_lst_h = stairs(time_lst,Angle_Data_lst,'color','r','LineStyle',':','LineWidth',3);
title_h = title('Angle (deg)');
set(title_h,'FontSize',14);
xlabel_h = xlabel('Time (s)','FontSize',12);
ylabel_h = ylabel('Angle (deg)','FontSize',12);
grid on
set(gca,'Box','on');
LegendText = {['Variable Step                       Sim Time = ' num2str(Sim_time_vs,3) 's'], ...
              ['Fixed Step                           Sim Time = ' num2str(Sim_time_nols,3) 's'],...
              ['Fixed Step, Local Solver (be) Sim Time = ' num2str(Sim_time_ls,3) 's'],...
              ['Fixed Step, Local Solver (t)    Sim Time = ' num2str(Sim_time_lst,3) 's']};
leg_h = legend(LegendText,'Location','South','FontSize',10);
axis([0 time_ls(end) -10 20]);

colordef white;
% Copyright 2012-2020 The MathWorks(TM), Inc.

