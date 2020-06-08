function showEdges(I, lines,corners)
    figure
    imshow(I)
    title('Detected lines')
    
    hold on
    for k = 1:length(lines)
      xy = [lines(k).point1; lines(k).point2];
      plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'red');
      text(xy(:,1), xy(:,2),num2str(k), 'FontSize',14)
    end
    
    for k = 1:length(corners)
        plot(corners(k).x,corners(k).y,'m*','markersize',8)
        text(corners(k).x,corners(k).y,num2str(k))    
    end    
    hold off
end