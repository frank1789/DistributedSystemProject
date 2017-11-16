function [p] = plotLine( initialPoint , finalPoint , lineColor , lineWidth , lineStyle )

try
    lineColor;
catch
    lineColor = 'g' ;
end

try
    lineWidth;
catch
    lineWidth = 1 ;
end
try
    lineStyle;
catch
    lineStyle = '-' ;
end



try
    if length(lineColor) == 1
        p=line( [ initialPoint(1) finalPoint(1) ] , [ initialPoint(2) finalPoint(2) ] , 'color' , lineColor , 'linewidth' , lineWidth , 'linestyle', lineStyle) ;
    elseif length(lineColor) == 3
        p=line( [ initialPoint(1) finalPoint(1) ] , [ initialPoint(2) finalPoint(2) ] , 'color' , lineColor , 'linewidth' , lineWidth , 'linestyle', lineStyle);
    else
        disp('color not recognized')
        Wait(0)
    end
catch
    if length(lineColor) == 1
        p=line( [ initialPoint.x finalPoint.x ] , [ initialPoint.y finalPoint.y ] , 'color' , lineColor , 'linewidth' , lineWidth , 'linestyle', lineStyle);
    elseif length(lineColor) == 3
        p=line( [ initialPoint.x finalPoint.x ] , [ initialPoint.y finalPoint.y ] , 'color' , lineColor , 'linewidth' , lineWidth , 'linestyle', lineStyle);
    else
        disp('color not recognized')
        Wait(0)
    end
end


