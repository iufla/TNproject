% read in participant description and format it into a struct with fieldnames =
% column names of original file

% in line 27, specify whether subjects 7,17,27,28,44 should be
% automatically removed...

function specs_f = readParticipantSpecs()
    pathBase = what('TNproject');
    pathBase = pathBase.path;
    filename = fullfile(pathBase, 'data', 'participants.tsv');
    
    t = textread(filename,'%s','delimiter','\n');
    header = strsplit(t{1});
    specs = struct();
    for line=2:numel(t)
        data = strsplit(t{line});
        for i=1:numel(header)
            if strcmp(header{i},'age')
                specs(line-1).(header{i}) = str2double(data{i});
            else
                specs(line-1).(header{i}) = data{i};
            end
        end
    end

    % determine whether to remove certain subjects
    remove = 0;
    if remove == 1
        % exclude subjects 07 & 17 (preprocessing failed)
        % exclude subjects 27,28,44 (time series extraction failed)
        exclude_sub = [7 17 27 28 44];
        sub_id_all = [];
        for n=1:numel(specs)
           sub_id_all(n) = str2double(specs(n).participant_id(end-1:end));
        end
        [id,idx] = ismember(sub_id_all, exclude_sub)
        idx_logical = logical(idx)
        % remove rows from struct containing data from those subjects
        specs(idx_logical) = []
    end
    
    % determine subjects with ASD vs NT subjects
    % (group names ending with 'D' or 'T')
    ASDIndices = [];
    NTIndices = [];
    ASDNames = strings();
    NTNames = strings();
    for n=1:numel(specs)
       sub_id(n) = str2double(specs(n).participant_id(end-1:end));        
       if strcmp(specs(n).group(end),'D')
           %ASDIndices = [specs(n).participant_id,n];
           ASDIndices(n) = 1;
           NTIndices(n) = 0;
           ASDNames = [ASDNames specs(n).participant_id];
       else
           ASDIndices(n) = 0;
           NTIndices(n) = 1;
           NTNames = [NTNames specs(n).participant_id];
       end

    end
    
    ASD_subjects = sub_id(logical(ASDIndices));
    NT_subjects = sub_id(logical(NTIndices));
    
    specs_f = struct('ASDIndices', ASDIndices, 'NTIndices', NTIndices, 'sub_id', sub_id, 'ASD_subjects', ASD_subjects, 'NT_subjects', NT_subjects, 'ASD_names', ASDNames, 'NT_names', NTNames);
end