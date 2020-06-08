function showRegions(image, s)
    figure
    title('Proposed regions')
    imshow(image);
    hold on
    text(8,785,strcat('\color{green}Cars Detected: ',num2str(length(s))))
    for n=1:size(s,1)
        rectangle('Position', s(n).BoundingBox,'EdgeColor','g','LineWidth',2);
    end
    hold off
end