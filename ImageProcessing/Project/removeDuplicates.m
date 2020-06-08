function lines = removeDuplicates(lines)
    indexes = [];

    for i = 1:length(lines)
        for j = 1:length(lines)
          % If the segments are in the same line, they will have same rho and
          % theta paramenters
          if  isequal(lines(i).theta, lines(j).theta) && isequal(lines(i).rho, lines(j).rho)
            % if they are collinear, we set the second line's second point as new end point
            % and we remove the second line
            disp(lines(j))
            lines(i).point2 = lines(j).point2;
            lines(j).point1 = lines(i).point1;
            % lines(j)=[]
            indexes = [indexes; j];
          end
        end
    end
    % Horrible monkey patch to delete non required lines.
    [v, w] = unique( indexes, 'stable' );
    duplicate_indices = setdiff( 1:numel(indexes), w );
    lines(indexes(duplicate_indices(2))) = [];
end