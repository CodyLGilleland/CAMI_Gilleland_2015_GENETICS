worm1 = rgb2gray(imread('worm_ex1.jpg'));
worm2 = rgb2gray(imread('worm_ex2.jpg'));
worm3 = rgb2gray(imread('worm_ex3.jpg'));
worm4 = rgb2gray(imread('worm_ex4.jpg'));
worm5 = rgb2gray(imread('worm_ex5.jpg'));
worm6 = rgb2gray(imread('worm_ex6.jpg'));

find_gonads(worm1, 1);
find_gonads(worm2, 1);
find_gonads(worm3, 1);
find_gonads(worm4, 1);
find_gonads(worm5, 1);