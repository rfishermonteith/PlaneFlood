% Prototype 2
set(0,'DefaultFigureWindowStyle','docked')

close all
clear 

manifold = {};
edgesToCheck = {};

addpath(genpath(fullfile(fileparts(mfilename),'geom3d')))

%% Add obstacles (and start/end)

addObstacles

%% Begin algorithm
[manifold, edgesToCheck] = moveForward(startPoint, endPoint, [], vertices,...
    edges, faces, 'point', manifold, edgesToCheck);
count = 1;
while size(edgesToCheck,1)>=count
    [manifold, edgesToCheck] = moveForward(edgesToCheck{count,1},...
        endPoint, edgesToCheck{count,2}, vertices, edges, faces, 'edge', manifold, edgesToCheck);
    count = count+1;
end