function [thisBlock]  = playCueAudio(cfg, iBlock)

    %% Get parameters        
    soundData = cfg.soundData;
    
    % set block name
    block = cfg.design.blockOrder(iBlock);
    % ORDER [1:7] is hand, feet, nose, tongue, lips, cheek, forehead
    % NEW ORDER [1:7] is hand, feet, lips, tongue, nose, cheek, forehead

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
            fieldName = 'N';
        case 6
            fieldName = 'C';
        case 7
            fieldName = 'Fo';
    end

    sound = soundData.(fieldName);

    % it will play the name of the block and wait till rest of the gap
    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, sound);
    PsychPortAudio('Start', cfg.audio.pahandle,cfg.audio.cueRepeat);
                
%     startTime = PsychPortAudio('Start', pahandle [, repetitions=1] [, when=0] [, waitForStart=0] [, stopTime=inf] [, resume=0]);
%                     PsychPortAudio('FillBuffer', cfg.audio.pahandle, sound);
%     PsychPortAudio('Start', cfg.audio.pahandle, [], ...
%                     cfg.experimentStart + cfg.timing.audiCueOnset,1);
    onset = GetSecs;
    
        % Get the end time
    waitForEndOfPlayback = 1; % hard coding that will need to be moved out
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