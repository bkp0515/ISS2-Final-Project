clear all;
load sequence_DIAtemp_train.mat;
data = sequence';

% Load or Generate Sample Data

data = normalize(data); % Normalize data

% Prepare Sequences
numTimeStepsTrain = floor(0.9*numel(data));
dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);

% Create Sequences for Training
XTrain = dataTrain(1:end-1);
YTrain = dataTrain(2:end);


% Convert Y to categorical (assuming Y contains integers from 1 to 9)
Y = categorical(YTrain);

% Define LSTM architecture for classification
numHiddenUnits = 100;  % number of hidden units in LSTM layer
numClasses = 9;  % number of classes (1 to 9)

layers = [ ...
    sequenceInputLayer(1)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

% Specify training options
options = trainingOptions('adam', ...
    'MaxEpochs',100, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

% Train the network
net = trainNetwork(XTrain, Y, layers, options);

%% 
net.resetState;
sequenceLength = initializeSymbolMachine('sequence_DIAtemp_train.mat',0);
probs = [1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9 1/9];
[symbol,penalty] = symbolMachine(probs);
for ii = 2:sequenceLength
    [net, probs] = predictAndUpdateState(net, symbol);
    [symbol,penalty] = symbolMachine(probs);
end
reportSymbolMachine;


