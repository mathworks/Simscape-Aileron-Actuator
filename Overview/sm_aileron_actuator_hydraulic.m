%% Aileron Actuation System, Hydraulic Variant
% 
% This example models an actuation system for an aileron. The mechanical
% model was imported from CAD.  Different variants model hydraulic and
% electric actuation systems so that their performance can be compared at
% the system level.
%
% The hydraulic variant is described here, and the electric variant is
% described <matlab:web('sm_aileron_actuator_electric.html'); here>.
%
% Copyright 2018-2022 The MathWorks, Inc.



%% Model

open_system('sm_aileron_actuator')

set_param(find_system('sm_aileron_actuator','MatchFilter',@Simulink.match.allVariants,'FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Mechanical Subsystem
%
% The mechanical model of the aileron was created in a CAD system.  That
% CAD model was imported into Simscape Multibody, including the joints.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Mechanical','force'); Open Subsystem>

set_param('sm_aileron_actuator/Mechanical','LinkStatus','none')
open_system('sm_aileron_actuator/Mechanical','force')

%% Aileron_Att_1 Subsystem
%
% This subsystem shows the aileron and all of brackets that attach to the
% actuation system.  All rigidly attached parts are treated as a single
% part during dynamic simulation, so the vast number of screws and bolts do
% not impact the run time of the simulation.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Mechanical/Aileron_Att_1','force'); Open Subsystem>

set_param('sm_aileron_actuator/Mechanical/Aileron_Att_1','LinkStatus','none')
open_system('sm_aileron_actuator/Mechanical/Aileron_Att_1','force')

%% Actuator Subsystem
%
% Different variants enable different tests to be run within the same
% system level model.  The Motion variant prescribes the motion profile of
% the aileron and the simulation determines how much force is required to
% achieve that motion.  The Ideal variant can be tuned to reflect the
% behavior of a specific design.  The Hydraulic variant includes 3
% double-acting hydraulic cylinders on a single hydraulic network.  The
% Electric variant contains three leadscrews on a single electrical
% network.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Actuator','force'); Open Subsystem>

set_param('sm_aileron_actuator/Actuator','LinkStatus','none')
open_system('sm_aileron_actuator/Actuator','force')

%% Motion Actuation Subsystem
%
% This subsystem calculates the force required for the aileron to follow a
% motion profile.  The desired angle is converted to actuator extension
% using a polynomial calculated using the Curve Fitting Toolbox.  Simscape
% Multibody performs an inverse dynamics simulation to determine the force
% required to produce this motion.  Simulating with this variant helps
% determines the requirements for the actuation system.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Actuator/Motion','force'); Open Subsystem>

sm_aileron_actuator_configModel(bdroot,'Motion');
set_param('sm_aileron_actuator/Actuator/Motion','LinkStatus','none')
open_system('sm_aileron_actuator/Actuator/Motion','force')


%% Hydraulic Actuation Subsystem
%
% This subsystem models a hydraulic actuation system for the aileron. Three
% double-acting cylinders extend and contract to move the aileron to the
% desired angle.  Four-way directional valves adjust the flow of hydraulic
% fluid to the cylinders, and position of the valve spool is controlled by
% control system.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Actuator/Hydraulic','force'); Open Subsystem>

sm_aileron_actuator_configModel(bdroot,'Hydraulic');
set_param('sm_aileron_actuator/Actuator/Hydraulic','LinkStatus','none')
open_system('sm_aileron_actuator/Actuator/Hydraulic','force')

%% Simulation Results from Simscape Logging
%%
%
% The plot below shows the actuator force required to follow the desired
% trajectory.
%


sm_aileron_actuator_plot1forcereq;
%%
%
% The plots below compare the performance of the hydraulic and electric
% designs with the desired performance.
%


sm_aileron_actuator_plot2hydrelec;
%%

%clear all
close all
bdclose all
