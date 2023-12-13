%% PART 3 of 4
fprintf('======= TRAINING =========\n');


clear all;
load sequence_DIAwind_train.mat;
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


load sequence_DIAwind_train.mat;
for ii = 1:sequenceLength
    thisSymbol = sequence(ii);
    symbolCounts(thisSymbol) = symbolCounts(thisSymbol) + 1;
end
probs = symbolCounts/sum(symbolCounts);

sequenceLength = initializeSymbolMachine('sequence_DIAwind_train.mat',0);

image(symbolCounts)
colorbar

%probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
[symbol,penalty] = symbolMachine(probs);
for ii = 2:sequenceLength
    
    [symbol,penalty] = symbolMachine(probMatrix(symbol,:));
end
reportSymbolMachine;
%% PART 4 of 4
fprintf('======= TEST =========\n');


sequenceLength = initializeSymbolMachine('sequence_DIAwind_test.mat',0);

[symbol,penalty] = symbolMachine(probs);
for ii = 2:sequenceLength
    
    [symbol,penalty] = symbolMachine(probMatrix(symbol,:)); 
    
end
reportSymbolMachine;
