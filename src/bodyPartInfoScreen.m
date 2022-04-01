function [thisBlock] = bodyPartInfoScreen(cfg, textToPrint)
    %
    % It shows a basic one-page instruction stored in `cfg.task.instruction` and wait
    % for fixed duration 
    %
    % USAGE::
    %
    %  bodyPartInfoScreen(cfg)
    %
    
    Screen('FillRect', cfg.screen.win, cfg.color.background, cfg.screen.winRect);

    DrawFormattedText(cfg.screen.win, ...
                      textToPrint, ...
                      'center', 'center', cfg.text.color);

    vbl = Screen('Flip', cfg.screen.win);

    % Wait time before continue
    WaitSecs(cfg.timing.cueDuration);
    
    % get end time
    vblStopTime = GetSecs();
    duration = vblStopTime - vbl;
    
    % save them into a structure
    thisBlock.cueOnset = vbl - cfg.experimentStart;
    thisBlock.cueDuration = duration;
    % dummy numbers
    thisBlock.cueOnsetEnd = vblStopTime - cfg.experimentStart;
    thisBlock.cueDuration2  = duration;
end