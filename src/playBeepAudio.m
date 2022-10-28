function onset  = playBeepAudio(cfg)

    %% Get parameters        
    soundData = cfg.soundData;
    fieldName = 'eventNoTarget';
    
    soundCh1 = soundData.(fieldName);
    soundCh2 = soundCh1;
    
    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, [soundCh1; soundCh2]);
    PsychPortAudio('Start', cfg.audio.pahandle);
    onset = GetSecs;
    
    
end