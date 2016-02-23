function drawManifold(manifold)

hold on
for i = 1:length(manifold)
    poly = manifold{i};
    if size(poly,1) == 1
        drawEdge3d(poly);
    else
        fillPolygon3d(poly);
    end
end
axis equal