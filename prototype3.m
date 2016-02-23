% Prototype 3
set(0,'DefaultFigureWindowStyle','docked')

close all
clear 

manifold = {};
edgesToCheck = {};

addpath(genpath(fullfile(fileparts(mfilename),'geom3d')))

%% Add obstacles (and start/end)

addObstacles4

%% Begin algorithm
[manifold, edgesToCheck] = extendEdgeTowardGoal(startPoint, endPoint, [], vertices,...
    edges, faces, manifold, edgesToCheck, []);
% h = gca;
% figure;f = gca;drawRemainingEdges(edgesToCheck,1)
% axes(h)
count = 1;
while size(edgesToCheck,1)>=count
    if length(edgesToCheck(count,:)) == 2 
        faceOrder = [];
    else
        faceOrder = edgesToCheck{count,3};
    end
    % Display edge
%     tempH = drawEdge3d([edgesToCheck{count,1}(1,:),edgesToCheck{count,1}(2,:)],'color','yellow', 'linewidth',8);
%     tempH.delete;
    [manifold, edgesToCheck] = extendEdgeTowardGoal(edgesToCheck{count,1},...
        endPoint, edgesToCheck{count,2}, vertices, edges, faces, manifold,...
        edgesToCheck, faceOrder);
   
    
    count = count+1;
    edgesToCheck = removeDuplicates(edgesToCheck,count);
%     axes(f)
%     cla
%     drawRemainingEdges(edgesToCheck,count)
%     axes(h)
    disp(['count: ', num2str(count),', edgesToCheck: ',num2str(length(edgesToCheck))])
end
