
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
    % brush
    waitFor(cfg, cfg.timing.experimenterCueOnsetDelay);
     
    %% For Each Block

    for iBlock = 1:cfg.design.nbBlocks

        fprintf('\n - Running block %s \n', cfg.design.blockNamesOrder{iBlock}); 
        
        % experimenter's cue to know where to stimulate
        [thisBlock]  = playCueAudio(cfg, iBlock);

        if iBlock == 1
            % wait time after auditory cue for beginning of exp
            waitFor(cfg, cfg.timing.afterCueOnsetDelay - thisBlock.cueDuration);
        else
            % wait time in between 2 blocks
            % IBI - the audio cue playing tme (1s)
            waitFor(cfg, cfg.timing.IBI(iBlock) - thisBlock.cueDuration);
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

%            waitFor(cfg, cfg.timing.ISI);

        end
        
    end

    % End of the run for the BOLD to go down
    waitFor(cfg, cfg.timing.endDelay);

    cfg = getExperimentEnd(cfg);

    % Close the logfiles
    saveEventsFile('close', cfg, logFile);

    getResponse('stop', cfg.keyboard.responseBox);
    getResponse('release', cfg.keyboard.responseBox);

    % createJson(cfg, cfg);
    % think about the below
    createJson(cfg, 'func');

    farewellScreen(cfg);

    cleanUp();

catch
    
    % think about adding save option if it crashes
    % ?

    cleanUp();
    psychrethrow(psychlasterror);

end
