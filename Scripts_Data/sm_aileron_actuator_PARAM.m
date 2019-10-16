AAC_Param.Act.Id.Spr.k  = 10000;
AAC_Param.Act.Id.Spr.l0 = -0.076/3; 
AAC_Param.Act.Id.Spr.b  = 5e4/3; 

AAC_Param.Act.Hy.Spr.k  = 10000;
AAC_Param.Act.Hy.Spr.l0 = -0.076/3; 
AAC_Param.Act.Hy.Spr.b  = 5e4/3; 

AAC_Param.Act.Hy.fr.visc    = 0.1; 
AAC_Param.Act.Hy.fr.brkf    = 1; 
AAC_Param.Act.Hy.fr.brkv    = 0.01; 
AAC_Param.Act.Hy.fr.colf    = 0.5; 

AAC_Param.Act.Hy.vl.maxo    = 0.005;
AAC_Param.Act.Hy.vl.maxa    = 1e-5;
AAC_Param.Act.Hy.vl.pax0    = -1e-6;
AAC_Param.Act.Hy.vl.pbx0    = -1e-6;
AAC_Param.Act.Hy.vl.atx0    = -1e-6;
AAC_Param.Act.Hy.vl.btx0    = -1e-6;

AAC_Param.Act.Hy.pa0        = 1e6;      % Pa
AAC_Param.Act.Hy.pb0        = 1e6;      % Pa
AAC_Param.Act.Hy.x0         = 0.035028; % m


AAC_Param.Act.Hy.deadvol    = 1e-6;
AAC_Param.Piston.d      = 0.019; % m 
AAC_Param.Piston.area   = (AAC_Param.Piston.d/2)^2*pi;
AAC_Param.Piston.stroke = 0.06;

AAC_Param.Act.El.Spr.k  = 10000;
AAC_Param.Act.El.Spr.l0 = -0.076/3; 
AAC_Param.Act.El.Spr.b  = 5e4/3; 

AAC_Param.Act.El.motk   = 0.072e-3*50; % V/rpm

AAC_Param.AilBrk.LRManual4Vis = 1e-5;

% INITIAL CONTROLLER PARAMETER VALUES
Kp = 0.3;
Ki = 0.3;

Ki_scaling_elec = 1;

% Optimized Values ELECTRIC
%Kp = 0.6526
%Ki = 0.4933

% Optimized Values HYDRAULIC
%Kp = 0.3370
%Ki = 0.3935

hydr_supply_pressure        = 2.0e6; % Pa

motor_gear_ratio = 5;
motor_friction = 0;


% Mechanical parameters
piston_radius = 0.01;
piston_length = 0.15;

cyl_radius = 0.012;
cyl_length = 0.155;

actbase_x = -0.204;
actbase_y =  0.022;

R7_sctrl  = 150;  % kOhm
