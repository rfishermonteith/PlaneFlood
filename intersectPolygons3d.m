function [edge, normal] = intersectPolygons3d(poly1, poly2)
% POLY1 and POLY2 are Np-by-3 arrays containing
%   coordinates of 3D polygon vertices.  POLY1 is the poly the bug is
%   travelling along

% Extract plane information for the two polygons
plane1 = createPlane(poly1(1:3,:));
plane2 = createPlane(poly2(1:3,:));

%Make sure the intersection is from the side of the normal - this confirms
%it is an exit intersection
normal = planeNormal(plane1);
% Am I moving in the direction of the normal?


% Find line intersection of the two planes
line = intersectPlanes(plane1, plane2);

% Bound this line to lie on poly2 to an edge
% Find edge points of intersection of line and poly1

% Contruct lines for each edge of poly1 and find intersection point
intersections = [];
for i = 1:length(poly1)
    p1 = poly1(i,:);
    if i == length(poly1)
        p2 = poly1(1,:);
    else
        p2 = poly1(i+1,:);
    end
    line1(i,:) = createLine3d(p1, p2);
    
    [intersectionPoint, t1, t2] = intersectLines3d(line, line1(i,:));
    if any(isnan(intersectionPoint))
        % These lines are collinear or parallel, so no intersection point -
        % can ignore
        
    else
        intersections = [intersections;[intersectionPoint]];
    end
    
end


edge = intersections;
% Todo: Ensure only 2 points


end
