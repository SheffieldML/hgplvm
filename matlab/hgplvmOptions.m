function options = hgplvmOptions(latentDim, featureIndGroups, nodeStructure)

% HGPLVMOPTIONS Returns an options structure for HGPLVM.
% FORMAT
% DESC returns an options structure for the hierarchical GP-LVM.
% ARG latentDim : the latent dimensionality for the HGPLVM.
% ARG featureIndexGroups : cell array where each cell element
% is associated with a leaf node. The element contains the indices
% of the data that are associated with that leaf.
% ARG nodeStructure : cell array where each cell element is
% associated with a non-leaf node. The element contains the indices
% that are children of that node. Numbering of nodes starts with
% leaf nodes (from 1 to number of leaf nodes) and continues with
% parent nodes (from number of leaf nodes + 1 to total number of
% nodes).
% RETURN options : structure containing HGPLVM options.
%
% DESC returns an options structure for the hierarchical GP-LVM
% given a tree as an input..
% ARG latentDim : the latent dimensionality for the HGPLVM.
% ARG tree : tree structure specifying the HGPLVM.
% RETURN options : structure containing HGPLVM options.
%
% SEEALSO : hgplvmCreate, modelOptions
%
% COPYRIGHT : Neil D. Lawrence, 2007

% HGPLVM

if iscell(featureIndGroups)
  numLeaves = length(featureIndGroups);
  numParents = length(nodeStructure);
  numNodes = numLeaves + numParents;
  for i = 1:numLeaves
    options.tree(i).parent = [];
    options.tree(i).children = [];
    options.tree(i).featureInd = featureIndGroups{i};
  end
  for i = 1:numParents
    options.tree(i+numLeaves).parent = [];
    options.tree(i+numLeaves).featureInd = [];
    options.tree(i+numLeaves).children = nodeStructure{i};
    for j = 1:length(nodeStructure{i})
      options.tree(i+numLeaves).childLatentInd{j} = 1:latentDim;
    end
  end
  options.tree = treeFindParents(options.tree);
  for i = 1:length(options.tree) 
    options.tree(i).fgplvmOptions = fgplvmOptions('ftc');
  end
else
  options.tree = featureIndGroups;
end

% switch optimiser to the OPTIMI specified default.
options.optimiser = optimiDefaultOptimiser;


