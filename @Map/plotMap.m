function this = plotMap( this , textIndex )


try
    textIndex ;
catch
    textIndex = 0 ;
end


%% print map
hold on
% plot( this.points(1,:) , this.points(2,:) , '.k' )
if textIndex
    for ii=1:1:length( this.points )
        text( this.points(1,ii)+0.05 , this.points(2,ii) , num2str(ii) )
    end
end

if ~isempty(this.landmark) || ~isempty(this.points) || ~isempty(this.lines)
    for ii=1:1:length( this.lines )
        if this.lines(1,ii) ~= 0
            p1 = this.plotLine( this.points(:,this.lines(1,ii)) , this.points(:,this.lines(2,ii)), [0.6,0.6,0.6] , 3 );
        end
    end
    if ~isempty(this.landmark)
        plot(this.landmark(1,:),this.landmark(2,:), 'ms','MarkerFaceColor','m');
    end
    hold off
end
end
