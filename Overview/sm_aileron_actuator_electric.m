%% Aileron Actuation System, Electric Variant
% 
% This example models an actuation system for an aileron. The mechanical
% model was imported from CAD.  Different variants model hydraulic and
% electric actuation systems so that their performance can be compared at
% the system level.
%
% The electric variant is described here, and the hydraulic variant is
% described <matlab:web('sm_aileron_actuator_hydraulic.html'); here>.
%
% Copyright 2018-2021 The MathWorks, Inc.



%% Model

open_system('sm_aileron_actuator')

set_param(find_system('sm_aileron_actuator','FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

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
% required to produce this motion. Simulating with this variant helps
% determines the requirements for the actuation system.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Actuator/Motion','force'); Open Subsystem>

sm_aileron_actuator_configModel(bdroot,'Motion');
set_param('sm_aileron_actuator/Actuator/Motion','LinkStatus','none')
open_system('sm_aileron_actuator/Actuator/Motion','force')


%% Electric Actuation Subsystem
%
% This subsystem models an actuation system for the aileron. Three
% electrically-driven leadscrews extend and contract to move the aileron to
% the desired angle.  The leadscrews are all on the same electrical
% network. The implementation of the controller and fidelity of the drive
% circuit can be adjusted in the mask.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Actuator/Electric','force'); Open Subsystem>

sm_aileron_actuator_configModel(bdroot,'E SL Avg');
set_param('sm_aileron_actuator/Actuator/Electric','LinkStatus','none')
open_system('sm_aileron_actuator/Actuator/Electric','force')


%% Speed Controller Subsystem, Simulink Variant
%
% This subsystem models the speed controller for the leadscrew.  This
% variant implements the controller using Simulink blocks.  This enables
% rapid adjustment of contoller structure and gains.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Actuator/Electric/Leadscrew%201/Control/Simulink/Speed%20Controller','force'); Open Subsystem>

set_param('sm_aileron_actuator/Actuator/Electric/Leadscrew 1','LinkStatus','none')
open_system('sm_aileron_actuator/Actuator/Electric/Leadscrew 1/Control/Simulink/Speed Controller','force')

%% Speed Controller Subsystem, Circuit Variant
%
% This subsystem models the speed controller for the leadscrew.  This
% variant implements the controller as an analog circuit.  This enables the
% use of simulation to determine the effect of this implementation on
% system performance.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Actuator/Electric/Leadscrew%201/Control/Circuit/Speed%20Controller','force'); Open Subsystem>

sm_aileron_actuator_configModel(bdroot,'E Cir Avg');
set_param('sm_aileron_actuator/Actuator/Electric/Leadscrew 1/Control/Circuit/Speed Controller','LinkStatus','none')
open_system('sm_aileron_actuator/Actuator/Electric/Leadscrew 1/Control/Circuit/Speed Controller','force')

%% Motor Driver Subsystem, Circuit Variant
%
% This subsystem models the motor driver using power electronics.  This
% variant would be used to analyze the timing of the power electronic
% controller and the power dissipated by the power electronics.
%
% <matlab:open_system('sm_aileron_actuator');open_system('sm_aileron_actuator/Actuator/Electric/Leadscrew%201/Control/Circuit/Speed%20Controller','force'); Open Subsystem>

sm_aileron_actuator_configModel(bdroot,'E Cir Cir');
set_param('sm_aileron_actuator/Actuator/Electric/Leadscrew 1/Motor Driver/Circuit','LinkStatus','none')
open_system('sm_aileron_actuator/Actuator/Electric/Leadscrew 1/Motor Driver/Circuit','force')

%%
open_system('sm_aileron_actuator/Actuator/Electric/Leadscrew 1/Motor Driver/Circuit/LegPu','force')

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
