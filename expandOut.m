function [manifold, edgesToCheck] = expandOut(currentPointEdge, currentFace, endPoint, vertices, edges, faces, pointOrEdge, manifold, edgesToCheck)


switch pointOrEdge
    case 'point'
        
    case 'edge'
end
fillPolygon3d(vertices{1}(faces{1}{currentFace},:))
manifold{end+1} = vertices{1}(faces{1}{currentFace},:);

% Find all edges of this face
%         currentEdges = combnk(faces{1}{firstStrikeFace},2);
currentEdges = edges{1}(all(ismember(edges{1}, faces{1}{currentFace}),2),:);

% From here, we don't care whether we're using a point or edge, since we
% know which edges we're dealing with
for i = 1:size(currentEdges,1)
    %isAdjacentFace = sum(ismember(cell2mat(faces{1}),currentEdges(i,:)),2)==2;
    %isAdjacentFace(firstStrikeFace) = 0; % Remove current face
    % Don't check originating edge
    
    currentEdge = vertices{1}(currentEdges(i,:),:);
    if all(size(currentPointEdge) == size(currentEdge)) && max(max(abs((currentPointEdge - currentEdge))))<0.001
    else
        edgesToCheck{end+1,1} = currentEdge;
        edgesToCheck{end,2} = vertices{1}(faces{1}{currentFace},:);
        %moveForward(currentEdge, endPoint, vertices, edges, faces, 'edge')
    end
end





