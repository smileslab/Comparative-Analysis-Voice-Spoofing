baseInputFolder = 'C:\Users\jjrya\Desktop\test\';
baseOutputFolder = 'C:\Users\jjrya\Desktop\Test_Scripts\SSFC\';
nanfile = 'C:\Users\jjrya\Desktop\Test_Scripts\SSFC_NaNFiles.xlsx';
inputFiles = dir(fullfile(baseInputFolder,'**\*.flac'));
nextRow = 1;
for k = 1:length(inputFiles)
    mySubdir = erase(inputFiles(k).folder,baseInputFolder);
    baseFileName = inputFiles(k).name;
    fullFileName = fullfile(inputFiles(k).folder, baseFileName);
    fprintf('Reading file %d of %d named %s\n',k,length(inputFiles),baseFileName);
    [wavFilepath,wavName,wavExt] = fileparts(baseFileName);
    [x,fs] = audioread(fullFileName);
    [stat,delta,double_delta]=extract_ssfc(fullFileName,16000,20,512,20);
    if ~exist(baseOutputFolder, 'dir')
        mkdir(baseOutputFolder);
    end
    filename = strcat(baseOutputFolder, '\',wavName,'.csv');
    if any(isnan(extracted_features))
        [originalrowsize, ~] = size(extracted_features);
        extracted_features = rmmissing(extracted_features);
        [newrowsize, ~] = size(extracted_features);
        deletedrows = originalrowsize - newrowsize;
        range1 = sprintf('%s%d','A',nextRow);
        range2 = sprintf('%s%d','B',nextRow);
        writematrix(fullFileName,nanfile,'Sheet','Sheet1','Range',range1);
        writematrix(deletedrows,nanfile,'Sheet','Sheet1','Range',range2);
        nextRow = nextRow +1;
    end
    if any(isnan(extracted_features))
        [originalrowsize, ~] = size(extracted_features);
        extracted_features = rmmissing(extracted_features);
        [newrowsize, ~] = size(extracted_features);
        deletedrows = originalrowsize - newrowsize;
        range1 = sprintf('%s%d','A',nextRow);
        range2 = sprintf('%s%d','B',nextRow);
        writematrix(fullFileName,nanfile,'Sheet','Sheet1','Range',range1);
        writematrix(deletedrows,nanfile,'Sheet','Sheet1','Range',range2);
        nextRow = nextRow +1;
    end
    if any(isnan(extracted_features))
        [originalrowsize, ~] = size(extracted_features);
        extracted_features = rmmissing(extracted_features);
        [newrowsize, ~] = size(extracted_features);
        deletedrows = originalrowsize - newrowsize;
        range1 = sprintf('%s%d','A',nextRow);
        range2 = sprintf('%s%d','B',nextRow);
        writematrix(fullFileName,nanfile,'Sheet','Sheet1','Range',range1);
        writematrix(deletedrows,nanfile,'Sheet','Sheet1','Range',range2);
        nextRow = nextRow +1;
    end
    writematrix([stat,delta,double_delta],filename);  
end