% (C) Copyright 2020 CPP visual motion localizer developpers

function varargout = preTrialSetup(varargin)
    % varargout = postInitializatinSetup(varargin)

    % generic function to prepare some structure before each trial

    [cfg, iBlock, thisBlock, iEvent] = deal(varargin{:});

    % set block name and targets
    thisEvent.trial_type = cfg.design.blockNamesOrder{iBlock};
    thisEvent.blockNb = cfg.design.blockOrder(iBlock);
    
    % store block IBI
    thisEvent.ibi = cfg.timing.IBI(iBlock);
    
    % save block info into thisEvent structure
    thisEvent.cueOnset = thisBlock.cueOnset;
    thisEvent.cueOnsetEnd = thisBlock.cueOnsetEnd;
    thisEvent.cueDuration = thisBlock.cueDuration;
    thisEvent.cueDuration2 = thisBlock.cueDuration2;
    
    % think about calculating duration properly
    if mod(iEvent,12) == 1
        thisEvent.trial_type = ['block_', cfg.design.blockNamesOrder{iBlock}];
    end
    

    thisEvent.fixationTarget = cfg.design.fixationTargets(iBlock, iEvent);
    thisEvent.soundTarget = cfg.design.soundTargets(iBlock, iEvent);
            
    % If this frame shows a target we change the color of the cross
    thisFixation.fixation = cfg.fixation;
    thisFixation.screen = cfg.screen;

    varargout = {thisEvent, thisFixation, cfg};

end
