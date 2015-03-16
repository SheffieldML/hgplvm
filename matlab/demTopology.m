% DEMWALKRUN1 Demonstration of hierarchical GP-LVM on walking and running data.

% HGPLVM

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';
experimentNo = 6;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Define the hierarchy.
latentDim = 2;
[tree, visualiseNodes] = topologyHierarchy(Y);


for i = 1:length(tree)
  for j = 1:length(tree(i).children)
    tree(i).childLatentInd{j} = 1:latentDim;
  end
end
tree(1).fgplvmOptions = fgplvmOptions('ftc');
tree(1).fgplvmOptions.back = 'mlp';
tree(1).fgplvmOptions.backOptions = mlpOptions(10);
tree(1).dataInd = [];
tree(1).q = 3;

tree(2).fgplvmOptions = fgplvmOptions('ftc');
%tree(2).fgplvmOptions.back = 'mlp';
tree(2).fgplvmOptions.backOptions = mlpOptions(10);

tree(2).q = 2;
options = hgplvmOptions(latentDim, tree);

%options.optimiser = 'conjgrad';
d = size(Y, 2);

options.tree(2).childLatentInd{1} = [1:3];
model = hgplvmCreate(latentDim, d, Y, options);

origNparams = model.node(2).kern.nParams;
periodicKern = kernCreate(1, 'rbfperiodic');
styleKern = kernCreate(1, 'lin');
model.node(2).kern = kernCreate(2, {'cmpnd', {'tensor', periodicKern, styleKern}, 'whitefixed'});
model.node(2).kern.comp{1}.comp{1}.index=1; % rbfperiodic uses first
                                            % dimension input.
model.node(2).kern.comp{1}.comp{2}.index=2; % rbf uses second dimension input.
model.node(2).kern.comp{2}.variance = 1e-6;
model.node(2).numParams = model.node(2).numParams - origNparams ...
    + model.node(2).kern.nParams;
model.numParams = 0;
for i = 1:length(model.node)
  model.numParams = model.numParams + model.node(i).numParams;
end

% Normalise leaf nodes
leafInd = treeFindLeaves(model.tree);
for i = leafInd
  model.node(i).scale = sqrt(var(model.node(i).y));
  % DOn't rescale things that don't vary.
  ind = find(abs(model.node(i).scale)<1e-4);
  model.node(i).scale(ind) = 1;
  model.node(i).m = gpComputeM(model.node(i));
end

% % Add dynamics to root nodes.
% rootInd = treeFindRoots(model.tree);
% optionsDyn = gpOptions('ftc');
% for i = rootInd;
%   t = linspace(0, 2*pi, size(model.node(i).X, 1)+1)';  
%   t = t(1:end-1, 1);
%   kern = kernCreate(t, {'rbfperiodic', 'white'});
%   kern.comp{2}.variance = 1e-5;
%   kern.whiteVariance = kern.comp{2}.variance;
%   kern.comp{1}.inverseWidth = 1;
%   kern.comp{1}.variance = 1;
%   optionsDyn.kern = kern;
%   model.node(i) = fgplvmAddDynamics(model.node(i), 'gpTime', optionsDyn, t, 0, 0);
% end
  
% Optimise the model.
iters = 1000;
display = 1;
model.node(2).X = randn(55, 2)*0.01;
model = hgplvmOptimise(model, display, iters);

% Save the results.
capName = dataSetName;;
capName(1) = upper(capName(1));
save(['dem' capName num2str(experimentNo) '.mat'], 'model', ...
     'visualiseNodes');
close all
colordef white
%hgplvmHierarchicalVisualise(model, visualiseNodes, depVisData);

