% Acoustic ternary paterns implementation 
%  function [ltp_full]=LTP_speech(x,thresh)
% x(t) is the signal (audio signal) in digitized form
% folder = fullfile('Please put the link of folder containing audio samples');

function extract_atp(infolder, outfolder)

ADS = audioDatastore(infolder);
while hasdata(ADS)
    x=read(ADS);
sname='Sheet1';
startingColumn='A'

inputFiles = dir(fullfile(baseInputFolder,'**/*.flac'));
genuineFeatureCell = cell(size(inputFiles));
for i = 1:length(inputFiles);
filename = outfil 
% 'Please put the link of excel file where you want to save the ATP features';
nextRow=1;
% if P=8, it means 8 neighbours and 1 reference sample. total frame size
% will be 9 in this case
% x=x1(1:27,1);
thresh=0.0002;

P=8; % no of neighbours for computation 
% thresh=0.01;  % in future take this value in INPUT 

b_right=zeros(1,4); % variables for computing differnces on sides
b_left=b_right;

[row,c]=size(x); % total number of samples is "row"
total_frames=row/9;  % number of total frames as 1 Frames=9 samples
% so total frames = total samples/ frame size
% full_frame=zeros(9,500);
k=1;
i=5;
aa=rem(row,P+1); % in this case P+1=9;
last_index=row-aa;

for i=5:9:last_index  %runs for tatal number of samples in signal
    for r=0:(P/2)-1  % Sumation loop from formula
        
     neighbour=x(i + (r-(P/2)));
     center=x(i);
     if(neighbour > center+ thresh)
         b_left(r+1)=1;
     elseif( (neighbour > center-thresh) && (neighbour < center+thresh))
         b_left(r+1)=0;
     elseif (neighbour < center-thresh)
         b_left(r+1)=-1;
     end
 
     neighbour=x(i+r+1);
     center=x(i);
     if(neighbour > center+ thresh)
         b_right(r+1)=1;
     elseif( (neighbour > center-thresh) && (neighbour < center+thresh))
         b_right(r+1)=0;
     elseif (neighbour < center-thresh)
         b_right(r+1)=-1;
     end
    end
    
    full_frame(:,k) = [b_left  b_right]; % combine Right and LEFT frames
    
    % logic for binary histograms distribution into uper_ltp and lower_ltp
   for r=1:8 
    if((full_frame(r,k)==1))
         uper_frame(r,k)= 1;
    else
        uper_frame(r,k)=0;
    end
    
    if(full_frame(r,k)==-1)
        lower_frame(r,k)=1;
    else
        lower_frame(r,k)=0; 
    end
   end
   
   %binary to decimal conversion
   ltp_lower(1,k)= 1*lower_frame(1,k)+2*lower_frame(2,k)+4*lower_frame(3,k)+8*lower_frame(4,k)+16*lower_frame(5,k)+32*lower_frame(6,k)+64*lower_frame(7,k)+128*lower_frame(8,k);
   ltp_uper(1,k)= 1*uper_frame(1,k)+2*uper_frame(2,k)+4*uper_frame(3,k)+8*uper_frame(4,k)+16*uper_frame(5,k)+32*uper_frame(6,k)+64*uper_frame(7,k)+128*uper_frame(8,k);
    
 k=k+1;
 
 
end % main signal loop ends here

 ltp_hist_uper=hist(ltp_uper,10);
 ltp_hist_lower=hist(ltp_lower,10);
 
 ltp_full=[ltp_hist_uper ltp_hist_lower]; % contatinate both uper and lower vectors
 range=sprintf('%s%d',startingColumn,nextRow);
% writematrix(ltp_full,filename,'Sheet',sname,'Range',range);
xlswrite(filename,ltp_full,sname,range);

nextRow=nextRow+1;
end

% end % funciton ends here


