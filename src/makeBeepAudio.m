function [cfg] = makeBeepAudio(cfg)

% insert the soundData (audio beeps with 250ms long) with silence of 
% the rest of trial/event duration 
% then make audio with sounds + event silences

fs = cfg.audio.fs(1);
amplitude = cfg.amp;

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


%insert no-target sound event
eventNoTarget(1:length(soundNoTarget)) = soundNoTarget;

    
% arrange the almplitude
eventNoTarget = eventNoTarget.*amplitude;

% save them
cfg.soundData.eventNoTarget = eventNoTarget;


% stupid fix - change it LATER
% if don't do audio, then play silences for 12times
if ~cfg.doAudio
    cfg.soundData.eventNoTarget = zeros(1,length(eventNoTarget));
end

% % to visualise 1 pattern
% figure; plot(t,eventTarget);

end 