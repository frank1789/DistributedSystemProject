function this = computecostfunc(this, initialposition)
%
%
%
%
%

% parse initialposition
x0 = initialposition(1);
y0 = initialposition(2);

% get dimension of occupacy grid
[m, n] = size(this.occupacygrid);

if m == n % verify occupacy matrix is square
    % Inizializzazione
    V_xy = zeros(size(this.occupacygrid)) + 10000;
    % Settare a 0 le posizioni occupate dal robot / caso robot occupa 1 sola
    % cella
    V_xy(x0,y0) = 0;
    
    % Update Loop
    % Primo Quadrante
    for i = x0:1:(length(this.occupacygrid(:,1)) - 1)
        for j = y0:1:(length(this.occupacygrid(:,1)) - 1)
            [ V_xy ] = Loop_Cost_Funtion(i, j, V_xy, this.occupacygrid);
        end
    end
    
    %Secondo Quadrante
    for i = x0:1:(length(this.occupacygrid(1,:)) - 1)
        for j = y0:-1:2
            [ V_xy ] = Loop_Cost_Funtion(i, j, V_xy, this.occupacygrid);
        end
    end
    
    % Terzo Quadrante
    for i = x0:-1:2
        for j = y0:-1:2
            [ V_xy ] = Loop_Cost_Funtion(i, j, V_xy, this.occupacygrid);
        end
    end
    
    % Quarto Quadrante
    for i = x0:-1:2
        for j = y0:1:(length(this.occupacygrid(1,:)) - 1)
            [ V_xy ] = Loop_Cost_Funtion(i, j, V_xy, this.occupacygrid);
        end
    end
    
    % Plot surface
    surf(V_xy);
else
    % make complementary matrix (must be square)
    complement = zeros(n - m, n) + 0.0;
    % overwrite input parameter
    this.occupacygrid = cat(1, this.occupacygrid,complement);
    % Inizializzazione
    V_xy = zeros(size(this.occupacygrid)) + 10000;
    % Settare a 0 le posizioni occupate dal robot / caso robot occupa 1 sola
    % cella
    V_xy(x0 +1 ,y0) = 0;
    
    % Update Loop
    % Primo Quadrante
    for i = x0:1:(length(this.occupacygrid(:,1)) - 1)
        for j = y0:1:(length(this.occupacygrid(:,1)) - 1)
            [ V_xy ] = Loop_Cost_Funtion(i, j, V_xy, this.occupacygrid);
        end
    end
    
    %Secondo Quadrante
    for i = x0:1:(length(this.occupacygrid(1,:)) - 1)
        for j = y0:-1:2
            [ V_xy ] = Loop_Cost_Funtion(i, j, V_xy, this.occupacygrid);
        end
    end
    
    % Terzo Quadrante
    for i = x0:-1:2
        for j = y0:-1:2
            [ V_xy ] = Loop_Cost_Funtion(i, j, V_xy, this.occupacygrid);
        end
    end
    
    % Quarto Quadrante
    for i = x0:-1:2
        for j = y0:1:(length(this.occupacygrid(1,:)) - 1)
            [ V_xy ] = Loop_Cost_Funtion(i, j, V_xy, this.occupacygrid);
        end
    end
    this.V_xy = V_xy;
    % Plot surface
    surf(V_xy);
    
    
end
end % function
