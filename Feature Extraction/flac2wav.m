baseInputFolder = 'C:\Users\jjrya\Desktop\ASVSpoof2021\';
baseOutputFolder = 'C:\Users\jjrya\Desktop\ASVSpoof2021_WAVs\';
inputFiles = dir(fullfile(baseInputFolder,'**\*.flac'));

for i=1:length(inputFiles)
    mySubdir = erase(inputFiles(i).folder,baseInputFolder);
    baseFileName = inputFiles(i).name;
    fullFileName = fullfile(inputFiles(i).folder, baseFileName);
    fprintf('Reading file %d of %d named %s\n',i,length(inputFiles),baseFileName);
    [flacFilepath,flacName,flacExt] = fileparts(baseFileName);
    Fname=fullFileName;

    [y,Fs]=audioread(Fname);
    if ~exist(strcat(baseOutputFolder, mySubdir), 'dir')
        mkdir(strcat(baseOutputFolder, mySubdir))
    end
    fileName = strcat(baseOutputFolder, mySubdir, '\',flacName,'.wav');
    audiowrite(fileName,y,Fs);
end