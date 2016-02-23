function [manifold, edgesToCheck] = findEdgesOfCurrentFace(originEdge, currentFace, endPoint, vertices, edges, faces, manifold, edgesToCheck)

fillPolygon3d(vertices(faces{currentFace},:))
manifold{end+1} = vertices(faces{currentFace},:);

% Find all edges of this face
%         currentEdges = combnk(faces{1}{firstStrikeFace},2);
currentEdges = edges(all(ismember(edges, faces{currentFace}),2),:);

% From here, we don't care whether we're using a point or edge, since we
% know which edges we're dealing with
for i = 1:size(currentEdges,1)
    %isAdjacentFace = sum(ismember(cell2mat(faces{1}),currentEdges(i,:)),2)==2;
    %isAdjacentFace(firstStrikeFace) = 0; % Remove current face
    % Don't check originating edge
    
    currentEdge = vertices(currentEdges(i,:),:);
    if all(size(originEdge) == size(currentEdge)) && max(max(abs((originEdge - currentEdge))))<0.001
    else
        edgesToCheck{end+1,1} = currentEdge;
        edgesToCheck{end,2} = vertices(faces{currentFace},:);
        %moveForward(currentEdge, endPoint, vertices, edges, faces, 'edge')
    end
end





