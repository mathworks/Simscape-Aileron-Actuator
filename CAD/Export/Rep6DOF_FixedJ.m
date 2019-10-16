mdl = 'aileronAssembly';
sixdofPth = find_system(mdl,'ReferenceBlock','sm_lib/Joints/6-DOF Joint');

for i=1:length(sixdofPth)
%    replace_block(mdl,char(sixdofPth{i}),[mdl '/Weld Joint'],'noprompt');
    replace_block(mdl,'Name',get_param(char(sixdofPth{i}),'Name'),'sm_lib/Joints/Weld Joint','noprompt');

end

replace_block(mdl,'Name',get_param(char(sixdofPth{i}),'Name'),'sm_lib/Joints/Weld Joint','noprompt');

