function [regTheta1 regTheta2]=bright_reg_RegTraingModel2()
%CHARACTERSEGMENTATION character segmentation
% input_layer_size,hidden_layer_size,num_labels,dirr, lambda
%dirr='D:\home\dividedManulForReg\' %D:\home\dividedManulForReg
input_layer_size=2030;
hidden_layer_size=500; 
num_labels=37; 

load('bright_reg_Xreg.mat');
load('bright_reg_XregCV.mat');
load('bright_reg_XregTest.mat');
load('bright_reg_yreg.mat');
load('bright_reg_yregCV.mat');
load('bright_reg_yregTest.mat');
%[Xreg yreg XregCV yregCV XregTest yregTest]=bright_reg_getXregyregForReg();
X=Xreg;
y=yreg;
size1=size(X,1);
size2=size(X,2);

%% =================== Part 1: Training NN ===================
%  To train your neural network, we will now use "fmincg", which
%  is a function which works similarly to "fminunc". Recall that these
%  advanced optimizers are able to train our cost functions efficiently as
%  long as we provide them with the gradient computations.
%
fprintf('\nTraining Neural Network for character Regcition ... \n')

%  After you have completed the assignment, change the MaxIter to a larger
%  value to see how more training helps.
options = optimset('MaxIter',2000);   

%  You should also try different values of lambda
%lambdas=[0,0.01,0.03,0.1,0.3,1,3,6,9,30,60,100];
lambdas=[3];

minCost=10000;
bestLambda=10000;
for i=1:length(lambdas);
 % Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambdas(i));

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)

fprintf('\nInitializing Neural Network Parameters ...\n')
initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];

[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);
 [J grad] = nnCostFunction(nn_params, input_layer_size, hidden_layer_size,  num_labels, XregCV, yregCV, 0);             
if J<minCost
  bestLambda =lambdas(i)
  minCost=J
  bestNn_params=nn_params;
end;
end;
nn_params=bestNn_params;
% Obtain Theta1 and Theta2 back from nn_params
regTheta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

regTheta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));
save('bright_reg_bestLambda.mat','bestLambda');
save('bright_reg_bestMinCost.mat','minCost');
save('bright_reg_regTheta1.mat','regTheta1');
save('bright_reg_regTheta2.mat','regTheta2');
fprintf('Program paused. Press enter to continue.\n');
pause;
bright_reg_predictOnTraingCVTesting(regTheta1,regTheta2,Xreg,yreg,XregCV,yregCV,XregTest,yregTest)
size(Xreg)
size(yreg)