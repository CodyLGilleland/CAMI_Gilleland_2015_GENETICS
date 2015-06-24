function images_out = create_image_pyramid(image1,image2)

minPixels = 53;
sizeImages = size(image1);
current_height = sizeImages(1);
current_width = sizeImages(2);

num_image_sizes = 0;
while current_height > minPixels  && current_width > minPixels
    num_image_sizes = num_image_sizes + 1;
    current_height = ceil(current_height/2);
    current_width = ceil(current_width/2);
end

images_out = cell(num_image_sizes,2);
current_image1 = image1;
current_image2 = image2;

for i = 1: num_image_sizes
    images_out{i,1} = current_image1;
    images_out{i,2} = current_image2;
    if i < num_image_sizes
        current_image1 = impyramid(current_image1,'reduce');
        current_image2 = impyramid(current_image2,'reduce');
    else
        break;
    end
end

end