function image_histeq(filepath)

% This function shows results from both histogram equalization functions

image = imread(filepath);
figure(1);

subplot(3,2,1), imshow(image);
title('Original Image');

subplot(3,2,2), imhist(image);
grid on;
title("Image's Histogram");

eq_image = custom_histeq(image);
subplot(3,2,3), imshow(eq_image);
title("Histogram Equalized Image");

subplot(3,2,4), imhist(eq_image);
grid on;
title("Histogram Equalization");

subplot(3,2,5), histeq(image);
title("Matlab's Histogram Equalized Image");

subplot(3,2,6), imhist(histeq(image));
grid on;
title("Matlab's Histogram Equalization");

end

function custom_histeq = custom_histeq(image)

% This function performs histogram equalization on the input (grayscale) image

np=size(image,1)*size(image,2);

custom_histeq=uint8(zeros(size(image,1),size(image,2)));

freq=zeros(256,1);
probf=zeros(256,1);
probc=zeros(256,1);
cum=zeros(256,1);
output=zeros(256,1);

for i=1:size(image,1)
    for j=1:size(image,2)
        value=image(i,j);
        freq(value+1)=freq(value+1)+1;
        probf(value+1)=freq(value+1)/np;
    end
end

sum=0;
no_bins=255;

for i=1:size(probf)
   sum=sum+freq(i);
   cum(i)=sum;
   probc(i)=cum(i)/np;
   output(i)=round(probc(i)*no_bins);
end

for i=1:size(image,1)
    for j=1:size(image,2)
        custom_histeq(i,j)=output(image(i,j)+1);
    end
end

end