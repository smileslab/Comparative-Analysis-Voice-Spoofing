
% Extracts LP group delay using forward difference
% Vector based processing
% tau = extract_lpGdelay_diff(speechFrames,lpOrder,nfft)
% where all the frames are passed at once
%

function tau = extract_lpGdelayVec_diff(speechFrames, lpOrder,nfft)

NFFT = nfft;

% add a small dither
speechFrames = speechFrames + 1e-8;

% Do LP analysis and compute all-pole phase spectra

[a,g] = lpc(speechFrames',lpOrder);
A = fft(a',NFFT);
A = 1 ./ A;
phaseA = unwrap(angle(A));
phaseA = phaseA(1:NFFT/2,:);
tauA = -1 * diff(phaseA);
% diff has one fft bin less, so we repeat the last one
tau = [tauA;tauA(end,:)];
tau = tau';

end