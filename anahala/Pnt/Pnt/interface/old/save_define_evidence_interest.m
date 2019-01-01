global  evidence interest  list_evidence

if nbn==0
       errordlg('You shoud first specify the DAG structure');
else
if length(node_sizes)~=nbn
    errordlg('You shoud first quantify the network');
else
    

for i=1:nbn
col_tex = [1 1 1];
x=hand{i}.rec;
set(x,'color', 1-col_tex); drawnow;
y=hand{i}.tex;
set(y,'facecolor', col_tex); drawnow;
end

evidence = cell(1,nbn);
interest = cell(1,nbn);

%var_interest=[];
%instance_interest=[];

%----------------------------------------------choice of the evidence variables
question=sprintf('Select the observed nodes : ');
titre='Evidence';
mat_evidence=mat;

names=[];
for i=1:nbn
    names=[names mat_evidence{i}.name];
end  

[list_evidence,ok1]=listdlg('ListString',names','Name',titre,'PromptString',question, 'ListSize', [260 150]);

if ~isempty(list_evidence)


%----------------------------------------------choice of the instances of evidence
for i=1:length(list_evidence)
x=mat_evidence{list_evidence(i)}.name;
question=sprintf('Select the instance of the observed variable, %s : ',x);
titre='Evidence';
list_evidence(i)
z=[];
for j=1:node_sizes(list_evidence(i))
    t=strcat(x, '_', num2str(j));
    z{j}=t;
end

list_instance_evidence=[];
    
while isempty(list_instance_evidence) %we should choose an instance
    
[list_instance_evidence,ok1]=listdlg('ListString',z,'SelectionMode','single','Name',titre,'PromptString',question, 'ListSize', [260 150]);

end

evidence{list_evidence(i)}=list_instance_evidence;
col_tex = [0 0 1];
xx=hand{list_evidence(i)}.rec;
set(xx,'color', 1-col_tex); drawnow;
yy=hand{list_evidence(i)}.tex;
set(yy,'facecolor', col_tex); drawnow;

end

%----------------------------------------------choice of the variable of interest
mat_var_interest=[];
j=1;
for i=1:length(mat_evidence)
    if ~ismember(mat_evidence{i}.place,list_evidence)
        mat_var_interest{j}=mat_evidence{i};
        j=j+1;
    end
end

%mat_var_interest=[mat_evidence(1:list_evidence-1),mat_evidence(list_evidence+1:nbn)];
question=sprintf('Select variable(s) of interest : ');
titre='Variable(s) of interest';
names=[];
for i=1:length(mat_var_interest)
    names=[names mat_var_interest{i}.name];
end  
[list_var_interest,ok2]=listdlg('ListString',names','SelectionMode','single','Name',titre,'PromptString',question, 'ListSize', [260 150]);

if ~isempty(list_var_interest)
var_interest=mat_var_interest{list_var_interest}.place;
x=mat_var_interest{list_var_interest}.name;
col_tex_interest = [1 0 0];
xx=hand{var_interest}.rec;
set(xx,'color', 1-col_tex_interest); drawnow;
yy=hand{var_interest}.tex;
set(yy,'facecolor', col_tex_interest); drawnow;

%choice of the instance of interest
question=sprintf('Select the instance of interest, %s : ', x);
titre='Instance of interest';

z=[];
for j=1:node_sizes(var_interest)
    t=strcat(x, '_', num2str(j));
    z{j}=t;
end

[list_instance_interest,ok3]=listdlg('ListString',z,'SelectionMode','single','Name',titre,'PromptString',question, 'ListSize', [260 150]);
instance_interest=list_instance_interest;
end

end
end
end