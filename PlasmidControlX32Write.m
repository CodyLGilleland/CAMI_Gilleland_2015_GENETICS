%global A
%global B
% global C
% global D
% global E
% global F
A = 1000;
B = 2000;
C = 1000;
D = 4000;
E = 5000;
F = 6000;
save('abcdef.mat','A','B','C','D','E','F');
A = 0;
B = 0;
C = 0;
D = 0;
E = 0;
F = 0;
%load('abcdef.mat','A','B','C','D','E','F');