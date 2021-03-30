%---------------------------------------------------
% Dijkstra Algorithm
% author : Dimas Aryo
% email : mr.dimasaryo@gmail.com
%
% usage
% [cost rute] = dijkstra(Graph, source, destination)
% 
% example
% G = [0 3 9 0 0 0 0;
%      0 0 0 7 1 0 0;
%      0 2 0 7 0 0 0;
%      0 0 0 0 0 2 8;
%      0 0 4 5 0 9 0;
%      0 0 0 0 0 0 4;
%      0 0 0 0 0 0 0;
%      ];
% [e L] = dijkstra(G,1,7)
%---------------------------------------------------
function [cost path] = dijkstra(Map,source,root )

if source==root
    cost=0;
    path=[source];
else

Map = setupgraph(Map,0,1);%%replace zeros with 0

if root==1
    root=source;
end
Map=exchangenode(Map,1,source);

NodesCount=size(Map,1);
Weights=zeros(NodesCount);
for i=2 : NodesCount
    Weights(1,i)=i;
    Weights(2,i)=Map(1,i);
end

for i=1 : NodesCount
    ChildNodes(i,1)=Map(1,i);
    ChildNodes(i,2)=i;
end

SortedChildNodes=ChildNodes(2:length(ChildNodes),:);
path=2;
while path<=(size(Weights,1)-1)
    path=path+1;
    SortedChildNodes=sortrows(SortedChildNodes,1);
    Hop =SortedChildNodes(1,2); %take the least cost path
    Weights(path,1)=Hop; %add next hop to the path
    SortedChildNodes(1,:)=[];% remove the hope from the next hop list

    for i=1 : size(SortedChildNodes,1)
        CurrentCost = ChildNodes(SortedChildNodes(i,2),1);
        pre_cost = ChildNodes(Hop,1);
        child = SortedChildNodes(i,2);
        post_cost = Map(Hop,child);
        NewCost = pre_cost*post_cost;
 
        if (NewCost) < (CurrentCost) %%cost is benefit here so reversed it.
            ChildNodes(SortedChildNodes(i,2),1) = NewCost; %update the cost
            SortedChildNodes(i,1) = CurrentCost;
        end
    end
    
    for i=2 : length(Map)
        Weights(path,i)=ChildNodes(i,1);
    end
end
if root==source
    path=[1];
else
    path=[root];
end
cost=Weights(size(Weights,1),root);
path = listdijkstra(path,Weights,source,root);
end