function drawRemainingEdges(edgesToCheck, count)

if nargin == 1
    count = 1;
end

hold on
for i = count:length(edgesToCheck)
edge = edgesToCheck{i};
        drawEdge3d([edge(1,:),edge(2,:)]);

end
axis equal
view(3)