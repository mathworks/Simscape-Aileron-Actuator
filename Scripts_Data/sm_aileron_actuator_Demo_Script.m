%% Aileron Actuator Demo Script
%
% <html>
% <span style="font-family:Arial">
% <span style="font-size:10pt">
% <tr><b><u>Model</u></b><br>
% <tr>1.  <a href="matlab:open_system('sm_aileron_actuator');">Open Complete Aileron Model</a><br>
% <tr>2.  Model Mechanical System <a href="matlab:open_system('sm_aileron_actuator_mech_lib');smnew;">From Scratch</a>, <a href="matlab:open_system('sm_aileron_actuator_mech_01_ail');">Mechanism</a>, <a href="matlab:open_system('sm_aileron_actuator_mech_02_drive');">Determine Forces</a><br>
% <tr>3.  <a href="matlab:open_system('sm_aileron_actuator');hilite_system([bdroot '/Actuator']);">Link Specification and Design</a><br>
% <tr>4.  <a href="matlab:sm_aileron_actuator_plot1forcereq;">Determine Actuator Requirements</a>, (<a href="matlab:edit sm_aileron_actuator_plot1forcereq;">see code</a>)<br>
% <tr>5.  Model Mechanical System: <a href="matlab:open_system('sm_aileron_actuator_mech_lib');smnew;set_param([bdroot '/Mechanism Configuration'],'GravityVector','[0 -9.81 0]');aileronAssembly_DataFile;">From Scratch</a>, <a href="matlab:open_system('sm_aileron_actuator_mech_01_ail');">Mechanical System</a>, <a href="matlab:open_system('sm_aileron_actuator_mech_02_drive');">With Ideal Actuator</a><br>
% <tr>6.  Model Electromechanical Actuator: <a href="matlab:open_system('sm_aileron_actuator_mech_lib');ssc_new;">From Scratch</a>, <a href="matlab:open_system('sm_aileron_actuator_electric_1_drive');">Electric Actuator</a>, <a href="matlab:open_system('sm_aileron_actuator_electric_2_mech');">With Aileron</a><br>
% <tr>7.  Estimating Parameters:<br>
% <tr>....a. <a href="matlab:cd(fileparts(which('Motor_Param_Est.slx')));open_system('Motor_Param_Est');">Electric Motor</a><br>
% <tr>....b. <a href="matlab:cd(fileparts(which('Hydraulic_System_Param_Est.slx')));open_system('Hydraulic_System_Param_Est');">Hydraulic System</a><br>
% <tr>8.  <a href="matlab:cd(fileparts(which('Custom_Analog_Filter.slx')));open_system('Custom_Analog_Filter');">Customize Component</a><br>
% <br>
% <tr><b><u>Simulate</u></b><br>
% <tr>9.  <a href="matlab:sm_aileron_actuator_plot2hydrelec;">Test Electrical and Hydraulic Designs</a>, (<a href="matlab:edit sm_aileron_actuator_plot2hydrelec;">see code</a>)<br>
% <tr>10.  <a href="matlab:open_system('sm_aileron_actuator');sm_aileron_actuator_resp_opt;">Optimize System Performance (Electric or Hydraulic)</a>, (<a href="matlab:edit sm_aileron_actuator_resp_opt;">see code</a>)<br>
% <tr>11. Assess Implementation Effects<br>
% <tr>....a. <a href="matlab:sm_aileron_actuator_plot3ctrlcirc;">Compare Abstract and Circuit Controllers</a>, (<a href="matlab:edit sm_aileron_actuator_plot3ctrlcirc;">see code</a>)<br>
% <tr>....b. <a href="matlab:sm_aileron_actuator_plot4ctrlcircavgpwm;">Compare Average and PWM Modes</a>, (<a href="matlab:edit sm_aileron_actuator_plot4ctrlcircavgpwm;">see code</a>)<br>
% <tr>12. <a href="matlab:cd(fileparts(which('sm_aileron_actuator_PCT_Sim.m')));edit sm_aileron_actuator_PCT_Sim;">Distribute Simulations Using Parallel Computing</a><br>
% <br>
% <tr><b><u>Deploy</u></b><br>
% <tr>13. Real-Time Simulation</a><br>
% <tr>....a. <a href="matlab:cd(fileparts(which('sm_aileron_actuator_SLRT_elec.m')));edit sm_aileron_actuator_SLRT_elec">Electric Actuator</a><br>
% <tr>....b. <a href="matlab:cd(fileparts(which('sm_aileron_actuator_SLRT_hydr.m')));edit sm_aileron_actuator_SLRT_hydr">Hydraulic Actuator</a><br>
% <tr>14. <a href="matlab:cd(fileparts(which('sm_aileron_actuator_IP_Protect.m')));edit sm_aileron_actuator_IP_Protect">Protect IP To Share Model</a>, <a href="matlab:cd(fileparts(which('sm_aileron_actuator_IP_Protect.m')));cd('Finish');sm_aileron_actuator_open_system('sm_aileron_actuator_protected');">Open Protected Model</a><br>
% </style>
% </style>
% </html>
% 

% Copyright 2012-2022 The MathWorks(TM), Inc.

