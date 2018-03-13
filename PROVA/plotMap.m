function [p1] = plotMap( mapStructure , textIndex )


try
    textIndex ;
catch
    textIndex = 0 ;
end


%% print map

% plot( mapStructure.points(1,:) , mapStructure.points(2,:) , '.k' )
if textIndex
    for ii=1:1:length( mapStructure.points )
        text( mapStructure.points(1,ii)+0.05 , mapStructure.points(2,ii) , num2str(ii) )
    end
end
for ii=1:1:length( mapStructure.lines )
    if mapStructure.lines(1,ii) ~= 0
        p1 = plotLine( mapStructure.points(:,mapStructure.lines(1,ii)) , mapStructure.points(:,mapStructure.lines(2,ii)) , [0.6,0.6,0.6] , 3 );
    end
end

end