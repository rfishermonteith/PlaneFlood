function [intersectionEdge, originEdge dotNormal, distMin, distMax] = ...
    findAllIntersections(poly, endPoint,  vertices, edges, faces, faceOrder)

count = 1;
for i = 1:length(faces)
    if ~isequal(vertices(faces{i},:), originFace) % Ignore originFace
        [intersectionEdge{count}, originEdge{count} dotNormal(count), distMin(count), distMax(count)] =  isIntersect(poly, endPoint,  vertices, edges, faces{i});
        count = count+1;
    end
end