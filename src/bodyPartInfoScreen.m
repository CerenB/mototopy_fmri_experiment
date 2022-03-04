function bodyPartInfoScreen(cfg, textToPrint)
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

    Screen('Flip', cfg.screen.win);

    % Wait for space key to be pressed
     WaitSecs(cfg.timing.cueDuration);

end