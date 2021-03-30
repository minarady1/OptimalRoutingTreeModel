%%Mina Rady, Orange Labs, 2019
%Load Vars
load ('LR_RadioMap.mat')
exp_label = 'PDR_METRIC'
NETWORK_SIZE=1561
leaves = 1:1:NETWORK_SIZE 
roots = [857] 
save_stats = 1
RawMap = map -50;
RawMap (RawMap<0)=0;
RawMap = RawMap /50;
%RawGraph = graph (100-map) %reversing the values so good RSSI will have smaller weight

path_v= 0;
relay_v=0;
pdr_v=0 ;
hops_v = 0;
d_v=0;
%vectors for the communication graph plot
s_v = 0; t_v = s_v ; w_v=s_v;
counter = 1;



% for each leaf and destination: find the shortest path
for (l=1:1:size(leaves,2))
    for (r=1:1:size(roots,2))
        if (leaves(1,l)~= roots(1,r))
            [d, path] = dijkstra(RawMap,leaves(1,l),roots(1,r));
            %[path,d] = shortestpath(RawGraph,leaves(1,l),roots(1,r));
            %highlight(p,path,'EdgeColor','r','LineWidth', 3)
            if (l==1 &&r==1)
                path_v ={path}; d_v=d; hops_v = size(path,2);
                [pdr temp_pdr_v] = PathPDR(path,1-RawMap);
                %[pdr temp_pdr_v] = PathPDR(path,map);
                [s_v t_v w_v] = path2graph(path,temp_pdr_v);

            else
                %add path to path vector
                path_v = [path_v;{path}];

                %compute path pdr
                [pdr temp_pdr_v] = PathPDR(path,RawMap);
                %[pdr temp_pdr_v] = PathPDR(path,map);
                %convert path to three graph arrays to be plottd
                [s t w] = path2graph(path,temp_pdr_v);
                s_v = [s_v s];
                t_v = [t_v t];
                w_v = [w_v w];

                %add hop count to hops vector
                hops_v = [hops_v;size(path,2)-1];

                %add path cost to cost vector 
                d_v = [d_v;d];

                %add path pdr to pdr vector
                pdr_v = [pdr_v; PathPDR(path,1-RawMap)];
            end
            %Expand relay vector
            if(size(path,2)>2) %if there are intermediary hops
                if (relay_v==0)
                    relay_v = path(:,2:size(path,2)-1);
                else
                    relay_v = [relay_v path(:,2:size(path,2)-1)];
                end
            end
        end
    end
end

% plot communication graph, include xy dimensions
figure(1);
figure('units','normalized','outerposition',[0 0 1 1])
clf;
% declare topology
%create matrix to filter the double edges

Edges = [s_v' t_v'];
%this is to make sure that duplicate edges that are reversed appear the
%same
Edges = sort(Edges,2);
MeshMatrix = [Edges w_v'];
[C, ia, ic] =unique(MeshMatrix(:,1:2),'rows');
UniqueMeshMatrix = MeshMatrix(ia,:);
s_v = UniqueMeshMatrix(:,1)';
t_v = UniqueMeshMatrix(:,2)';
w_v = UniqueMeshMatrix(:,3)';

%% The resulting optimal "mesh" for on sink is a actually a tree. This is because at each hop, there is only one optimal hop forward!

%create tabulation for relay statistics
relay_freq = tabulate(relay_v);
%sort table by relay load
sorted_relay_freq = sortrows(relay_freq,3,'desc');
 fig_index = 0
%highlighting the high load relays
% fig_index++
% f= figure (fig_index);
% MeshGraph = graph(s_v,t_v,w_v);
% figure(1);
% clf;
% hold on;
% plot(MeshGraph,'XData',mapXdata(1:NETWORK_SIZE,1),'YData',mapYdata(1:NETWORK_SIZE,1),'ZData',mapZdata(1:NETWORK_SIZE,1),'EdgeCData',MeshGraph.Edges.Weight);
% %highlight roots in the plot
% for (r=1:1:size(roots,2))
% scatter3 (mapXdata(roots(1,r),:),mapYdata(roots(1,r),:),mapZdata(roots(1,r),:),50,'Marker','o','MarkerFaceColor',[0.8500 0.3250 0.0980]);
% end
% 
% hl_relays = sorted_relay_freq(1:10,1)';
% for (r=1:1:10)
% scatter3 (mapXdata(hl_relays(1,r),:),mapYdata(hl_relays(1,r),:),mapZdata(hl_relays(1,r),:),70,'Marker','s','MarkerFaceColor',[0.3010 0.7450 0.9330]);
% end
% hold off;
% colorbar;
% colormap(flipud(jet));
% t = title({'Network (Geo-)Logical Topology for ', char(exp_label)});
% set(t, 'Interpreter', 'none');%to remove latex interpreter for underscores
% %exp_label is set in the Orchestrator
% saveas(f,strcat('Figures/',char(exp_label),'_TopologyPlot.fig'));
% saveas(f,strcat('Figures/',char(exp_label),'_TopologyPlot.png'));
% 

fig_index =fig_index+1
f= figure (fig_index);
hold on;
%figure('units','normalized','outerposition',[0 0 1 1])

[pdr_d,x_pdr] = hist(pdr_v,100); %look at the bins parameter
%exp_label is set in the Orchestrator
plot (x_pdr,pdr_d/sum(pdr_d),'DisplayName',char(exp_label));
title({'PDF for Naive End to End PDR in ', ' Assuming Perfect Sync'});
hold off;
xlabel('Naive End to End PDR');
ylabel('Probability');
leg = legend;
set(leg, 'Interpreter', 'none');%to remove latex interpreter for underscores
if (save_stats==1)
saveas(f,[pwd '\Figures\' exp_label '_PDF_E2E_PDR.fig']);
saveas(f,[pwd '\Figures\' exp_label '_PDF_E2E_PDR.png']);

end
fig_index =fig_index+1
f= figure (fig_index);
hold on;
%figure('units','normalized','outerposition',[0 0 1 1])

[hops_d,x_hops] = hist(hops_v,20); 
plot (x_hops,hops_d/sum(hops_d),'DisplayName',char(exp_label));
%xlim([0 20]);
%xticks([1:1:20]);
xlabel('Number of Path Hops');
ylabel('Probability');
%histogram (hops_v);
title('PDF for Number of Hops in the Network');
hold off;
leg = legend;
set(leg, 'Interpreter', 'none');%to remove latex interpreter for underscores
if (save_stats==1)
saveas(f,[pwd '\Figures\' exp_label '_PDF_Hops.fig']);
saveas(f,[pwd '\Figures\' exp_label '_PDF_Hops.png']);
end

%Plot Load Saturation on Relays
fig_index =fig_index+1
f= figure (fig_index);
hold on;
%figure('units','normalized','outerposition',[0 0 1 1])

relay_membership = sorted_relay_freq(:,2);
[relay_membership_d,x_relay_membership] = hist(relay_membership,100); 
plot (x_relay_membership,relay_membership_d/sum(relay_membership_d),'DisplayName',char(exp_label));
title({'PDF for Relay Load in terms of the Number of Path Memberships','Assuming Perfect Sync'});
hold off;
xlabel('Number of Relay Path Memberships');
ylabel('Probability');
leg = legend;
set(leg, 'Interpreter', 'none');%to remove latex interpreter for underscores
if (save_stats==1)
saveas(f,[pwd '\Figures\' exp_label '_PDF_RelayLoad.fig']);
saveas(f,[pwd '\Figures\' exp_label '_PDF_RelayLoad.png']);
end
%Plot Inerference at the relay




