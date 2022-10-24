baseInputFolder = 'C:\Users\jjrya\Desktop\ASVSpoof2019PA_WAVs\';
baseOutputFolder = 'C:\Users\jjrya\Desktop\ASVSpoof2019PA_WAVs_SSFC';
inputFiles = dir(fullfile(baseInputFolder,'**\*.wav'));
for k = 1:length(inputFiles)
    mySubdir = erase(inputFiles(k).folder,baseInputFolder);
    baseFileName = inputFiles(k).name;
    fullFileName = fullfile(inputFiles(k).folder, baseFileName);
    fprintf('Reading file %d of %d named %s\n',k,length(inputFiles),baseFileName);
    [wavFilepath,wavName,wavExt] = fileparts(baseFileName);
    [stat,delta,double_delta]=extract_ssfc(fullFileName,16000,80,512,20);
    outTypes = ["delta", "double_delta", "stat"];
    filenames= string.empty;
    for m = 1:length(outTypes)
        if ~exist(strcat(baseOutputFolder,outTypes(m),'\', mySubdir), 'dir')
           mkdir(strcat(baseOutputFolder,outTypes(m), '\', mySubdir))
        end
        filenames(m) = strcat(baseOutputFolder,outTypes(m), '\', mySubdir, '\',wavName,'_', outTypes(m),'.csv');
    end
    writematrix(delta,filenames(1,1));  
    writematrix(double_delta,filenames(1,2));  
    writematrix(stat,filenames(1,3));  
end