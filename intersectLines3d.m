function [point, t1, t2] = intersectLines3d(line1, line2)

A = line1(1:3);
B = line1(4:6);
C = line2(1:3);
D = line2(4:6);

i = 1;
j = 2;

IJ = [1 2; 1 3; 2 3; 2 1; 3 1;3 2];
t2 = NaN;
count = 0;
% while(isnan(t2)||isinf(t2))
%     count = count+1;
%     %i = 
%     
% end

a1 = A(1); a2 = A(2); b1 = B(1);b2 = B(2);c1 = C(1); c2 = C(2);d1 = D(1);d2 = D(2);
if any(B == 0)
    % One eq can solve it
    ind = find(B==0  & D ~=0,1);
    if isempty(ind)
        % Collinear
        t2 = inf;
        t1 = inf;
    else
        
        t2 = (A(ind)-C(ind))/D(ind);
        X = C + t2*D;
        ind = find(B~=0,1);
        t1 = (X(ind)-A(ind))/B(ind);
    end

elseif any(D == 0)
    % One eq can solve it
    ind = find(D==0 & B ~= 0,1);
    if isempty(ind)
        % Collinear
        t2 = inf;
        t1 = inf;
    else
        t1 = (C(ind)-A(ind))/B(ind);
        X = A + t1*B;
        ind = find(D~=0,1);
        t2 = (X(ind)-C(ind))/D(ind);
    end

else
    t2 = (b1*(a2-c2)-b2*(a1-c1))/(d2*b1-d1*b2);
    t1 = (c1+t2*d1-a1)/b1;
end
if isinf(t2) || isinf(t1)
    % Parallel lines
    point = [NaN NaN NaN];
else
    point = A + t1*B;
end


