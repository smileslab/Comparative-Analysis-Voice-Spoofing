function [stat,delta,double_delta]=extract_ssfc(speech,Fs,Window_Length,NFFT,No_Filter) 
% Function for computing SSFC features 
% Usage: [stat,delta,double_delta]=extract_ssfc(file_path,Fs,Window_Length,No_Filter) 
%
% Input: file_path=Path of the speech file
%        Fs=Sampling frequency in Hz
%        Window_Length=Window length in ms
%        NFFT=No of FFT bins
%        No_Filter=No of filter
%
%Output: stat=Static SSFC (Size: NxNo_Filter where N is the number of frames)
%        delta=Delta SSFC (Size: NxNo_Filter where N is the number of frames)
%        double_delta=Double Delta SSFC (Size: NxNo_Filter where N is the number of frames)
%
%        Written by Md Sahidullah at School of Computing, University of
%        Eastern Finland (email: sahid@cs.uef.fi)
%        
%        Implementation details are available in the following paper:
%        M. Sahidullah, T. Kinnunen, C. Hanili, A comparison of features 
%        for synthetic speech detection, Proc. Interspeech 2015, 
%        pp. 2087--2091, Dresden, Germany, September 2015.
%speech=readwav(file_path,'s',-1);
% speech=audioread(file_path);
%-------------------------- PRE-EMPHASIS ----------------------------------
speech = filter( [1 -0.97], 1, speech);
%---------------------------FRAMING & WINDOWING----------------------------
frame_length_inSample=(Fs/1000)*Window_Length;
framedspeech=buffer(speech,frame_length_inSample,frame_length_inSample/2,'nodelay')';
w=hamming(frame_length_inSample);
y_framed=framedspeech.*repmat(w',size(framedspeech,1),1);
%--------------------------------------------------------------------------
f=(Fs/2)*linspace(0,1,NFFT/2+1);
filbandwidthsf=linspace(min(f),max(f),No_Filter+2);
fr_all=(abs(fft(y_framed',NFFT))).^2;
fa_all=fr_all(1:(NFFT/2)+1,:)';
filterbank=zeros((NFFT/2)+1,No_Filter);

fr_all=(abs(fft(y_framed',NFFT)));
fr_all=fr_all';
fa_all=fr_all(:,1:(NFFT/2)+1);
NormFact=repmat(max(fa_all'),(NFFT/2)+1,1)';
fa_all=fa_all./NormFact;

fa_all_prev=[zeros(1,(NFFT/2)+1); fa_all(1:end-1,:)];

Spectralflux=(fa_all-fa_all_prev).^2;

for i=1:No_Filter
    filterbank(:,i)=trapmf(f,[filbandwidthsf(i),filbandwidthsf(i),...
        filbandwidthsf(i+2),filbandwidthsf(i+2)]);
end
filbanksum=Spectralflux*filterbank(1:end,:);
%------------------------- DCT OPERATION %---------------------------------
t=dct(log10(filbanksum'+eps));
stat=t'; 
delta=deltas(stat',3)';
double_delta=deltas(delta',3)';
