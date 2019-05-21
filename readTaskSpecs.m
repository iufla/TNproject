% read in a task description and format it into a struct with fieldnames =
% column names of original file
t = textread('sub-03_func_sub-03_task-dis_run-01_events.tsv','%s','delimiter','\n');
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
for n=1:numel(specs)
   if strcmp(specs(n).condition(end),'I')
       intentionalIndices = [intentionalIndices,n];
   else
       accidentalIndices = [accidentalIndices,n];
   end
   
end

% create arrays with onsets [s] and durations [s] of the two conditions of
% interest (intentional and accidental harm)
onsetsIntentional = [specs(intentionalIndices).onset] + offset;
onsetsAccidental = [specs(accidentalIndices).onset] + offset;

durationsIntentional = [specs(intentionalIndices).duration] - offset;
durationsAccidental = [specs(accidentalIndices).duration] - offset;