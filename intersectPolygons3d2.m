function [edge, normal] = intersectPolygons3d2(poly1, poly2)
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

% Check whether all vertices of poly1 are on a single side of plane2 and
% vice versa
below1 = isBelowPlane(poly1, plane2);
below2 = isBelowPlane(poly2, plane1);
% if all(below1) || all(~below1)
%     % No intersection
%     edge = [];
% else

  
    
% Check intersection of line with poly1
intersections = [];
intersectingLine = [];

for i = 1:length(poly1)
    p1 = poly1(i,:);
    if i == length(poly1)
        p2 = poly1(1,:);
    else
        p2 = poly1(i+1,:);
    end
    line1(i,:) = createLine3d(p1, p2);
    intersectionPoint = intersectLinePolygon3d(line1(i,:),poly2);
    % Is this point on edge?


    
    %[intersectionPoint, t1, t2] = intersectLines3d(line, line1(i,:));
    if any(isnan(intersectionPoint))
        % These lines are collinear or parallel, so no intersection point -
        % can ignore
        
    else
            t = getTLine(intersectionPoint, line1(i,:));
    
            if t>=0 && t<=1 % Ensure that intersection is on edge
                intersections = [intersections;[intersectionPoint]];
                intersectingLine = [intersectingLine;[p1 p2]];
            end
    end
    
end

% Check intersection of line with poly2

for i = 1:length(poly2)
    p1 = poly2(i,:);
    if i == length(poly2)
        p2 = poly2(1,:);
    else
        p2 = poly2(i+1,:);
    end
    line1(i,:) = createLine3d(p1, p2);
    intersectionPoint = intersectLinePolygon3d(line1(i,:),poly1);
    %[intersectionPoint, t1, t2] = intersectLines3d(line, line1(i,:));
    if any(isnan(intersectionPoint))
        % These lines are collinear or parallel, so no intersection point -
        % can ignore
        
    else
        intersections = [intersections;[intersectionPoint]];
        intersectingLine = [intersectingLine;[p1 p2]];
    end
    
end

% Find unique intersections
edge = unique(round(intersections,5), 'rows');

% If make sure there is more than a single intersection
if size(edge, 1) == 1
    edge = [];
end
end
