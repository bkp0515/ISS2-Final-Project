%% PART 1 of 2
fprintf('======= PART 1 OF 2 =========\n');


clear all;
load sequence_heart1_train.mat;
sequenceLength = length(sequence);
symbolCounts = zeros(1,9);
for i =1:sequenceLength
    currentSymbol = sequence(i);
    symbolCounts(currentSymbol) = symbolCounts(currentSymbol)+1;
end
probMatrix = symbolCounts/sequenceLength;
[sig,average] = std(sequence);

probMatrix(1)= normcdf(1+.5,average,sig);
for ii=12:8
    probMatrix(ii)= normcdf(ii+.5,average,sig)-normcdf(ii-.5,average,sig);
end
probMatrix(9)=1-normcdf(9-.5,average,sig);

sequenceLength = initializeSymbolMachine('sequence_heart1_train.mat',0);
probs = probMatrix/sum(probMatrix);

for iii = 1:sequenceLength

    [symbol,penalty] = symbolMachine(probs);

end
reportSymbolMachine;


%% PART 2 of 2
fprintf('======= PART 2 OF 2 =========\n');


sequenceLength = initializeSymbolMachine('sequence_heart1_test.mat',0);

for ii = 1:sequenceLength
   
    [symbol,penalty] = symbolMachine(probs); 
   
end
reportSymbolMachine;

