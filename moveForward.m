function [manifold, edgesToCheck] = moveForward(currentPointEdge, endPoint, originFace, vertices, edges, faces, pointOrEdge, manifold, edgesToCheck)


switch pointOrEdge
    case 'point'
        currentPoint = currentPointEdge;
        % Move from currentPoint towards the goal until you strike an object
        
        % Find line paramterisation in the form [x y z]' = [a b c]' + t*[d e f]'
        % or X = A + tB;
        
        % for t = 1, [x y z] = endPoint
        % for t = 0, [x y z] = startPoint
        % therefore [a b c] = startPoint and [d e f] = endPoint - startPoint
        
        A = currentPoint;
        B = endPoint-currentPoint;
        
        % Find smallest t value which intersects a face
        
        line = [A,B];
        
        for i = 1:length(faces{1})
            poly = vertices{1}(faces{1}{i},:);
            [inter(i,:), inside] = intersectLinePolygon3d(line, poly);
            if any(~isnan(inter(i,:)))
                tInter(i) = mean((inter(i,:) - A)./B);
            end
        end
        
        [firstStrikeT, firstStrikeFace] = min(tInter(tInter ~= 0));
        firstStrikeX = inter(firstStrikeFace,:);
        
        % Add edge to manifold
        manifold{end+1} = [currentPoint,firstStrikeX];
        
        % Display
        drawEdge3d(manifold{end},'color','cyan')
        
        % Expand to edges
        [manifold, edgesToCheck] = expandOut(firstStrikeX, firstStrikeFace, endPoint, vertices, edges, faces, 'point', manifold, edgesToCheck)
        
    case 'edge'
        currentEdge = currentPointEdge;
        
        % Create poly from currentEdge to goal
        poly = [currentEdge;endPoint];
        %[edgeIntersections, normalOfIntersectedFace] = intersectWithAllFaces
        % Find edge intersections
        localLOSBlocked = false;
        for i = 1:length(faces{1})
            if ~isequal(vertices{1}(faces{1}{i},:), originFace)
                disp(['Checking face ',num2str(i),': ',mat2str(faces{1}{i}), ' from edge ',mat2str(currentEdge)])
                currentPoly = vertices{1}(faces{1}{i},:);
                [edge, normal] = intersectPolygons3d2(currentPoly, poly);
                % Make sure the penetration is positive and that an
                % intersection exists
                
                if ~isempty(edge)
                    % Create the line that goes to the endPoint from on the
                    % currentEdge
                    
                    line = createLine3d(edge(1,:),endPoint);
                    t = (edge(1,1)-line(1))/line(4);
                    if dot(line(4:6),normal)<0 && t>=0
                        
                        % Ensure it hasn't been visited yet
                        polyVisited = false;
                        for k = 1:length(manifold)
                            if isequal(manifold{k} , currentPoly)
                                polyVisited = true;
                                
                            end
                        end
                        if ~polyVisited
                            
                            %manifold{end+1} = currentPoly;
                            
                            % if an edge exists, expand from that edge accross the
                            % face
                            face = i;
                            [manifold, edgesToCheck] = expandOut(edge, face, endPoint, vertices, edges, faces, 'edge', manifold, edgesToCheck);
                            fillPolygon3d([currentEdge;edge]);
                            
                        end
                        localLOSBlocked = true;
                        
                        
                    end
                    
                end
            end
            
        end
        if ~localLOSBlocked
            
            % Move to the finish
            manifold{end+1} = poly;
            fillPolygon3d(poly)
        end
        
end





% moveToThisFace = [];
%
% % Create surface between these and the goal and check intersections
% for i = 1:size(currentEdges,1)
%
%     isAdjacentFace = sum(ismember(cell2mat(faces{1}),currentEdges(i,:)),2)==2;
%     isAdjacentFace(firstStrikeFace) = 0; % Remove current face
%     if any(isAdjacentFace)
%         poly1 = vertices{1}(faces{1}{isAdjacentFace},:);
%         poly2 = [vertices{1}(currentEdges(i,:),:);endPoint];
%         [line, normal] = intersectPolygons3d(poly1, poly2);
%         % Am I moving in the direction of the normal?
%         lineToEnd = createLine3d(midPoint3d(...
%             reshape(vertices{1}(currentEdges(i,:),:),[1,6])),endPoint);
%         if dot(lineToEnd(4:6),normal) > 0 % Moving away from the adjacent face
%             % Follow LOS
%             disp(['Following LOS for edge ',mat2str(currentEdges(i,:))])
%             moveToThisFace = [moveToThisFace,find(isAdjacentFace)];
%         end
%     end
% end
%
