%the map variable here is using the normalization form coming out of Radio
%Mobile: 1 is worst and 99 is best

function [PDR PDR_vector] = PathPDR (nodes, map)
%{ 
For each pair of nodes
    Get RSSI
    convert to PDR
    multiply by total pdr
    return total pdr
%}

temp_pdr = 0;

temp_pdr = map(nodes(1,1),nodes(1,2));
%temp_pdr = rssi/99;
total_pdr = temp_pdr;
PDR_vector = total_pdr;

for (i=2:1:size(nodes,2)-1)
    temp_pdr = map(nodes(1,i),nodes(1,i+1));
    %temp_pdr = rssi/99;
    total_pdr = total_pdr*temp_pdr;
    PDR_vector = [PDR_vector temp_pdr];
end
PDR = total_pdr;



end