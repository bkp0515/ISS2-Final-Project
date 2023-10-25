function reportSymbolMachine
% function reportSymbolMachine
%
% Creates a report on the quality of the forecasts fed into the Symbol
% Machine. Should be used after the whole sequence has been parsed by
% the Symbol Machine, i.e., after symbolMachine.m has been called once for
% each symbol appearing in the sequence.
%
% Inputs/outputs: none.
%
% Colorado School of Mines EENG311 - Fall 2023 - Mike Wakin

global SYMBOLDATA

fprintf('\n');
fprintf('SYMBOL MACHINE REPORT (EMAIL TO PROF WAKIN FOR LEADERBOARD)\n')
if SYMBOLDATA.nextIndex-1 < SYMBOLDATA.sequenceLength
    fprintf('ERROR: Did not complete forecasting the whole sequence.\n')
    fprintf('Processed only %d out of %d symbols in %s.\n',SYMBOLDATA.nextIndex-1,SYMBOLDATA.sequenceLength,SYMBOLDATA.filename);
else
    fprintf('Processed %d out of %d symbols in %s.\n',SYMBOLDATA.nextIndex-1,SYMBOLDATA.sequenceLength,SYMBOLDATA.filename);
    fprintf('Total penalty: %.3f bits (%.4f bits per symbol).\n',SYMBOLDATA.totalPenaltyInBits,SYMBOLDATA.totalPenaltyInBits/SYMBOLDATA.sequenceLength);
    pctileBoundaries = [0 1/256 1/128 1/64 1/32 1/16 1/8 1/4 1/2 1]*100;
    for pctileIndex = 1:length(pctileBoundaries)-1
        if pctileBoundaries(pctileIndex) == 0
            % Include probabilities that are exactly 0.
            a = sum((SYMBOLDATA.winnerProbabilities >= pctileBoundaries(pctileIndex)/100) & (SYMBOLDATA.winnerProbabilities <= pctileBoundaries(pctileIndex+1)/100));
            b = sum((SYMBOLDATA.loserProbabilities(:) >= pctileBoundaries(pctileIndex)/100) & (SYMBOLDATA.loserProbabilities(:) <= pctileBoundaries(pctileIndex+1)/100));
        else
            a = sum((SYMBOLDATA.winnerProbabilities > pctileBoundaries(pctileIndex)/100) & (SYMBOLDATA.winnerProbabilities <= pctileBoundaries(pctileIndex+1)/100));
            b = sum((SYMBOLDATA.loserProbabilities(:) > pctileBoundaries(pctileIndex)/100) & (SYMBOLDATA.loserProbabilities(:) <= pctileBoundaries(pctileIndex+1)/100));
        end
        if a+b > 0
            fprintf('%9d probabilities forecasted between %1.4f (%d bits) and %1.4f (%d bits); actual occurrence rate %1.4f.\n',a+b,pctileBoundaries(pctileIndex)/100,-log2(pctileBoundaries(pctileIndex)/100),pctileBoundaries(pctileIndex+1)/100,-log2(pctileBoundaries(pctileIndex+1)/100),a/(a+b));
        else
            fprintf('%9d probabilities forecasted between %1.4f (%d bits) and %1.4f (%d bits).\n',0,pctileBoundaries(pctileIndex)/100,-log2(pctileBoundaries(pctileIndex)/100),pctileBoundaries(pctileIndex+1)/100,-log2(pctileBoundaries(pctileIndex+1)/100));
        end
    end
    fprintf('"Most likely" prediction came true %.3f%% of the time.\n',100*SYMBOLDATA.correctPredictions/SYMBOLDATA.sequenceLength);
end
fprintf('END SYMBOL MACHINE REPORT\n\n')