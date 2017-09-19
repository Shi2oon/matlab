clear all; clc;
x = linspace(0,2,100);
y = linspace(0.1,1,45);
[X Y] = meshgrid(x,y);
dmg = (1-Y).*(1+X).*2000 +Y.*(1+X).*3000;

figure(1); %axis equal; 
surf(X,Y,dmg);xlabel('x');ylabel('y');zlabel('dmg');

