%% PART 3 of 4
fprintf('======= TRAINING =========\n');


clear all;
load sequence_solarWind_train.mat;
sequenceLength = length(sequence);
symbolCounts = ones(9,9,9,9);
for ii = 4:sequenceLength
    currentSymbol = sequence(ii);
    thirdSymbol = sequence(ii-1);
    secondSymbol = sequence(ii-2);
    firstSymbol = sequence(ii-3);
    symbolCounts(firstSymbol,secondSymbol,thirdSymbol,currentSymbol) = ...
        symbolCounts(firstSymbol,secondSymbol,thirdSymbol,currentSymbol) + 160;
end
probMatrix = symbolCounts;

%For making demo plot
sampleCounts = ones(9,9,9,9);
for ii = 4:sequenceLength
    currentSymbol = sequence(ii);
    thirdSymbol = sequence(ii-1);
    secondSymbol = sequence(ii-2);
    firstSymbol = sequence(ii-3);
    sampleCounts(firstSymbol,secondSymbol,thirdSymbol,currentSymbol) = ...
        sampleCounts(firstSymbol,secondSymbol,thirdSymbol,currentSymbol) + 1;
end
subplot(1, 2, 1);
stemVector = reshape(symbolCounts(1, 1, 1, :), [9 1]);
stem(stemVector);

subplot(1, 2, 2);
stemVector = reshape(sampleCounts(1, 1, 1, :), [9 1]);
stem(stemVector);
%End demo plot stuff


for i = 1:9
    for ii = 1:9
        for iii = 1:9
            probMatrix(i,ii,iii,:) = probMatrix(i,ii,iii,:)/sum(probMatrix(i,ii,iii,:));
        end
    end
end

load sequence_solarWind_train.mat;
symbolCounts = ones(1,9); 
for ii = 1:sequenceLength
    thisSymbol = sequence(ii);
    symbolCounts(thisSymbol) = symbolCounts(thisSymbol) + 1;
end
probs = symbolCounts/sum(symbolCounts);

sequenceLength = initializeSymbolMachine('sequence_solarWind_train.mat',0);
%probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
[first,penalty] = symbolMachine(probs);
[second,penalty] = symbolMachine(probs);
[symbol,penalty] = symbolMachine(probs);
for ii = 4:sequenceLength
    [symbol,penalty] = symbolMachine(probMatrix(first,second,symbol,:));
    first=second;
    second=symbol;
end
reportSymbolMachine;


%% PART 4 of 4
fprintf('======= TEST =========\n');

sequenceLength = initializeSymbolMachine('sequence_solarWind_test.mat',0);

%probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
[first,penalty] = symbolMachine(probs);
[second,penalty] = symbolMachine(probs);
[symbol,penalty] = symbolMachine(probs);
for ii = 4:sequenceLength
    
    [symbol,penalty] = symbolMachine(probMatrix(first,second,symbol,:));
    first=second;
    second=symbol; 
    
end
reportSymbolMachine;


%% PART 3 of 4
fprintf('======= TRAINING =========\n');


clear all;
load sequence_Dickens_train.mat;
sequenceLength = length(sequence);
symbolCounts = ones(9,9,9,9);
for ii = 4:sequenceLength
    currentSymbol = sequence(ii);
    thirdSymbol = sequence(ii-1);
    secondSymbol = sequence(ii-2);
    firstSymbol = sequence(ii-3);
    symbolCounts(firstSymbol,secondSymbol,thirdSymbol,currentSymbol) = ...
        symbolCounts(firstSymbol,secondSymbol,thirdSymbol,currentSymbol) + 150;
end
probMatrix = symbolCounts;
for i = 1:9
    for ii = 1:9
        for iii = 1:9
            probMatrix(i,ii,iii,:) = probMatrix(i,ii,iii,:)/sum(probMatrix(i,ii,iii,:));
        end
    end
end

load sequence_Dickens_train.mat;
symbolCounts = ones(1,9); 
for ii = 1:sequenceLength
    thisSymbol = sequence(ii);
    symbolCounts(thisSymbol) = symbolCounts(thisSymbol) + 1;
end
probs = symbolCounts/sum(symbolCounts);

sequenceLength = initializeSymbolMachine('sequence_Dickens_train.mat',0);
%probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
[first,penalty] = symbolMachine(probs);
[second,penalty] = symbolMachine(probs);
[symbol,penalty] = symbolMachine(probs);
for ii= 4:sequenceLength
    [symbol,penalty] = symbolMachine(probMatrix(first,second,symbol,:));
    first=second;
    second=symbol;
end
reportSymbolMachine;


%% PART 4 of 4
fprintf('======= TEST =========\n');

sequenceLength = initializeSymbolMachine('sequence_Dickens_test.mat',0);

%probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
[first,penalty] = symbolMachine(probs);
[second,penalty] = symbolMachine(probs);
[symbol,penalty] = symbolMachine(probs);
for ii = 4:sequenceLength
    
    [symbol,penalty] = symbolMachine(probMatrix(first,second,symbol,:));
    first=second;
    second=symbol; 
    
end
reportSymbolMachine;