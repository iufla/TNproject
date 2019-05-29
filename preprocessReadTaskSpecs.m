% read in a task description and format it into a struct with fieldnames =
% column names of original file

function specs_f = preprocessReadTaskSpecs(filename)
    sprintf(filename)

    t = textread(filename,'%s','delimiter','\n');
    header = strsplit(t{1});
    specs = struct();
    for line=2:numel(t)
        data = strsplit(t{line});
        for i=1:numel(header)
            if strcmp(header{i},'condition')
                specs(line-1).(header{i}) = data{i};
            else
                specs(line-1).(header{i}) = str2double(data{i});
            end
        end
    end

    offset = 14;    % offset from start of task until part of interest begins [s]

    % determine tasks containing intentional harm and accidental harm
    % (condition names ending with 'I' or 'A')
    intentionalIndices = [];
    accidentalIndices = [];
    harmIndices = [];
    harmLabels = {'A_PHA','B_PSA','F_PHI','G_PSI'};
    for n=1:numel(specs)
        if any(contains(harmLabels,specs(n).condition))
            if strcmp(specs(n).condition(end),'I')
                intentionalIndices = [intentionalIndices,n];
            else
                accidentalIndices = [accidentalIndices,n];
            end
            harmIndices = [harmIndices,n];
        end

    end

    % create arrays with onsets [s] and durations [s] of the two conditions of
    % interest (intentional and accidental harm)
    % everything *2 because the old data available through aws wasn't
    % scaled to the real time
    onsetsIntentional = [specs(intentionalIndices).onset] * 2 + offset;
    onsetsAccidental = [specs(accidentalIndices).onset] * 2 + offset;
    onsetsHarm = [specs(harmIndices).onset] * 2 + offset;

    durationsIntentional = [specs(intentionalIndices).duration] * 2 - offset;
    durationsAccidental = [specs(accidentalIndices).duration] * 2 - offset;
    durationsHarm = [specs(harmIndices).duration] * 2 - offset;
    
    specs_f = struct('onsetsHarm',onsetsHarm,'onsetsIntentional', onsetsIntentional, 'onsetsAccidental', onsetsAccidental, 'durationsHarm',durationsHarm,'durationsIntentional', durationsIntentional, 'durationsAccidental', durationsAccidental);
end