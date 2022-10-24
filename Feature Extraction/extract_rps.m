function [stat,delta,double_delta]=extract_rps(speech,Fs,Window_Length,No_Filter)
% Function for computing RPS features 
% Usage: [stat,delta,double_delta]=extract_rps(file_path,Fs,Window_Length,No_Filter) 
% Note!!!: This requires COVAREP package: https://github.com/covarep/covarep

% Input: file_path=Path of the speech file
%        Fs=Sampling frequency in Hz
%        Window_Length=Window length in ms
%        No_Filter=No of filter
%
%Output: stat=Static RPS (Size: NxNo_Filter where N is the number of frames)
%        delta=Delta RPS (Size: NxNo_Filter where N is the number of frames)
%        double_delta=Double Delta RPS (Size: NxNo_Filter where N is the number of frames)
%
%        Written by Md Sahidullah at School of Computing, University of
%        Eastern Finland (email: sahid@cs.uef.fi)
%        
%        Implementation details are available in the following paper:
%        M. Sahidullah, T. Kinnunen, C. Hanilçi, ”A comparison of features 
%        for synthetic speech detection”, Proc. Interspeech 2015, 
%        pp. 2087--2091, Dresden, Germany, September 2015.
%


%speech=audioread(file_path);




% rng('default');
% speech=speech+randn(size(speech))*eps;


fs=Fs;
f0min=80;
f0max=500;
hopsize=Window_Length/2;

[F0s,VUVDecisions,SRHVal,time] = pitch_srh(speech,fs,f0min,f0max,hopsize);

f0s=[time; F0s]';
dftlen = 512;


opt = sin_analysis();
opt.fharmonic  = true; % Use sinusoidal model (no constrains on the frequencies)
opt.use_ls     = false; % Use Peak Picking
opt.dftlen     = dftlen;  % Force the DFT length
opt.frames_keepspec = true; % Keep the computed spectra in the frames structure
opt.win_dropoutside=false; 
frames = sin_analysis(speech, fs, f0s, opt);


% Phase
opt = phase_rpspd();
opt.harm2freq = true;
opt.pd_method = 2;
opt.pd_vtf_rm = false;
opt.polarity_inv = true;
opt.dftlen     = dftlen; 
RPS= phase_rpspd(frames, fs, opt);



f=fs*linspace(0,1,dftlen/2+1);
fmel=2595*log10(1+f./700); % CONVERTING TO MEL SCALE
fmelmax=max(fmel);
fmelmin=min(fmel);
filbandwidthsmel=linspace(fmelmin,fmelmax,No_Filter+2);
filbandwidthsf=700*(10.^(filbandwidthsmel/2595)-1);

for i=1:No_Filter
    filterbank(:,i)=trimf(f,[filbandwidthsf(i),filbandwidthsf(i+1),...
        filbandwidthsf(i+2)]);
end



Unwrap_RPS=unwrap(RPS');

Pad=zeros(1,size(F0s,2));

DIFUW_RPS=[Pad; diff(Unwrap_RPS)];

t=DIFUW_RPS'*filterbank;

stat=dct(t')';

delta=deltas(stat',3)';
double_delta=deltas(delta',3)';


stat=stat(VUVDecisions==1,:);
delta=delta(VUVDecisions==1,:);
double_delta=double_delta(VUVDecisions==1,:);
