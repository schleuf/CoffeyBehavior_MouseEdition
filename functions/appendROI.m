function    mT = appendROI(mT,roi_datapath); 
% appendROI takes the output of SIMBA and adds it to the master table (mT)
% to include video analysis

%% INPUTS
%  mT - Master Table from main_MouseSABehavior
%  roi_datapath - path containing ROI data files. Tables must contain a:
%  "TagNumber" variable {categorical}
%  "video" variable with: R[DATE]_[TIME]_BOX#_AM/PM: Ex:R2024-07-01_09-32-26_BOX2_AM
%
%% OUTPUTS
%  mT - appended master table with ROI data and a new column for videoOffset
%  "videoOffset" - time offset of video file as compared to MED-PC file (s)
%  "videoOffset" - subtract this value from all ROI timestamps to align with MED-PC data
%  

%% Find and Import ROI Tables
roiFiles = dir(fullfile(roi_datapath{1},"*ROI*"));
% Initialize an empty table to store combined ROI data
combinedROI = table();

% Loop through each ROI file and import the data
for i = 1:length(roiFiles)
    roiData = readtable(fullfile(roi_datapath{1}, roiFiles(i).name));
    combinedROI = [combinedROI; roiData]; % Append the data to the combined table
end
combinedROI.TagNumber=categorical(combinedROI.TagNumber);

%Remove Var1 from combinedROI
try
combinedROI.Var1=[];
catch
end

% Extract Date and Time from video variable
videoDateTime = extractBetween(combinedROI.video, 2, 20); % Extract date substring
videoDates = extractBetween(combinedROI.video, 2, 11); % Extract date substring
combinedROI.Date = datetime(videoDates, 'InputFormat', 'yyyy-MM-dd');
combinedROI.videoDateTime = datetime(videoDateTime, 'InputFormat', 'yyyy-MM-dd_HH-mm-ss'); % Convert to datetime

% Join mT and combinedROI tables using TagNumber and Date as keys
mT = outerjoin(mT, combinedROI, 'Keys', {'TagNumber', 'Date'}, 'MergeKeys', true);
mT.videoOffset = seconds(mT.videoDateTime - mT.DateTime);


end