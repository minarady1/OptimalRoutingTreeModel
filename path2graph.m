%%Convert a path vector to an S T V structure that can be plotted as a
%%graph
%%Mina Rady, Orange Labs
function[s t w] =  path2graph(path,weights)
w = 0; t = w; s = t;
if(size(path,2)>1 && size(weights,2)== size(path,2)-1)
    s = path(1,1);
    t = path(1,2);
    w = weights(1,1);
    for (k=2:1:size(path,2)-1);
        new_s = path(1,k);
        new_t = path(1,k+1);
        new_w = weights( 1,k);
        s=[s new_s];
        t=[t new_t];
        w=[w new_w];
    end
end
end