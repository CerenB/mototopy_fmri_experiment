function [cfg] = expDesign(cfg, displayFigs)

    % refractored by CB on 01/02/2022 for Moebius Experiment
    % The conditions are body part blocks in pseudorandomized order
    %
    % Style guide: constants are in SNAKE_UPPER_CASE
    %
    % EVENTS
    % repetitions within the block defines the duration of each block
    %
    % Pseudorandomization rules:
    % (1) no consecutive forehead within 5 body parts
    % (2) No same consecutive body part presentation
    %
    % TARGETS
    % no targets
    % 
    % Input:
    % - cfg: parameters returned by setParameters
    % - displayFigs: a boolean to decide whether to show the basic design
    % matrix of the design
    %
    % Output:
    % - ExpParameters.designBlockNames = cell array (nr_blocks, 1) with the
    % name for each block
    %
    % - cfg.designFixationTargets = array (nr_blocks, numEventsPerBlock)
    % showing for each event if it should be accompanied by a target
    %

    %% Check inputs

    % Set to 1 for a visualtion of the trials design order
    if nargin < 2 || isempty(displayFigs)
        displayFigs = 0;
    end

    % Set variables here for a dummy test of this function
    if nargin < 1 || isempty(cfg)
        error('give me something to work with');
    end

    fprintf('\n\nCreating design.\n\n');

    [NB_BLOCKS, NB_CONDITION, NB_REPET, NB_EVENTS_PER_BLOCK, MAX_TARGET_PER_BLOCK] = getInput(cfg);
    [blockOrder, blockNames, indices] = setBlocks(cfg);
    
    % we have 3 repetition, and 3 possible target. So each condition in
    % each repetition takes 1 of the possible targets
    RANGE_TARGETS = 0:MAX_TARGET_PER_BLOCK;
    rangeTargetArray = RANGE_TARGETS;
    
    % if repetitionNb is more than your range of targets
    % we need to expand array of "range of targets"
    if length(RANGE_TARGETS) < NB_REPET
        %how much enlargement needed?
        if mod(NB_REPET,length(RANGE_TARGETS)) == 0
            rangeTargetArray = repmat(rangeTargetArray, 1, NB_REPET/length(RANGE_TARGETS));
        else
            % round it to smallest integer
            rangeTargetArray = repmat(rangeTargetArray, 1, round(NB_REPET/length(RANGE_TARGETS)));
            % then add "1" target at the end
            rangeTargetArray = [rangeTargetArray, 1];
        end
    end
    
    % shuffle the possible targets for each condition separately
    numTargetsForEachBlock = zeros(1, NB_BLOCKS);
    % indices contain position info; every column indicates a specific
    % condition (indices(:,1) = condition1, indices(:,2) = condition2...)
    for iCondition = 1:NB_CONDITION
        numTargetsForEachBlock(indices(:,iCondition)) = shuffle(rangeTargetArray);
    end
    
    %% Give the blocks the names with condition and design the task in each event
    
    % doVisual - do metronome visually
    % so all trials are "target" for fixation cross
    fixationTargets = zeros(NB_BLOCKS, NB_EVENTS_PER_BLOCK);
    if cfg.doVisual
        fixationTargets = ones(NB_BLOCKS, NB_EVENTS_PER_BLOCK);
    end
    
    % no audio target - no task
    soundTargets = zeros(NB_BLOCKS, NB_EVENTS_PER_BLOCK);
    %%  set jitter 
    %calculate an array of jittered IBI   
    ibi = cfg.timing.IBI;
    ibiArray = [ibi-1:ibi+1];
    
    if cfg.timing.doJitter
        allIBI = repmat(ibiArray, 1,round(NB_BLOCKS/length(ibiArray)));
        cfg.timing.IBI = allIBI;
    else
        allIBI = repmat(ibi,1,NB_BLOCKS);
        cfg.timing.IBI = allIBI;
    end
    %% Now we do the easy stuff
    
    cfg.design.blockNamesOrder = blockNames;

    cfg.design.nbBlocks = NB_BLOCKS;

    cfg.design.blockOrder = blockOrder;

    cfg.design.fixationTargets = fixationTargets;

    cfg.design.soundTargets = soundTargets;

    %% Plot
    diplayDesign(cfg, displayFigs);

end

