% (C) Copyright 2020 CPP visual motion localizer developpers

function varargout = preSaveSetup(varargin)
    % varargout = postInitializatinSetup(varargin)

    % generic function to prepare structures before saving

    [thisEvent, iBlock, iEvent, duration, onset, cfg, logFile] = ...
        deal(varargin{:});
    
    thisEvent.isStim = logFile.isStim;
    thisEvent.event = iEvent;
    thisEvent.block = iBlock;
    
    thisEvent.keyName = 'n/a';
    thisEvent.duration = duration;
    thisEvent.onset = onset - cfg.experimentStart;
    
    if mod(iEvent,12) == 1
        thisEvent.duration = 12;
    end
    
    % % % an idea for block duration
    % block(i).onset = block(i).event(1).onset
    % block(i).duration = block(i).event(12).onset +
    %                                 block(i).event(12).duration -
    %                                 block(i).event(1).onset (edited)
    
    % % %
    
    % Save the events txt logfile
    % we save event by event so we clear this variable every loop
    thisEvent.fileID = logFile.fileID;
    thisEvent.extraColumns = logFile.extraColumns;

    varargout = {thisEvent};

end
