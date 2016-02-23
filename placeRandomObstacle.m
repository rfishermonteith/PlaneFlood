function [vertices, edges, faces] = placeRandomObstacle(len, bounds)

X1 = ((bounds(:,2)-bounds(:,1)).*rand(3,1)+bounds(:,1))';
theta = 2*pi*rand(3,1);

[vertices, edges, faces] = createCube3d(len, X1, theta);
