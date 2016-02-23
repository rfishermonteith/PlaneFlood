% addObstacles

x = randi(10000);
rng(x);

numObstacles = 15;
len = 10;
vertices = [];
edges = [];
faces = [];

for i = 1:numObstacles
    [verticesTemp, edgesTemp, facesTemp] = placeRandomObstacle(len,[0 50;0 30;0 40]);
    vertices = [vertices;verticesTemp];
    numVertices = max(max((edges)));
    if isempty(numVertices)
        numVertices = 0;
    end
    edges = [edges;edgesTemp+numVertices];
    for k = 1:length(facesTemp)
        tempFaces{k} = facesTemp{k}+numVertices;
    end
    faces = [faces;tempFaces'];
end

% vertices{1} = ...
%     [20 20 20;...
%     20 20 25;...
%     20 25 20;...
%     20 25 25;...
%     25 20 20;...
%     25 20 25;...
%     25 25 20;...
%     25 25 25];
% edges{1} = [1 2; 1 3; 1 5; 5 6; 6 8; 8 4; 2 6; 2 4; 7 5; 7 3; 3 4; 7 8];
% faces{1} = {[1 2 4 3];[ 1 5 6 2]; [7 8 6 5];[ 7 3 4 8];[3 7 5 1];[ 2 6 8 4]};
% 
% vertices{2} = ...
%     [30 30 30;...
%     30 30 35;...
%     30 35 30;...
%     30 35 35;...
%     35 30 30;...
%     35 30 35;...
%     35 35 30;...
%     35 35 35];
% edges{2} = [1 2; 1 3; 1 5; 5 6; 6 8; 8 4; 2 6; 2 4; 7 5; 7 3; 3 4; 7 8];
% faces{2} = {[1 2 4 3];[ 1 5 6 2]; [7 8 6 5];[ 7 3 4 8];[3 7 5 1];[ 2 6 8 4]};
% 
% % Try joining into 1 set of matrices
% vertices = [vertices{1};vertices{2}];
% numVertices = max(max((edges{1})))
% edges = [edges{1};edges{2}+numVertices];
% for i = 1:length(faces{2})
% tempFaces{i} = faces{2}{i}+numVertices;
% end
% faces = [faces{1};tempFaces'];

startPoint = [1 10 10];
endPoint = [50 40 40];

% Plot vertices
figure;hold on
plot3(vertices(:,1), vertices(:,2), vertices(:,3), 'x')
for i = 1:size(vertices,1)
    
    str1 = ['\leftarrow ',num2str(i)];
    text(vertices(i,1), vertices(i,2), vertices(i,3),str1);
    
end

xlim([0 60])
ylim([0 30])
zlim([0 50])
axis equal
view(3)
xlabel('x')
ylabel('y')
zlabel('z')

for i = 1:size(edges,1)
    a = edges(i,:);
    %b = vertexJoining{1}(i,2);
    A = vertices(a,:);
    plot3(A(:,1), A(:,2), A(:,3))
end


%% Create surfaces for faces

drawPolyhedron(vertices, faces);


drawPoint3d(startPoint)
text(startPoint(1),startPoint(2), startPoint(3),'\leftarrow START');
drawPoint3d(endPoint)
text(endPoint(1),endPoint(2), endPoint(3),'\leftarrow END');

% Draw line from start to end
drawEdge3d([startPoint,  endPoint])

save('xSeed.mat','x')