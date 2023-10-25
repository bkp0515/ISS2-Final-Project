%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SYMBOL MACHINE DEMONSTRATION #1
%%% Exploring basic functionality of the Symbol Machine
%%% Colorado School of Mines EENG311 - Fall 2023 - Mike Wakin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PART 1 of 4
fprintf('======= PART 1 OF 4 =========\n');

% Initialize Symbol Machine with one of the provided sequences
sequenceLength = initializeSymbolMachine('sequence_demo.mat',1);
% To turn off the "verbose" output... change this 1 to 0 ----^  

% Stepping through the sequence one symbol at a time, your job is to 
% provide the Symbol Machine with a probabilistic forecast (a pmf) for the
% next symbol in the sequence. For each symbol you will incur a penalty 
% equal to -log2(the probability you forecasted for that symbol).
 
% Since there are 9 possible symbols (the digits 1 through 9), your pmf 
% should have 9 entries that sum to 1. One possible (but very simple) pmf 
% that you could provide the Symbol Machine would be to always forecast 
% with the uniform pmf. Here is what that would look like.
probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
for ii = 1:sequenceLength
    [symbol,penalty] = symbolMachine(probs);
end

% After you have forecasted all of the entries in the sequence, the
% following function gives you a report of how good your predictions were.
reportSymbolMachine;

%% PART 2 of 4
fprintf('======= PART 2 OF 4 =========\n');

% What happens if we use a different pmf for forecasting? We might incur a
% lower penalty on some symbols, but a higher penalty on some other
% symbols. On average, we might do better, but in this case we do worse.
sequenceLength = initializeSymbolMachine('sequence_demo.mat',1);
probs = [0.92 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01];
for ii = 1:sequenceLength
    [symbol,penalty] = symbolMachine(probs);
end
reportSymbolMachine;

%% PART 3 of 4
fprintf('======= PART 3 OF 4 =========\n');

% Let's try this on a much longer sequence (with 10000 total symbols rather
% than 100). We'll turn off the verbose output. Let's go back to using a
% uniform pmf for the forecasts.
sequenceLength = initializeSymbolMachine('sequence_nonuniform_train.mat',0);
probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
for ii = 1:sequenceLength
    [symbol,penalty] = symbolMachine(probs);
end
reportSymbolMachine;

%% PART 4 of 4
fprintf('======= PART 4 OF 4 =========\n');

% As it turns out, the symbols in this particular sequence do not actually
% have a uniform pmf. But they *are* generated independently from a
% nonuniform pmf. Supposing we don't know in advance what the true pmf
% is, we can try to learn it along the way. In the following code, we start
% with a uniform pmf, but as we go, we reshape the pmf according to the
% symbols that we actually saw (up until now) in the sequence. Note that we
% incur a lower total penalty than when we used the uniform pmf.
sequenceLength = initializeSymbolMachine('sequence_nonuniform_train.mat',0);
symbolCounts = ones(1,9); 
for ii = 1:sequenceLength
    probs = symbolCounts/sum(symbolCounts);
    [thisSymbol,penalty] = symbolMachine(probs);
    symbolCounts(thisSymbol) = symbolCounts(thisSymbol) + 1;
end
reportSymbolMachine;
