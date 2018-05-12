function compilemexlibrary()
%COMPILEMEXLIBRARY compile file mex for architcture
archstr = computer('arch');
switch archstr
    case {'PCWIN64', lower('PCWIN64')}
        fprintf('system architecture:\t %s\n', archstr)
        extmex = ["mexa64"; "mexmaci64"];
        checkfile(extmex)
        list1 = what;
        list2 = what('@Map');
        if length(list1.mex) < 1 || length(list2.mex) < 1
            compile();
        end
        
    case {'GLNXA64', lower('GLNXA64')}
        fprintf('system architecture:\t %s\n', archstr)
        extmex = ["mexmaci64"; "mexw64"];
        checkfile(extmex)
        list1 = what;
        list2 = what('@Map');
        if length(list1.mex) < 1 || length(list2.mex) < 1
            compile();
        end
        
    case {'MACI64', lower('MACI64')}
        fprintf('system architecture:\t %s\n', archstr)
        extmex = ["mexa64"; "mexw64"];
        checkfile(extmex)
        list1 = what;
        list2 = what('@Map');
        if length(list1.mex) < 1 || length(list2.mex) < 1
            compile();
        end
        
    otherwise
        disp('architecture not supported');
end
clc
end



function compile()
%COMPILE launches the compilation of the mex functions

mex -v -output Sens_model_noise sens_model_noise.c
mex -v COMPFLAGS='$COMPFLAGS -std=c++14' -output @Map/mapgen ./src/DungeonGenerator/*.cpp
mex -v COMPFLAGS='$COMPFLAGS -std=c++14' -output potentialfield ./src/*.cpp
end


function checkfile(extmex)
%CHECKFILE check and delete files that do not match the architecture
% looking for *.mex files in project folders.

for i = 1:length(extmex)
    ext = char(sprintf('**/*.%s',extmex(i)));
    listFile = dir(ext);
    for j = 1:length(listFile)
        fileName = char(sprintf('%s/%s',listFile(j).folder,listFile(j).name));
        delete(fileName)
    end
end
end
