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


if cfg.audio.moreBeeps
    
    % no target
     % define where to insert the sounds
    idxStart = length(soundNoTarget)+ 1 + length(soundNoTarget);
    idxEnd = 3 * length(soundNoTarget);
    
    %insert sound event
    eventNoTarget(1:length(soundNoTarget)) = soundNoTarget;
    eventNoTarget(idxStart:idxEnd) = soundNoTarget;
    
else

    %insert no-target sound event
    eventNoTarget(1:length(soundNoTarget)) = soundNoTarget;

end
    
% arrange the almplitude
eventNoTarget = eventNoTarget.*amplitude;

% save them
cfg.soundData.eventNoTarget = eventNoTarget;


% % to visualise 1 pattern
% figure; plot(t,eventTarget);

end 