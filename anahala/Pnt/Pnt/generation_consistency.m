cap_max_consistency=[];
cap_nb_add_consistency=[];

temps0=[];
temps_consistency=[];  %save the time for one-neighbor

total_nb_links=0;
Ce=0;
tot1=0;
totj=0;

total_nb_example=100;

nb_example=0;

while nb_example <= total_nb_example % number of example
   
node_save=[];

disp('------------------One Example-----------------------------------')
sprintf('Example %d ',nb_example )

nb_nodes=40;
nb_parent_max=4;

dag = zeros(nb_nodes,nb_nodes);

for node=nb_nodes:-1:2
   
   N_parent=randperm(nb_parent_max+1); 	    	%to fix the parent number
   N_p=N_parent(1)-1;   						%the effective number of parents      
   %fix the list of possible parents
   L_poss_parents_final=[];
   L_poss_parents=randperm(nb_nodes);

   j=1;
   
   for l=1:length(L_poss_parents);
      if (L_poss_parents(l) < node) 
         L_poss_parents_final(j)=L_poss_parents(l);
         j=j+1;
      end
   end   
   
   N_p=min(N_p, length(L_poss_parents_final));
   
   list_parents=[];
   
   for k=1:N_p      
      list_parents(k)=L_poss_parents_final(k);
   end
     
   for lp=1:length(list_parents)
    dag(list_parents(lp),node)=1;
   end
   
end

%'------------------------------------------------------'

%to avoid disconnected nodes
for i=1:nb_nodes   
    
   ps=parents(dag,i);
   cs=children(dag,i);
   if isempty(ps) & isempty(cs)   
     if i==1
     N_children=randperm(nb_nodes); 	
     N_c=N_children(1);  
     if N_c ==1
         N_c=N_children(2);  
     end
     dag(i,N_c)=1;
     
     else  
       
     N_parent=randperm(i-1); 	
     N_p=N_parent(1);  
     dag(N_p,i)=1;
    end
    end
end

%'------------------------------------------------------'

%to avoid disconnected subgraphs

marked_nodes=nb_nodes;
selected_node=nb_nodes;
list_nodes=nb_nodes;
ps=parents(dag,nb_nodes);

for ll=1:length(ps)
    list_nodes(length(list_nodes)+1)=ps(ll);
end

while (length(marked_nodes)+1) <= length(list_nodes)
    selected_node=list_nodes(length(marked_nodes)+1);
    marked_nodes=[marked_nodes selected_node];
    ps=parents(dag,selected_node);
    cs=children(dag,selected_node);

    for ll=1:length(ps)
        if ~ismember(ps(ll),list_nodes)
           list_nodes(length(list_nodes)+1)=ps(ll);
        end
    end

    for ll=1:length(cs)
        if ~ismember(cs(ll),list_nodes)
           list_nodes(length(list_nodes)+1)=cs(ll);
        end
    end

end

if length(list_nodes)==nb_nodes  %connected

%'The DAG is connected'
    
%'------------------------------------------------------'

nodes = 1:nb_nodes;

%to fix the domain of variables
for node=1:nb_nodes
   if mod(node,2)==0
      node_sizes(node) = 2;
   else
      node_sizes(node) = 3;
   end
end

nb_links=length(find(dag==1));

total_nb_links=total_nb_links + nb_links;

%rapport=total_nb_links/ nb_nodes

pnet = mk_pnet(dag, node_sizes, nodes);

directed = 0;

if ~acyclic(pnet.dag, directed) %multiply
% 'The DAG is multiply connected'

nb_example = nb_example +1;
    

%names = {'1' ,    '2',     '3' ,    '4' ,    '5'}; 
%carre_rond = [1 1 1 1 1]; 
%draw_layout(pnet.dag,names,carre_rond);


%names = {'1' ,    '2',     '3' ,    '4' ,    '5' ,    '6' ,    '7' ,    '8'  ,   '9'  ,  '10'  ,  '11'  ,  '12'  ,  '13'  ,  '14'   , '15', '16', '17', '18', '19', '20'}; 
%carre_rond = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]; 
%draw_layout(pnet.dag,names,carre_rond);

    
%===========================Generation of the probability distribution======================

ns=node_sizes(:)';

for d=1:nb_nodes
  distribution=[];
  sauv=[];
  ps = parents(dag,d);
  l=length(ps);
  
  if l==0  
     distribution=[1];
     for v=1:(ns(d)-1)
       x=div((rand(1)*10000),100)/100;
        if x<0.03
           x=0; 
        end
        distribution = [distribution x]; %generation of a distribution with a max degree equal to 1
     end

     
  else 
     
     decalage=1;
     for m=1:l
        decalage=decalage*ns(ps(m)); %val de decalage
     end
     
     j=decalage*ns(d); % nb of values in the distribution   
    
     for i= 1:j
         x=div((rand(1)*10000),100)/100;
        if x<0.03
           x=0; 
        end
        distribution(i) = x;
     end
     
     for i=1:decalage
        if mod(i,2)==0
           distribution(i) =1;
        else
           distribution(i+decalage)=1;
        end
        
     end
     
 
end %if


for_save.node=d;
for_save.ps=parents(dag,d);
for_save.distribution=distribution;

node_save=[node_save for_save];

pnet.CPD{d} = tabular_CPD(pnet, d, distribution);

end


%---------------------------------------------------------------------------------------
evidence = cell(1,nb_nodes);

var=randperm(nb_nodes);
var_evidence1=var(1);            % relative � une evidence
var_evidence2=var(2);            % relative � une evidence

instance1=randperm(ns(var_evidence1));     % pour choisir la premi�re ou la deuxi�me valeur
instance2=randperm(ns(var_evidence2));
instance_evidence1=instance1(1);
instance_evidence2=instance2(2);

evidence{var_evidence1} = instance_evidence1;  
evidence{var_evidence2} = instance_evidence2;  

var_interest=var(4);
instance3=randperm(ns(var_interest));
instance_interest=instance3(2);

evidence_new=evidence;
evidence_new{var_interest} = instance_interest;  


%-------------------------------------ALGORITHMS-------------------------------------
%---------------------------------------------------------------------------------------


disp('----------------junction-------------');
engine = jtree_inf_engine(pnet);
tic; [engine] = global_propagation(engine, evidence); t0=toc;
temps0{nb_example}=t0;
%affichage pour A
marg = marginal_nodes(engine, var_interest);
BEL_Cdt_classique=marg.T(instance_interest)

disp('----------------new consistency-------------');
engine = MG_inf_engine(pnet);
tic; [Bel_Cdt_new, cap_max,nb_add] = global_propagation(engine, evidence_new, [], [],1, 1, 'neighbors'); t1=toc;
temps_consistency{nb_example}=t1;
cap_max_consistency{nb_example}=cap_max;
cap_nb_add_consistency{nb_example}=nb_add;

Bel_Cdt=Bel_Cdt_new


%----------------------------------------------------------------------------------
%pour le calcul de la moyenne des liens

average_links=total_nb_links/ total_nb_example;

end  %multiply

end %connected

end

average_links=total_nb_links/ total_nb_example;

%rapport=average_links / nb_nodes

save c:\anahla\consistency3 average_links temps0 temps_consistency cap_max_consistency cap_nb_add_consistency





