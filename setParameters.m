% (C) Copyright 2020 CPP visual motion localizer developpers

function [cfg] = setParameters()

    % Template PTB experiment

    % Initialize the parameters and general configuration variables
    cfg = struct();

    % by default the data will be stored in an output folder created where the
    % setParamters.m file is
    % change that if you want the data to be saved somewhere else
    cfg.dir.output = fullfile( ...
                              fileparts(mfilename('fullpath')), '..', ...
                              'output');

    %% Debug mode settings

    cfg.debug.do = false; % To test the script out of the scanner, skip PTB sync
    cfg.debug.smallWin = false; % To test on a part of the screen, change to 1
    cfg.debug.transpWin = false; % To test with trasparent full size screen

    cfg.verbose = 1;

    cfg.skipSyncTests = 1; % 0 
    
    %% TASK - quick fix for now
    % brutally saying no target - no task?
    cfg.audio.noTask = 0;
    
    %% Engine parameters

    cfg.testingDevice = 'mri';
    cfg.eyeTracker.do = false;
    cfg.audio.do = true;

    cfg = setMonitor(cfg);

    % Keyboards
    cfg = setKeyboards(cfg);

    % MRI settings
    cfg = setMRI(cfg);

    cfg.pacedByTriggers.do = false;

    %% Experiment Design

    cfg.design.blockNames = {'hand','feet','lips'}; 
%     cfg.design.blockNames = {'hand','feet','nose', 'tongue', ...
%                             'lips', 'cheek', 'forehead'}; 
% order is important fur playing cues
% NEW ORDER [1:7] is hand, feet, lips, tongue, nose, cheek, forehead

    % per condition
    cfg.design.nbRepetitions = 7; % main exp with 7 condition, repetition = 3;

    % we have 12s block, and we brush in every 1s
    cfg.design.nbEventsPerBlock = 12;
    
    % loudness adjustment
    cfg.amp = 0.95;
    %% Timing - NEED CARE
    % currently we present audio to the exp during the ISI and IBI
    % even duration = ISI + beep duration
    % IBI = has audio cue + silence
    
    % we will model 1 block in GLM, we need a block duration in logfile


    cfg.timing.eventDuration = 1; % second

    % Time between blocs in secs, here set as default
    cfg.timing.IBI = 8;
    
    % jitter do = makes an array contains for each block with jittered IBI
    % jitter do not = an array with constant IBI 
    cfg.timing.doJitter = 1;

%     % Time between events in secs
%     cfg.timing.ISI = 0.25;

    % auditory beeps length in second
    cfg.timing.beepDuration = 0.25; 

    %% Task(s)

    % task name 
    cfg.task.name = 'somatotopy';
     % it won't ask you about group or session
    cfg.subject.askGrpSess = [0 0];

    % Instruction
    cfg.task.instruction = 'Count how many "no brushing trials"\n Press during gaps, how many you detected! \n\n';
    if cfg.audio.noTask
        cfg.task.instruction = 'Please pay attention to the stimulated body part\n  \n\n';
    end
    
    % Fixation cross (in pixels)
    cfg.fixation.type = 'cross';
    cfg.fixation.colorTarget = cfg.color.red;
    cfg.fixation.color = cfg.color.white;
    cfg.fixation.width = .25;
    cfg.fixation.lineWidthPix = 3;
    cfg.fixation.xDisplacement = 0;
    cfg.fixation.yDisplacement = 0;

    % max number of targets within a block
    cfg.target.maxNbPerBlock = 2;
    
    % the experimenter will brush not in 1s but in 500ms - higher velocity
    % only used in logfile
    cfg.target.duration = 0.5;

    cfg.extraColumns = { ...
                        'soundTarget', ...
                        'fixationTarget', ...
                        'event', ...
                        'block', ...
                        'blockCueOnset', ...
                        'blockCueOnsetEnd', ...
                        'blockCueDuration',...
                        'blockCueDuration2',...
                        'keyName'};
                    
    %% Auditory Stimulation

    cfg.audio.channels = 1;
    
    % repeat body part audio cues twice
    cfg.audio.cueRepeat = 2;
    
    % more often beeps?
    % alternative - with more beeps within 1 s
    cfg.audio.moreBeeps = 0;
    
    % silent task? so no frequency beeps, but silence during block
    cfg.audio.silentTask = 1;
    
