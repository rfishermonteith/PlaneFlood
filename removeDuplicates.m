function edgesToCheck = removeDuplicates(edgesToCheck, count)

match = false(length(edgesToCheck),1);
indicesToRemove = zeros(1,length(edgesToCheck));
for k = 1:length(edgesToCheck)
    for kk = k+1:length(edgesToCheck)
        if isequal(edgesToCheck{k,1},edgesToCheck{kk,1})
            match(k,kk) = 1;
            edgesToCheck{kk,1} = [];
            indicesToRemove(kk) = true;
        end
    end
    
    
end

% Remove empty edges

edgesToCheck = edgesToCheck(~logical(indicesToRemove),:);
