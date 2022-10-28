function [cfg] = loadAudioFiles(cfg)

    
    %% Load the sounds
    freq = [];
    
    %load auditory beep sounds
    % non-target sound
    fileName = fullfile('input', '350Hz_250ms.wav');
    [soundData.NT, freq(1)] = audioread(fileName);
    soundData.NT = soundData.NT';

    %% load the cue
    
    fileName = fullfile('input', 'hand2.wav');
    if cfg.do.expInFrench == 1
        fileName = fullfile('input','pouce_thumb.wav');
    end
    [soundData.H, freq(2)] = audioread(fileName);
    soundData.H = soundData.H';
    
    fileName = fullfile('input', 'feet.wav');
    if cfg.do.expInFrench == 1
        fileName = fullfile('input','orteils_toe.wav');
    end
    [soundData.Fe, freq(3)] = audioread(fileName);
    soundData.Fe = soundData.Fe';
    
    fileName = fullfile('input', 'forehead.wav');
    if cfg.do.expInFrench == 1
        fileName = fullfile('input','front_forehead.wav');
    end    
    [soundData.Fo, freq(4)] = audioread(fileName);
    soundData.Fo = soundData.Fo';
    
    fileName = fullfile('input', 'tongue2.wav');
    if cfg.do.expInFrench == 1
        fileName = fullfile('input','langue_tongue.wav');
    end  
    [soundData.To, freq(5)] = audioread(fileName);
    soundData.To = soundData.To';

    fileName = fullfile('input', 'lips.wav');
    if cfg.do.expInFrench == 1
        fileName = fullfile('input','levres_lips.wav');
    end  
    [soundData.L, freq(6)] = audioread(fileName);
    soundData.L = soundData.L';
    
    % load silence of 1s
    soundData.silence = zeros(1,length(soundData.H));
    
    % save them all    
    cfg.soundData = soundData;
    
    %%
    if length(unique(freq)) > 1
        error ('Sounds dont have the same sampling frequency');
    else
        freq = unique(freq);
    end

    cfg.audio.fs = freq;
    
    % make complete trial with beep sounds
    [cfg] = makeBeepAudio(cfg);
end