end

function cfg = setKeyboards(cfg)

cfg.keyboard.escapeKey = 'ESCAPE';
cfg.keyboard.responseKey = {'d', 'a', 'c', 'b'};
cfg.keyboard.keyboard = [];
cfg.keyboard.responseBox = [];


if strcmpi(cfg.testingDevice, 'mri')
    cfg.keyboard.keyboard = [];
    cfg.keyboard.responseBox = [];
end
end

function cfg = setMRI(cfg)

% BIDS compatible logfile folder
cfg.dir.output = fullfile(...
    fileparts(mfilename('fullpath')),'..', ...
    'output');
    
% letter sent by the trigger to sync stimulation and volume acquisition
cfg.mri.triggerKey = 's';
% for hyberpand insert 4 here! ! ! 
cfg.mri.triggerNb = 1; 

% json sidecar file for bold data
cfg.mri.repetitionTime = 1.75;

cfg.bids.MRI.Instructions = 'Counting no-brush trials';
if cfg.audio.noTask
    cfg.bids.MRI.Instructions = 'Passively paying attention thr stimuli';
end

cfg.bids.MRI.TaskDescription = [];
cfg.bids.mri.SliceTiming = [0, 0.9051, 0.0603, 0.9655, 0.1206, 1.0258, 0.181, ...
                      1.0862, 0.2413, 1.1465, 0.3017, 1.2069, 0.362, ...
                      1.2672, 0.4224, 1.3275, 0.4827, 1.3879, 0.5431, ...
                      1.4482, 0.6034, 1.5086, 0.6638, 1.5689, 0.7241, ...
                      1.6293, 0.7844, 1.6896, 0.8448, 0, 0.9051, 0.0603, ...
                      0.9655, 0.1206, 1.0258, 0.181, 1.0862, 0.2413, ...
                      1.1465, 0.3017, 1.2069, 0.362, 1.2672, 0.4224, ...
                      1.3275, 0.4827, 1.3879, 0.5431, 1.4482, 0.6034, ...
                      1.5086, 0.6638, 1.5689, 0.7241, 1.6293, 0.7844, ...
                      1.6896, 0.8448];

%Number of seconds before the rhythmic sequence (exp) are presented
cfg.timing.onsetDelay = 4 *cfg.mri.repetitionTime; %7
% Number of seconds after the end of all stimuli before ending the fmri run!
cfg.timing.endDelay = 5 * cfg.mri.repetitionTime; %8.75

% beginning of exp, give experimenter a cue to get ready for tactile stim
cfg.timing.experimenterCueOnsetDelay = 2; % in s
cfg.timing.afterCueOnsetDelay = cfg.timing.onsetDelay - cfg.timing.experimenterCueOnsetDelay;

% % % currently not used % % %
% ending timings for fMRI
%end the screen after thank you screen
cfg.timing.endScreenDelay = 2; 
% delay for script ending
% waiting time for participants responding how many times they detected the
% velocity change
cfg.timing.endResponseDelay = 10; 
% % % % % % % %


end



function cfg = setMonitor(cfg)

% Text format 
cfg.text.font         = 'Arial';
cfg.text.size         = 48;


% Monitor parameters for PTB
cfg.color.white = [255 255 255];
cfg.color.black = [0 0 0];
cfg.color.red = [255 0 0];
cfg.color.grey = mean([cfg.color.black; cfg.color.white]);
cfg.color.background = cfg.color.grey;
cfg.text.color = cfg.color.white;

% Monitor parameters
if strcmpi(cfg.testingDevice, 'mri')
    cfg.screen.monitorWidth = 69.8;
    cfg.screen.monitorDistance = 170;
end

end
