function [onset, duration] = doAudioVisual(cfg, thisEvent, thisFixation)

    % Play the auditopry stimulation of moving in 4 directions or static noise bursts
    %
    % DIRECTIONS
    %  0=Right; 90=Up; 180=Left; 270=down; -1 static
    %
    % Input:
    %   - cfg: PTB/machine configurations returned by setParameters and initPTB
    %   - expParameters: parameters returned by setParameters
    %   - thisEvent: structure that the parameters regarding the event to present
    %
    % Output:
    %     - onset in machine time
    %     - duration in seconds
    %

    %% Get parameters

    % experimenter beep sound event
    onset = playBeepAudio(cfg, thisEvent);

    % draw first fixation and get a first visual time stamp
    % ideally we would want to synch that first time stamp and the sound start
    isFixationTarget = thisEvent.fixationTarget(1);
    
    % % % CB: target duration == 1s as the Non-target duration in auditory
    % % % but in vision it is 500ms for flickering
    targetDuration = cfg.target.duration;

    if isFixationTarget == 1
        thisFixation.fixation.color = cfg.fixation.colorTarget;
    end
    drawFixation(thisFixation);
    vbl = Screen('Flip', cfg.screen.win);

    while 1

        % set default cross cross color but update if target time is not
        % finished
        thisFixation.fixation.color = cfg.fixation.color;
        if GetSecs < (onset + targetDuration) && isFixationTarget == 1
            thisFixation.fixation.color = cfg.fixation.colorTarget;
        end

        drawFixation(thisFixation);
        vbl = Screen('Flip', cfg.screen.win, vbl + cfg.screen.ifi);

        status = PsychPortAudio('GetStatus', cfg.audio.pahandle);
        if ~status.Active
            break
        end

    end

    % Get the end time
    waitForEndOfPlayback = 1; % hard coding that will need to be moved out
    [onset, ~, ~, estStopTime] = PsychPortAudio('Stop', cfg.audio.pahandle, ...
                                                waitForEndOfPlayback);

    duration = estStopTime - onset;
    
    % playTime = PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
    
