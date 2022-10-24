addpath('/home/a/awaiskhan/MATLAB/CQCC_v1.0/CQT_toolbox_2013');
addpath('/home/a/awaiskhan/MATLAB/Current/')
addpath('/home/a/awaiskhan/MATLAB/covarep-master/')
baseInputFolder = '/scratch/projects/smiles/Multi_Features/Datasets/ASVSpoof2019/PA/ASVspoof2019_PA_eval/';
baseOutputFolder = '/scratch/projects/smiles/Multi_Features/features_new/PA_eval/';
%baseInputFolder = '/home/a/awaiskhan/MATLAB/samples'
%baseOutputFolder = '/home/a/awaiskhan/MATLAB/out'

startup
if ~exist(baseOutputFolder, 'dir')
        mkdir(baseOutputFolder);
end
% WORKING FEATURES : CQCC, GTCC, IMFCC, LFCC, LPCC, MFCC, RFCC,SCFC, SCMC, SSFC , APGDF, ATP, RPS
inputFiles = dir(fullfile(baseInputFolder,'**/*.flac'));
genuineFeatureCell = cell(size(inputFiles));
parfor i = 1:length(inputFiles)
    mySubdir = erase(inputFiles(i).folder,baseInputFolder);
    baseFileName = inputFiles(i).name;
    fullFileName = fullfile(inputFiles(i).folder, baseFileName);
    %fprintf('Reading file %d of %d named %s\n',i,length(inputFiles),baseFileName);
    [outFilepath,outName,outExt] = fileparts(fullFileName);
    
    if contains(mySubdir,'vsdc_flac')
        fs = 96000;
    else 
        fs = 16000;
    end

    x= audioread(fullFileName);
    
    feature_type = 'CQCC';
    filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');

    if ~exist(filename, 'file')
        if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
             mkdir(strcat(baseOutputFolder, '/',feature_type, '/',  mySubdir, '/'));
        end
        genuineFeatureCell{i}= cqcc(x, fs, 96, fs/2, fs/2^10, 20, 19, 'ZsdD');
        genuineFeatureCell_mean{i}=mean(genuineFeatureCell{i}');
        writematrix(genuineFeatureCell_mean{i},filename);
    end

    feature_type = 'LFCC';
    filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');

    if ~exist(filename, 'file')
        if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
             mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
        end
        [coeffs_LFCC,delta_LFCC,deltaDelta_LFCC]= extract_lfcc(x,fs,20,512,20);
         M_LFCC=mean(coeffs_LFCC);
         M_LFCC_d=mean(delta_LFCC);
         M_LFCC_dd=mean(deltaDelta_LFCC);
         M_LFCC_final = [M_LFCC,M_LFCC_d,M_LFCC_dd];
        genuineFeatureCell{i} = M_LFCC_final;
        writematrix(genuineFeatureCell{i},filename);
    end

    feature_type = 'MFCC';
    filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
    if ~exist(filename,'file')
        if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
             mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
        end
        [coeffs_MFCC,delta_MFCC,deltaDelta_MFCC,~] = mfcc(x,fs,'WindowLength',round(fs*0.030),'OverlapLength',(fs*0.020));
         M_MFCC=mean(coeffs_MFCC);
         M_MFCC_d=mean(delta_MFCC);
         M_MFCC_dd=mean(deltaDelta_MFCC);
         M_MFCC_final = [M_MFCC,M_MFCC_d,M_MFCC_dd];
        genuineFeatureCell{i} = M_MFCC_final;
        writematrix(genuineFeatureCell{i},filename);
    end

%     feature_type = 'IMFCC';
%     filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
%     if ~exist(filename, 'file')
%         if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
%              mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
%         end
%         [coeffs_IMFCC,delta_IMFCC,deltaDelta_IMFCC] = extract_imfcc(x,fs,20,512,20);
%          M_IMFCC=mean(coeffs_IMFCC);
%          M_IMFCC_d=mean(delta_IMFCC);
%          M_IMFCC_dd=mean(deltaDelta_IMFCC);
%          M_IMFCC_final = [M_IMFCC,M_IMFCC_d,M_IMFCC_dd];
%         genuineFeatureCell{i} = M_IMFCC_final;
%         writematrix(genuineFeatureCell{i},filename);
%     end
    
%     feature_type = 'LPCC';
%     filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
%     if ~exist(filename, 'file')
%         if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
%              mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
%         end
%         [coeffs_LPCC,delta_LPCC,deltaDelta_LPCC] = extract_lpcc(x,fs,20,20);
%          M_LPCC=mean(coeffs_LPCC);
%          M_LPCC_d=mean(delta_LPCC);
%          M_LPCC_dd=mean(deltaDelta_LPCC);
%          M_LPCC_final = [M_LPCC,M_LPCC_d,M_LPCC_dd];
%         genuineFeatureCell{i} = M_LPCC_final;
%         writematrix(genuineFeatureCell{i},filename);
%     end
%     
%     feature_type = 'RPS';
%     filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
%     if ~exist(filename, 'file')
%         if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
%              mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
%         end
%         [coeffs_RPS,delta_RPS,deltaDelta_RPS] = extract_rps(x,fs,100,20);
%          M_RPS=mean(coeffs_RPS);
%          M_RPS_d=mean(delta_RPS);
%          M_RPS_dd=mean(deltaDelta_RPS);
%          M_RPS_final = [M_RPS,M_RPS_d,M_RPS_dd];
%         genuineFeatureCell{i} = M_RPS_final;
%         %genuineFeatureCell{i} = [coeffs,delta,deltaDelta]';
%         writematrix(genuineFeatureCell{i},filename);
%     end

%     feature_type = 'RFCC';
%     filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
%     if ~exist(filename, 'file')
%         if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
%              mkdir(strcat(baseOutputFolder, '/',feature_type, '/',  mySubdir, '/'));
%         end
%         [coeffs_RFCC,delta_RFCC,deltaDelta_RFCC] = extract_rfcc(x,fs,20,512,20);
%          M_RFCC=mean(coeffs_RFCC);
%          M_RFCC_d=mean(delta_RFCC);
%          M_RFCC_dd=mean(deltaDelta_RFCC);
%          M_RFCC_final = [M_RFCC,M_RFCC_d,M_RFCC_dd];
%         genuineFeatureCell{i} = M_RFCC_final;
%         writematrix(genuineFeatureCell{i},filename);
%     end
    
%     feature_type = 'GTCC';
%     filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
%     if ~exist(filename, 'file')
%         if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
%              mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
%         end
%         [coeffs_GTCC,delta_GTCC,deltaDelta_GTCC] = gtcc(x,fs,'WindowLength',round(fs*0.030),'OverlapLength',(fs*0.020));
%          M_GTCC=mean(coeffs_GTCC);
%          M_GTCC_d=mean(delta_GTCC);
%          M_GTCC_dd=mean(deltaDelta_GTCC);
%          M_GTCC_final = [M_GTCC,M_GTCC_d,M_GTCC_dd];
%         genuineFeatureCell{i} = M_GTCC_final;
%         writematrix(genuineFeatureCell{i},filename);
%     end
% 
%     feature_type = 'APGDF';
%     filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
%     if ~exist(filename, 'file')
%         if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
%              mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
%         end
%         [coeffs_APGDF,delta_APGDF,deltaDelta_APGDF]=extract_apgdf(x,fs,20,512,20);
%          M_APGDF=mean(coeffs_APGDF);
%          M_APGDF_d=mean(delta_APGDF);
%          M_APGDF_dd=mean(deltaDelta_APGDF);
%          M_APGDF_final = [M_APGDF,M_APGDF_d,M_APGDF_dd];
%         genuineFeatureCell{i} = M_APGDF_final;
%         writematrix(genuineFeatureCell{i},filename);
%     end     
% 
%     feature_type = 'SCFC';
%     filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
%     if ~exist(filename, 'file')
%         if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
%              mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
%         end
% 
%         [coeffs_SCFC,delta_SCFC,deltaDelta_SCFC]=extract_scfc(x,fs,20,512,20);
%          M_SCFC=mean(coeffs_SCFC);
%          M_SCFC_d=mean(delta_SCFC);
%          M_SCFC_dd=mean(deltaDelta_SCFC);
%          M_SCFC_final = [M_SCFC,M_SCFC_d,M_SCFC_dd];
%         genuineFeatureCell{i} = M_SCFC_final;
%         writematrix(genuineFeatureCell{i},filename);
%     end
% 
%     feature_type = 'SCMC';
%     filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
%     if ~exist(filename, 'file')
%         if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
%              mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
%         end
% 
%         [coeffs_SCMC,delta_SCMC,deltaDelta_SCMC]=extract_scmc(x,fs,20,512,20);
%          M_SCMC=mean(coeffs_SCMC);
%          M_SCMC_d=mean(delta_SCMC);
%          M_SCMC_dd=mean(deltaDelta_SCMC);
%          M_SCMC_final = [M_SCMC,M_SCMC_d,M_SCMC_dd];
%         genuineFeatureCell{i} = M_SCMC_final;
%         writematrix(genuineFeatureCell{i},filename);
%     end
% feature_type = 'SSFC';
%     filename = strcat(baseOutputFolder, '/',feature_type,'/', mySubdir, '/', outName,'.xlsx');
%     if ~exist(filename, 'file')
%         if ~exist(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'), 'dir')
%              mkdir(strcat(baseOutputFolder, '/',feature_type, '/', mySubdir, '/'));
%         end
% 
%         [coeffs_SSFC,delta_SSFC,deltaDelta_SSFC]=extract_ssfc(x,fs,20,512,20);
%          M_SSFC=mean(coeffs_SSFC);
%          M_SSFC_d=mean(delta_SSFC);
%          M_SSFC_dd=mean(deltaDelta_SSFC);
%          M_SSFC_final = [M_SSFC,M_SSFC_d,M_SSFC_dd];
%         genuineFeatureCell{i} = M_SSFC_final;
%         writematrix(genuineFeatureCell{i},filename);
%     end
end
disp('Done!');
