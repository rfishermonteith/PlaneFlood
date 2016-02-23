function [manifold, edgesToCheck] = extendEdgeTowardGoal(currentEdge, ...
    endPoint, originFace, vertices, edges, faces, manifold, edgesToCheck, faceOrder)

% If currentEdge is a line, go directly towards the goal until an object is
% struck
if size(currentEdge, 1) == 1
    currentPoint = currentEdge;
    [firstStrikeX, firstStrikeFace] =  extendLineTowardsGoal(currentPoint, endPoint, vertices, faces);
    
    if any(isnan(firstStrikeX))
        % No obstacles
        manifold{end+1} = [currentPoint,endPoint];
        % Display
        drawEdge3d(manifold{end},'color','cyan')
    else
        % Add edge to manifold
        manifold{end+1} = [currentPoint,firstStrikeX];
        
        % Display
        drawEdge3d(manifold{end},'color','cyan')
        
        % Expand to edges
        [manifold, edgesToCheck] = findEdgesOfCurrentFace(firstStrikeX, firstStrikeFace, endPoint, vertices, edges, faces, manifold, edgesToCheck);
    end
else % currentEdge is an actual edge (rather than a point)
    
    % Create polygon from currentEdge to goal
    poly = [currentEdge;endPoint];
    
    % Find all intersections with other faces
    count = 1;
    if isempty(faceOrder)
        faceOrder = 1:length(faces);
    end
    
    for i = faceOrder
        if ~isequal(vertices(faces{i},:), originFace) % Ignore originFace
            [intersectionEdge{count}, originEdge{count} dotNormal(count), distMin(count), distMax(count)] =  isIntersect(poly, endPoint,  vertices, edges, faces{i});
            % If length of intersectionEdge{i} < threshold, ignore
            % (rounding error)
            if ~isempty(intersectionEdge{count}) && sum((intersectionEdge{count}(1,:)-intersectionEdge{count}(2,:)).^2)<0.01
                intersectionEdge{count} = [];
                distMin(count) = Inf;
            end
            if ~isempty(intersectionEdge{count})
                %drawEdge3d([intersectionEdge{count}(1,:),intersectionEdge{count}(2,:)])
            end
            facesSorted(count) = i;
            count = count+1;
        end
    end
    
    % Sort by distMin
    [distMin, faceOrder] = sort(distMin);
    distMax = distMax(faceOrder);
    dotNormal = dotNormal(faceOrder);
    originEdge = originEdge(faceOrder);
    intersectionEdge = intersectionEdge(faceOrder);
    facesSorted = facesSorted(faceOrder);
    
    
    % If necessary, split the originEdges and add to edgesToCheck
    foundIntersection = false;
    for i = 1:sum(~isinf(distMin))
        line = createLine3d(originEdge{i}(1,:),endPoint);
        t = (originEdge{i}(1,1)-line(1))/line(4);
        % If dotNormal is negative, add corresponding origin/intersection
        % to manifold, and remove originEdge from other intersections
        if dotNormal(i)<0 && t>= 0% Positive penetration
            foundIntersection = true;
            % Ensure this is not just an edge
            if ~isequal(originEdge{i}, intersectionEdge{i})
                manifold{end+1} = createPolygon3d(originEdge{i}, intersectionEdge{i});
                fillPolygon3d(manifold{end},'cyan','FaceAlpha', 0.5);
            end
            [manifold, edgesToCheck] = findEdgesOfCurrentFace(intersectionEdge{i}, facesSorted(i), endPoint, vertices, edges, faces, manifold, edgesToCheck);
            
            %                 edgesToCheck{end+1,1} = intersectionEdge{i};
            %                 edgesToCheck{end,2} = originFace;
            
            line = createLine3d(poly(1,:),poly(2,:));
            t1 = getTLine(originEdge{i}(1,:), line);
            t2 = getTLine(originEdge{i}(2,:), line);
            t = sort([t1,t2]);
            t1 = round(t(1),5);
            t2 = round(t(2),5);
            if t1 > 0 && t2 == 1
                % Starting section left
                newEdge =  [line(1:3)+0*line(4:6); line(1:3)+t1*line(4:6)];
                edgesToCheck{end+1,1} = newEdge;
                edgesToCheck{end,2} = originFace;
                edgesToCheck{end,3} = faceOrder;
            elseif t1 == 0 && t2 < 1
                % Ending section left
                newEdge =  [line(1:3)+t2*line(4:6); line(1:3)+1*line(4:6)];
                edgesToCheck{end+1,1} = newEdge;
                edgesToCheck{end,2} = originFace;
                edgesToCheck{end,3} = faceOrder;
            elseif t1 > 0 && t2 < 1
                % Middle section left
                newEdge1 =  [line(1:3)+0*line(4:6); line(1:3)+t1*line(4:6)];
                edgesToCheck{end+1,1} = newEdge1;
                edgesToCheck{end,2} = originFace;
                edgesToCheck{end,3} = faceOrder;
                newEdge2 =  [line(1:3)+t2*line(4:6); line(1:3)+1*line(4:6)];
                edgesToCheck{end+1,1} = newEdge2;
                edgesToCheck{end,2} = originFace;
                edgesToCheck{end,3} = faceOrder;
            elseif t1 == 0 && t2 == 1
                % No edge left
            end
            
            break
        end
        
    end
    if ~foundIntersection
        % Move to end
        manifold{end+1} = poly;
        fillPolygon3d(manifold{end},'cyan','FaceAlpha', 0.5);
    end
    
      
end
function [firstStrikeX, firstStrikeFace] =  extendLineTowardsGoal(currentPoint, endPoint, vertices, faces)

% Find line paramterisation in the form [x y z]' = [a b c]' + t*[d e f]'
% or X = A + tB;

% for t = 1, [x y z] = endPoint
% for t = 0, [x y z] = startPoint
% therefore [a b c] = startPoint and [d e f] = endPoint - startPoint

A = currentPoint;
B = endPoint-currentPoint;

% Find smallest t value which intersects a face

line = [A,B];
tInter = inf*ones(length(faces),1);
for i = 1:length(faces)
    poly = vertices(faces{i},:);
    [inter(i,:), inside] = intersectLinePolygon3d(line, poly);
    if any(~isnan(inter(i,:)))
        tInter(i) = mean((inter(i,:) - A)./B);
    end
end

[firstStrikeT, firstStrikeFace] = min(tInter);
firstStrikeX = inter(firstStrikeFace,:);



