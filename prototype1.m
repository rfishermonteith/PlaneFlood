
close all
clear 

addpath(genpath(fullfile(fileparts(mfilename),'geom3d')))

%% Describe obstacles(by vertices)
vertices{1} = ...
    [20 20 20;...
    20 20 25;...
    20 25 20;...
    20 25 25;...
    25 20 20;...
    25 20 25;...
    25 25 20;...
    25 25 25];
edges{1} = [1 2; 1 3; 1 5; 5 6; 6 8; 8 4; 2 6; 2 4; 7 5; 7 3; 3 4; 7 8];
faces{1} = {[1 2 4 3];[ 1 5 6 2]; [7 8 6 5];[ 7 3 4 8];[3 7 5 1];[ 2 6 8 4]};

startPoint = [1 10 10];
endPoint = [50 45 40];

% Plot vertices
figure;hold on
plot3(vertices{1}(:,1), vertices{1}(:,2), vertices{1}(:,3), 'x')
for i = 1:size(vertices{1},1)
    
    str1 = ['\leftarrow ',num2str(i)];
    text(vertices{1}(i,1), vertices{1}(i,2), vertices{1}(i,3),str1);
    
end

xlim([0 110])
ylim([0 30])
zlim([0 80])
axis equal
view(3)
xlabel('x')
ylabel('y')
zlabel('z')

for i = 1:size(edges{1},1)
    a = edges{1}(i,:);
    %b = vertexJoining{1}(i,2);
    A = vertices{1}(a,:);
    plot3(A(:,1), A(:,2), A(:,3))
end


%% Create surfaces for faces

drawPolyhedron(vertices{1}, faces{1});

drawPoint3d(startPoint)
text(startPoint(1),startPoint(2), startPoint(3),'\leftarrow START');
drawPoint3d(endPoint)
text(endPoint(1),endPoint(2), endPoint(3),'\leftarrow END');

% Draw line from start to end
drawEdge3d([startPoint,  endPoint])

%% Begin algorithm

% Move from start towards the goal until you strike an object

% Find line paramterisation in the form [x y z]' = [a b c]' + t*[d e f]'
% or X = A + tB;

% for t = 1, [x y z] = endPoint
% for t = 0, [x y z] = startPoint
% therefore [a b c] = startPoint and [d e f] = endPoint - startPoint

A = startPoint;
B = endPoint-startPoint;

% Find smallest t value which intersects a face


line = [A,B];

for i = 1:length(faces{1})
    poly = vertices{1}(faces{1}{i},:);
    [inter(i,:), inside] = intersectLinePolygon3d(line, poly);
    if any(~isnan(inter(i,:)))
        tInter(i) = mean((inter(i,:) - A)./B);
    end
end

[firstStrikeT, firstStrikeFace] = min(tInter(tInter ~= 0));
firstStrikeX = inter(firstStrikeFace,:);


% Find all edges of this face
%currentEdges = edges{1}(faces{1}{firstStrikeFace}, :);
currentEdges = combnk(faces{1}{firstStrikeFace},2);

moveToThisFace = [];

% Create surface between these and the goal and check intersections
for i = 1:size(currentEdges,1)
   
    isAdjacentFace = sum(ismember(cell2mat(faces{1}),currentEdges(i,:)),2)==2;
    isAdjacentFace(firstStrikeFace) = 0; % Remove current face
    if any(isAdjacentFace)
        poly1 = vertices{1}(faces{1}{isAdjacentFace},:);
        poly2 = [vertices{1}(currentEdges(i,:),:);endPoint];
        [line, normal] = intersectPolygons3d(poly1, poly2);
        % Am I moving in the direction of the normal?
        lineToEnd = createLine3d(midPoint3d(...
            reshape(vertices{1}(currentEdges(i,:),:),[1,6])),endPoint);
        if dot(lineToEnd(4:6),normal) > 0 % Moving away from the adjacent face
            % Follow LOS
            disp(['Following LOS for edge ',mat2str(currentEdges(i,:))])
            moveToThisFace = [moveToThisFace,find(isAdjacentFace)];
        end
    end
end





