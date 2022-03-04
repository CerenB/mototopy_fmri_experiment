function [cfg] = makeBeepAudio(cfg)

% insert the soundData (audio beeps with 250ms long) with silence of 
% the rest of trial/event duration 
% then make audio with sounds + event silences


fs = cfg.audio.fs(1);

amplitude = cfg.amp;

% refractor to on the moment- creating a pure tone with a given frequency
% and duration as below:
% t = [0 : round(cfg.pattern.gridIOIs * cfg.fs)-1]/cfg.fs;
% % create carrier
% s = sin(2*pi*currF0*t);

% take no-target beep
soundNoTarget = cfg.soundData.NT(1,:);

% target event
soundTarget = cfg.soundData.T(1,:);

% % length of beep
% beepDuration = cfg.timing.beepDuration; 

% embed the no-target beep into 1s long trial
% while embed two target sounds within 1s

% whole length of trial/event
eventDuration = cfg.timing.eventDuration;
   
% make time vector
t = [0 : round(eventDuration * fs)-1] / fs; 

% preallocate to silence/zeros as default
eventNoTarget = zeros(1,length(t));
eventTarget = eventNoTarget;


if cfg.audio.moreBeeps
    
    % no target
     % define where to insert the sounds
    idxStart = length(soundNoTarget)+ 1 + length(soundNoTarget);
    idxEnd = 3 * length(soundNoTarget);
    
    %insert sound event
    eventNoTarget(1:length(soundNoTarget)) = soundNoTarget;
    eventNoTarget(idxStart:idxEnd) = soundNoTarget;
    
    % target places/indices
    idxStart2 = length(soundTarget)+ 1 + length(soundTarget);
    idxEnd2 = 3 * length(soundTarget);
    
    idxStart3 = idxEnd2 + length(soundTarget)+ 1 ;
    idxEnd3 = 5 * length(soundTarget);
    
    idxStart4 = idxEnd3 + length(soundTarget)+ 1 ;
    idxEnd4 = 7 * length(soundTarget);
    
    % target insert
    if ~cfg.audio.silentTask
        
        eventTarget(1:length(soundTarget)) = soundTarget; % 1st beep
        eventTarget(idxStart2:idxEnd2) = soundTarget;
        eventTarget(idxStart3:idxEnd3) = soundTarget;
        eventTarget(idxStart4:idxEnd4) = soundTarget;
    end
    
else

    %insert no-target sound event
    eventNoTarget(1:length(soundNoTarget)) = soundNoTarget;

    % define where to insert the sounds
    idxStart = length(soundTarget)+ 1 + length(soundTarget);
    idxEnd = 3 * length(soundTarget);
    
    % insert target sounds
    if ~cfg.audio.silentTask
        eventTarget(1:length(soundTarget)) = soundTarget;
        eventTarget(idxStart:idxEnd) = soundTarget;
    end
    
end
    
% arrange the almplitude
eventNoTarget = eventNoTarget.*amplitude;
eventTarget = eventTarget.*amplitude;

% save them
cfg.soundData.eventTarget = eventTarget;
cfg.soundData.eventNoTarget = eventNoTarget;

% easy fix for now - 
% omitting the target = going to passive 
if cfg.audio.noTask
    cfg.soundData.eventTarget = eventNoTarget;
end

% % to visualise 1 pattern
% figure; plot(t,eventTarget);

end 