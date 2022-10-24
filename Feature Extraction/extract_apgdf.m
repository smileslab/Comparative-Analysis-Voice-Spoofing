function [stat,delta,double_delta]=extract_apgdf(speech,Fs,Window_Length,NFFT,No_Filter) 
% Function for computing APGDF features 
% Usage: [stat,delta,double_delta]=extract_apgdf(file_path,Fs,Window_Length,No_Filter) 
%
% Input: file_path=Path of the speech file
%        Fs=Sampling frequency in Hz
%        Window_Length=Window length in ms
%        NFFT=No of FFT bins
%        No_Filter=No of filter
%
%Output: stat=Static APGDF (Size: NxNo_Filter where N is the number of frames)
%        delta=Delta APGDF (Size: NxNo_Filter where N is the number of frames)
%        double_delta=Double Delta APGDF (Size: NxNo_Filter where N is the number of frames)
%
%        Written by Md Sahidullah at School of Computing, University of
%        Eastern Finland (email: sahid@cs.uef.fi)
%        
%        Implementation details are available in the following paper:
%        M. Sahidullah, T. Kinnunen, C. Hanil�i, �A comparison of features 
%        for synthetic speech detection�, Proc. Interspeech 2015, 
%        pp. 2087--2091, Dresden, Germany, September 2015.
%-----------------------Reading Speech File--------------------------------
%speech=audioread(file_path);
% rng('default');
% speech=speech+randn(size(speech))*eps;
%-------------------------- PRE-EMPHASIS ----------------------------------
speech = filter( [1 -0.97], 1, speech);
%---------------------------FRAMING & WINDOWING----------------------------
frame_length_inSample=(Fs/1000)*Window_Length;
framedspeech=buffer(speech,frame_length_inSample,frame_length_inSample/2,'nodelay')';
w=hamming(frame_length_inSample);
y_framed=framedspeech.*repmat(w',size(framedspeech,1),1);
tau_lp = extract_lpGdelayVec_diff(y_framed,No_Filter,NFFT);
LPGDF=dct(tau_lp');
t=LPGDF';
stat=t(:,1:No_Filter);
delta=deltas(stat',3)';
double_delta=deltas(delta',3)';
%--------------------------------------------------------------------------
