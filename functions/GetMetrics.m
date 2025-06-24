function [ivT] = GetMetrics(mT)
    
    IVmetrics = ["ID", "Sex", "Strain", "Acquire", "Intake", "Seeking", "Association", "Escalation"...
                 "Extinction", "Persistence", "Flexibility", "Relapse", "Recall"];  
    numNonMets = 4; % refers to the first 3 elements of IVmetrics being labels rather than numeric metrics
    ID = unique(mT.TagNumber);

    % Individual Variable Table
    ivT = table('Size', [length(ID), length(IVmetrics)], 'VariableTypes', ...
               [repmat({'categorical'}, [1,numNonMets]), repmat({'double'}, [1, length(IVmetrics) - numNonMets])], ...
                'VariableNames', IVmetrics);
    ivT{:, IVmetrics(numNonMets + 1:end)} = nan;
    
    for i=1:length(ID)
        this_ID = mT.TagNumber == ID(i);
        ivT.ID(i) = ID(i);
        ivT.Sex(i) = unique(mT.Sex(this_ID));
        ivT.Strain(i) = unique(mT.Strain(this_ID));
        ivT.Acquire(i) = unique(mT.Acquire(this_ID));
        ivT.Intake(i) = sum(mT.Intake(this_ID & mT.sessionType == 'Training')); % Sum of intake during training sessions (6-15)
        ivT.Seeking(i) = sum(mT.HeadEntries(this_ID &  mT.sessionType =='Training')); % Sum of intake during training sessions (6-15)
        ivT.Association(i)= 300-(nanmean(mT.Latency(this_ID & mT.sessionType == 'Training'))); % Average Latency scaled to maximum available latency so strong association (low latency) is given high values
        e = polyfit(double(mT.Session(this_ID & mT.Session < 11)), ...
                           mT.EarnedInfusions(this_ID & mT.Session < 11),1);
        ivT.Escalation(i)=e(1); % Slope of earned Infusions during week 1 & 2 
        if isnan(ivT.Association(i))
            ivT.Association(i) = 0;
        end

        includeER = ~isempty(find(this_ID & (mT.sessionType == 'Extinction')));

        if includeER
            ivT.Extinction(i)= sum(mT.ActiveLever(this_ID & mT.sessionType == 'Extinction')); % Sum of Active lever during training sessions
            p = polyfit(double(mT.Session(this_ID & mT.sessionType == 'Extinction')), ...
                               mT.ActiveLever(this_ID & mT.sessionType == 'Extinction'),1); 
            ivT.Persistence(i) = p(1); % Slope of Active lever presses during extinction
            ivT.Flexibility(i) = sum(mT.InactiveLever(this_ID & mT.sessionType == 'Extinction')); % Sum of Inactive lever during training sessions
            ivT.Relapse(i) = mT.ActiveLever(this_ID & mT.sessionType == 'Reinstatement');
            ivT.Recall(i) = 300-(mT.Latency(this_ID & mT.sessionType == 'Reinstatement')); % Average Latency scaled to maximum available latency so strong association (low latency) is given high values
            if isnan(ivT.Recall(i))
                ivT.Recall(i) = 0;
            end
        end
    end   
end