function [blockOrder, blockNames, indices] = setBlocks(cfg)


    [~, NB_CONDITION ,NB_REPETITIONS, ~] = getInput(cfg);
    blockOrder = zeros(NB_REPETITIONS, NB_CONDITION);
    blockNames = cell(NB_REPETITIONS * NB_CONDITION,1);
    
    % pseudorandomization of blocks
    counter = 1;
    for iRep = 1:NB_REPETITIONS
        
        % vector of body parts
        blockOrderToShuffle = length(unique(cfg.design.blockNames));
        if cfg.design.extraForehead == 1
            blockOrderToShuffle = [1:length(unique(cfg.design.blockNames)), 5];
        end
        
        % Control 1. prevent consecutive same body part presentation within
        % a repetition
        blockDifference = 0;
        
        while any(abs(blockDifference) < 1)
            chosenBlockOrder = Shuffle(blockOrderToShuffle);
            blockDifference = abs(diff(chosenBlockOrder, [], 2));
        end

        blockOrder(iRep,:) = chosenBlockOrder;
        
        % Control 2 - prevent consecuitive body part across repetitions
        if (iRep > 1)
            while blockOrder(iRep,1) == blockOrder(iRep-1,end) || any(abs(blockDifference) < 1)
                chosenBlockOrder = Shuffle(blockOrderToShuffle);
                blockDifference = abs(diff(chosenBlockOrder, [], 2));
                
                blockOrder(iRep,:) = chosenBlockOrder;
            end
        end
        
        
        % now assign the block order and names
        blockNames(counter:(iRep *NB_CONDITION)) = cfg.design.blockNames(blockOrder(iRep,:));
        
        
        counter = counter + NB_CONDITION;
    end
    
    
    % now reorganise for easy saving
    blockOrder = reshape(blockOrder',1,[]);
    
    % Get the index of each condition
    % not using transpose and
    hand = find(blockOrder == 1);
    feet = find(blockOrder == 2);
    tongue = find(blockOrder == 3);
    lips = find(blockOrder == 4);
    forehead = find(blockOrder == 5);

    if cfg.design.extraForehead == 1
        forehead2 = forehead(1:2:2*NB_REPETITIONS);
        forehead = forehead(2:2:2*NB_REPETITIONS);
        indices = [hand', feet', tongue', lips', forehead', forehead2'];
    else
        indices = [hand', feet', tongue', lips', forehead'];
        
    end
    

end


function [nbBlocks, nbCondition, nbRepet, nbEventsBlock, maxTargBlock] = getInput(cfg)
    nbCondition = length(cfg.design.blockNames);
    nbRepet = cfg.design.nbRepetitions;
    nbEventsBlock = cfg.design.nbEventsPerBlock;
    maxTargBlock = cfg.target.maxNbPerBlock;
    nbBlocks = length(cfg.design.blockNames) * nbRepet;
end



function diplayDesign(cfg, displayFigs)

    %% Visualize the design matrix
    if displayFigs

        close all;

        figure(1);

        % Shows blocks (static and motion) and events (motion direction) order
        blocks = cfg.design.blockOrder;

        subplot(3, 1, 1);
        imagesc(blocks);

        labelAxesBlock();

        caxis([1 7]);
        myColorMap = lines(7);
        colormap(myColorMap);
        colorbar();

        title('Block (static and motion) & Events (motion direction)');

        % Shows the fixation targets design in each event (1 or 0)
        fixationTargets = cfg.design.fixationTargets;

        subplot(3, 1, 2);
        imagesc(fixationTargets);
        labelAxesBlock();
        title('Fixation Targets design');
        colormap(gray);

        % Shows the fixation targets position distribution in the block across
        % the experimet
        [~, itargetPosition] = find(fixationTargets == 1);

        subplot(3, 1, 3);
        hist(itargetPosition);
        labelAxesFreq();
        title('Fixation Targets position distribution');

%         figure(2);
% 
%         [motionDirections] = getDirectionBaseVectors(cfg);
%         motionDirections = unique(motionDirections);
% 
%         for iMotion = 1:length(motionDirections)
% 
%             [~, position] = find(directions == motionDirections(iMotion));
% 
%             subplot(2, 2, iMotion);
%             hist(position);
%             scaleAxes();
%             labelAxesFreq();
%             title(num2str(motionDirections(iMotion)));
% 
%         end

    end

end

function labelAxesBlock()
    % an old viking saying because they really cared about their axes
    ylabel('Block seq.', 'Fontsize', 8);
    xlabel('Events', 'Fontsize', 8);
end

function labelAxesFreq()
    % an old viking saying because they really cared about their axes
    ylabel('Number of targets', 'Fontsize', 8);
    xlabel('Events', 'Fontsize', 8);
end

% function scaleAxes()
%     xlim([1 12]);
%     ylim([0 5]);
% end
