function [thisBlock]  = playCueAudio(cfg, iBlock)

    %% Get parameters        
    soundData = cfg.soundData;
    
    % set block name
    block = cfg.design.blockOrder(iBlock);
    % NEW ORDER [1:5] is hand, feet, lips, tongue, forehead

    switch block
        case 1
            fieldName = 'H';
        case 2
            fieldName = 'Fe';
        case 3
            fieldName = 'L';
        case 4
            fieldName = 'To';
        case 5
            fieldName = 'Fo';
    end

    soundCh1 = soundData.(fieldName);
    soundCh2 = soundCh1;

    % it will play the name of the block and wait till rest of the gap
    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, [soundCh1;soundCh2]);
    PsychPortAudio('Start', cfg.audio.pahandle,cfg.audio.cueRepeat);
    onset = GetSecs;
    
        % Get the end time
    waitForEndOfPlayback = 1; 
    [onsetEnd, ~, ~, estStopTime] = PsychPortAudio('Stop', cfg.audio.pahandle, ...
                                                waitForEndOfPlayback);

    duration = estStopTime - onsetEnd;
    duration2 = estStopTime - onset;
    
    % save them into a structure
    thisBlock.cueOnset = onset - cfg.experimentStart;
    thisBlock.cueOnsetEnd = onsetEnd - onset;
    thisBlock.cueDuration = duration;
    thisBlock.cueDuration2  = duration2;

            
end