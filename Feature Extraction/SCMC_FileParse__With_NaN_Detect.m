baseInputFolder = 'C:\Users\jjrya\Desktop\ASV19\';
baseOutputFolder = 'C:\Users\jjrya\Desktop\ASV19_Features\SCMC\';
nanfile = 'C:\Users\jjrya\Desktop\ASV19_Features\SCMC_NaNFiles.xlsx';
inputFiles = dir(fullfile(baseInputFolder,'**\*.flac'));
nextRow = 1;
for k = 1:length(inputFiles)
    mySubdir = erase(inputFiles(k).folder,baseInputFolder);
    baseFileName = inputFiles(k).name;
    fullFileName = fullfile(inputFiles(k).folder, baseFileName);
    fprintf('Reading file %d of %d named %s\n',k,length(inputFiles),baseFileName);
    [wavFilepath,wavName,wavExt] = fileparts(baseFileName);
    [x,fs] = audioread(fullFileName);
    [stat,delta,double_delta]=extract_scmc(fullFileName,16000,20,512,20);
    outTypes = ["delta", "double_delta", "stat"];
    filenames= string.empty;
    for m = 1:length(outTypes)
        if ~exist(strcat(baseOutputFolder,outTypes(m),'\', mySubdir), 'dir')
           mkdir(strcat(baseOutputFolder,outTypes(m), '\', mySubdir));
        end
        filenames(m) = strcat(baseOutputFolder,outTypes(m), '\', mySubdir, '\',wavName,'_', outTypes(m),'.csv');
    end
    if any(isnan(delta))
        [originalrowsize, ~] = size(delta);
        delta = rmmissing(delta);
        [newrowsize, ~] = size(delta);
        deletedrows = originalrowsize - newrowsize;
        range1 = sprintf('%s%d','A',nextRow);
        range2 = sprintf('%s%d','B',nextRow);
        writematrix(fullFileName,nanfile,'Sheet','Sheet1','Range',range1);
        writematrix(deletedrows,nanfile,'Sheet','Sheet1','Range',range2);
        nextRow = nextRow +1;
    end
    if any(isnan(double_delta))
        [originalrowsize, ~] = size(double_delta);
        double_delta = rmmissing(double_delta);
        [newrowsize, ~] = size(double_delta);
        deletedrows = originalrowsize - newrowsize;
        range1 = sprintf('%s%d','A',nextRow);
        range2 = sprintf('%s%d','B',nextRow);
        writematrix(fullFileName,nanfile,'Sheet','Sheet1','Range',range1);
        writematrix(deletedrows,nanfile,'Sheet','Sheet1','Range',range2);
        nextRow = nextRow +1;
    end
    if any(isnan(stat))
        [originalrowsize, ~] = size(stat);
        stat = rmmissing(stat);
        [newrowsize, ~] = size(stat);
        deletedrows = originalrowsize - newrowsize;
        range1 = sprintf('%s%d','A',nextRow);
        range2 = sprintf('%s%d','B',nextRow);
        writematrix(fullFileName,nanfile,'Sheet','Sheet1','Range',range1);
        writematrix(deletedrows,nanfile,'Sheet','Sheet1','Range',range2);
        nextRow = nextRow +1;
    end
    writematrix(delta,filenames(1,1));  
    writematrix(double_delta,filenames(1,2));  
    writematrix(stat,filenames(1,3));  
end