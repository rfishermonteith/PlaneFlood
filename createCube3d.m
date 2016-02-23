function [vertices, edges, faces] = createCube3d(len, X1, theta)

cube = createCube();
points = cube.vertices*len;
edges = cube.edges;
faces = cube.faces;
for i = 1:size(faces,1)
    tempFaces{i,1} = faces(i,:);
end
faces = tempFaces;
% X0 = [0,0,0];
% 
% points = [X0;...
%     X0+len*[0 0 1];...
%     X0+len*[0 1 0];...
%     X0+len*[0 1 1];...
%     X0+len*[1 0 0];...
%     X0+len*[1 0 1];...
%     X0+len*[1 1 0];...
%     X0+len*[1 1 1]];
% 
% edges = [1 2; 1 3; 1 5; 5 6; 6 8; 8 4; 2 6; 2 4; 7 5; 7 3; 3 4; 7 8];
% faces = {[1 2 4 3];[ 1 5 6 2]; [7 8 6 5];[ 7 3 4 8];[3 7 5 1];[ 2 6 8 4]};


vertices = (createRotationOx(theta(1))*createRotationOy(theta(2))*createRotationOz(theta(3))*[points,zeros(size(points,1),1)]')';
vertices = vertices(:,1:3);
vertices = vertices+repmat(X1,size(vertices,1),1);
