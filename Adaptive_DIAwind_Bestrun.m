%% Train the base model
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
%% Test the base model
fprintf('======= TEST =========\n');


sequenceLength = initializeSymbolMachine('sequence_DIAtemp_test.mat',0);
probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
[symbol,penalty] = symbolMachine(probs);
for ii = 2:sequenceLength
    [symbol,penalty] = symbolMachine((symbolCounts(symbol,:)/sum(symbolCounts(symbol, :)))); 
    
end
reportSymbolMachine;

%% Test the adaptive model
sequenceLength = initializeSymbolMachine('sequence_DIAtemp_test.mat',0);
[symbol,penalty] = symbolMachine(probs);
for ii = 2:sequenceLength
    oldSymbol = symbol; % Save the previous symbol
    [symbol,penalty] = symbolMachine((symbolCounts(symbol,:)/sum(symbolCounts(symbol, :)))); % Pass the current proabability into the symbol machine
    symbolCounts(oldSymbol, symbol) = symbolCounts(oldSymbol, symbol) + 1.8; % "Adapt" markov chain

end
reportSymbolMachine;