function image_filter(filepath)

% This function shows results from both applying 3x3 averaging filters

image = imread(filepath);
figure(1);

subplot(3,1,1), imshow(image);
title('Original Image');

filtered_image = average_filter(image);
subplot(3,1,2), imshow(filtered_image);
title("Filtered Image");

image_filtered = filter2(fspecial('average',3),image)/255;
subplot(3,1,3), imshow(image_filtered);
title("Matlab's Filtered Image");

end

function [filtered_img] = average_filter(image)
% This function applies 3x3 averaging filter to the input (grayscale) image
    [m,n] = size(image);
    filtered_img = zeros(m,n);
    for i = 1:m-2
        for j = 1:n-2
            filtered_img(i+1,j+1) = mean2(image(i:i+2,j:j+2));
        end
    end
    filtered_img = uint8(filtered_img);
end

