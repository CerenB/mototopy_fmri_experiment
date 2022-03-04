function onset  = playBeepAudio(cfg)

    %% Get parameters        
    soundData = cfg.soundData;
    fieldName = 'eventNoTarget';
    
    sound = soundData.(fieldName);

    
    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, sound);
    PsychPortAudio('Start', cfg.audio.pahandle);
    onset = GetSecs;

    % PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);

%     
%     %% play sequences
%     % fill the buffer % start sound presentation
%     PsychPortAudio('FillBuffer', cfg.audio.pahandle, ...
%         [currSeq.outAudio;currSeq.outAudio]);
%     
%     % wait for baseline delays and then start the audio
%     onset = PsychPortAudio('Start', cfg.audio.pahandle, [], ...
%         cfg.experimentStart + cfg.timing.onsetDelay,1);
    
    
end