
% Clear all the previous stuff
clc;
if ~ismac
    close all;
    clear Screen;
end

% make sure we got access to all the required functions and inputs
initEnv();

% set and load all the parameters to run the experiment
cfg = setParameters;
cfg = userInputs(cfg);
cfg = createFilename(cfg);

%%  Experiment

% Safety loop: close the screen if code crashes
try

    %% Init the experiment
    [cfg] = initPTB(cfg);
    
    % load sounds & make beep sounds for events
    [cfg] = loadAudioFiles(cfg);
    
    % pseudorandom order of blocks and targets in events
    [cfg] = expDesign(cfg);

    % Prepare for the output logfiles with all
    logFile.extraColumns = cfg.extraColumns;
    logFile = saveEventsFile('init', cfg, logFile);
    logFile = saveEventsFile('open', cfg, logFile);
    
    % want to see cfg?
    disp(cfg);

    % Show experiment instruction
    standByScreen(cfg);

    % prepare the KbQueue to collect responses
    getResponse('init', cfg.keyboard.responseBox, cfg);

    % Wait for Trigger from Scanner
    waitForTrigger(cfg);
    
    %% Experiment Start

    cfg = getExperimentStart(cfg);

    getResponse('start', cfg.keyboard.responseBox);

    % after this wait time, exp hears the audio cue for which body part to
    % move
    waitFor(cfg, cfg.timing.participantWaitForCue);
     
    %% For Each Block

    for iBlock = 1:cfg.design.nbBlocks

        fprintf('\n - Running block %d, %s \n', iBlock, ...
                cfg.design.blockNamesOrder{iBlock}); 
        
        % now wait up till 2s left and play the cue, then go directly to
        % the event - 
        if iBlock ~= 1
            waitFor(cfg, cfg.timing.IBI(iBlock) - cfg.timing.cueDuration);
        end
        
        if cfg.doAudio
            % participant's audio cue to know where to move
            [thisBlock] = playCueAudio(cfg, iBlock);
            if cfg.timing.cueDuration > 2
                waitFor(cfg, cfg.timing.cueDuration - thisBlock.cueDuration)
            end
        end
        
        %participant's visual cue to where where to move
        if cfg.doVisual
            % display the cue till cueDuration is over
            [thisBlock] = bodyPartInfoScreen(cfg, cfg.design.blockNamesOrder{iBlock}); 
        end
        
        for iEvent = 1:cfg.design.nbEventsPerBlock

            fprintf('\n - Running trial %.0f \n', iEvent);

            % Check for experiment abortion from operator
            checkAbort(cfg, cfg.keyboard.keyboard);

            [thisEvent, thisFixation, cfg] = preTrialSetup(cfg, iBlock, thisBlock, iEvent);

            % play the sounds and collect onset and duration of the event
            [onset, duration] = doAudioVisual(cfg, thisEvent, thisFixation);
            
            
            thisEvent = preSaveSetup( ...
                                     thisEvent, ...
                                     iBlock, ...
                                     iEvent, ...
                                     duration, onset, ...
                                     cfg, ...
                                     logFile);

            saveEventsFile('save', cfg, thisEvent);

            responseEvents = getResponse('check', cfg.keyboard.responseBox, cfg);
            collectAndSave(responseEvents, cfg, logFile, cfg.experimentStart);

        end
        
    end

    % End of the run for the BOLD to go down
    waitFor(cfg, cfg.timing.endDelay);

    cfg = getExperimentEnd(cfg);

    % Close the logfiles
    saveEventsFile('close', cfg, logFile);

    getResponse('stop', cfg.keyboard.responseBox);
    getResponse('release', cfg.keyboard.responseBox);

    % create json for bold
    createJson(cfg, 'func');
    
    % save config info
    saveCfg(cfg);

    farewellScreen(cfg);

    cleanUp();

catch

    % save config info
    saveCfg(cfg);
    
    cleanUp();
    psychrethrow(psychlasterror);

end
