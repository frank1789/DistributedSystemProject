function makerobot(this)
hold on
rectangle('Position',[0 0 2 4],'Curvature',0.2)
% rectangle('Position',[6 0 2 4],'Curvature',1)
text(1.1,2.1,sprintf('ID: %i',this.ID))

quiver(1, 2, 0, 1, 'r')
quiver(1,2,1,0,'g')
quiver3(1,2,0,0,0,1,'b')
axis equal
hold off
end