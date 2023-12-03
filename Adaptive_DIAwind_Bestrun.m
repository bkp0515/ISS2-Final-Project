%% PART 3 of 4
fprintf('======= TRAINING =========\n');


clear all;
load sequence_DIAtemp_train.mat;
sequenceLength = length(sequence);
symbolCounts = ones(9,9);
for ii = 2:sequenceLength
    currentSymbol = sequence(ii);
    precedingSymbol = sequence(ii-1);
    symbolCounts(precedingSymbol,currentSymbol) = ...
        symbolCounts(precedingSymbol,currentSymbol) + 1.6;
end
probMatrix = symbolCounts;
for ii = 1:9
    probMatrix(ii,:) = probMatrix(ii,:)/sum(probMatrix(ii,:));
end



%% PART 4 of 4
fprintf('======= TEST =========\n');


sequenceLength = initializeSymbolMachine('sequence_DIAtemp_test.mat',0);
probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
[symbol,penalty] = symbolMachine(probs);
for ii = 2:sequenceLength
    oldSymbol = symbol;
    [symbol,penalty] = symbolMachine(probMatrix(symbol,:)); 
    probMatrix(oldSymbol, symbol) = probMatrix(oldSymbol, symbol) + probMatrix(oldSymbol, symbol)*penalty/3000;
    probMatrix(oldSymbol, :) = probMatrix(oldSymbol, :)/(sum(probMatrix(oldSymbol, :)));
    
end
reportSymbolMachine;

%%
load sequence_DIAwind_train.mat;
for ii = 1:sequenceLength
    thisSymbol = sequence(ii);
    symbolCounts(thisSymbol) = symbolCounts(thisSymbol) + 1;
end
probs = symbolCounts/sum(symbolCounts);
for jj = 1:100
    sequenceLength = initializeSymbolMachine('sequence_DIAwind_train.mat',0);
    %probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
    [symbol,penalty] = symbolMachine(probs);
    totPenalty = 0;
    for ii = 2:floor(sequenceLength*0.9)
        oldSymbol = symbol;
        [symbol,penalty] = symbolMachine(probMatrix(symbol,:));
        %probMatrix(oldSymbol, symbol) = probMatrix(oldSymbol, symbol) + probMatrix(oldSymbol, symbol)*penalty/jj;
        %probMatrix(oldSymbol, :) = probMatrix(oldSymbol, :)/(sum(probMatrix(oldSymbol, :)));
        %totPenalty = totPenalty + penalty;
    end
    for ii = floor(sequenceLength*0.9):sequenceLength-1
        oldSymbol = symbol;
        [symbol,penalty] = symbolMachine(probMatrix(symbol,:));
        probMatrix(oldSymbol, symbol) = probMatrix(oldSymbol, symbol) + probMatrix(oldSymbol, symbol)*penalty/jj;
        probMatrix(oldSymbol, :) = probMatrix(oldSymbol, :)/(sum(probMatrix(oldSymbol, :)));
        totPenalty = totPenalty + penalty;
    end
    avgPenalty(jj) = totPenalty/(sequenceLength-floor(sequenceLength*0.9));
    %reportSymbolMachine;
end
plot(avgPenalty)