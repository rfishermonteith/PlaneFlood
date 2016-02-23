function [intersectionEdge, originEdge, dotNormal, distMin, distMax] = isIntersect(poly, endPoint, vertices, edges, face)

% Create polygon from current face
currentPoly = vertices(face,:);

% Find intersection and surface normal of currentPoly
[edge, normal] = intersectPolygons3d2(currentPoly, poly);


% If the edge exists, find dotNormal
if ~isempty(edge)
    % Create the line that goes to the endPoint from on the
    % currentEdge
    line = createLine3d(edge(1,:),endPoint);
    t = (edge(1,1)-line(1))/line(4);
    dotNormal = dot(line(4:6),normal);
    
    % Find originEdge by extending a ray from endPoint through ends of edge
    line1 = createLine3d(endPoint, edge(1,:));
    line2 = createLine3d(endPoint, edge(2,:));
    lineOriginEdge = createLine3d(poly(1,:),poly(2,:));
    
    p1 = intersectLines3d(line1, lineOriginEdge);
    p2 = intersectLines3d(line2, lineOriginEdge);
    originEdge = [p1;p2];
    
    squareDist1 = sum((p1-edge(1,:)).^2);
    squareDist2 = sum((p2-edge(2,:)).^2);
    %t1 = getTLine(p1, line1);
    %t2 = getTLine(p2, line2);
    
    distMin = min([squareDist1, squareDist2]);
    distMax = max([squareDist1, squareDist2]);
    
else % No edge found
    distMin = Inf;
    distMax = Inf;
    originEdge = [];
    dotNormal = NaN;

end
intersectionEdge = edge;