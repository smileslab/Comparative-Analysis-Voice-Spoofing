baseInputFolder = 'C:\Users\jjrya\Desktop\NaN Problem\';
filename = strcat(baseInputFolder,'find_NaNs_Delta.xlsx');
inputFiles = dir(fullfile(baseInputFolder,'**\*.csv'));
nextRow = 1;
for k = 1:length(inputFiles)
    baseFileName = inputFiles(k).name;
    fullFileName = fullfile(inputFiles(k).folder, baseFileName);
    fprintf('Reading file %d of %d named %s\n',k,length(inputFiles),baseFileName);
    if any(isnan(readmatrix(fullFileName)), 'all')
        range1=sprintf('%s%d','A',nextRow);
        writematrix(fullFileName,filename,'Sheet','Sheet1','Range',range1);
        nextRow = nextRow+1;
    end
end

    