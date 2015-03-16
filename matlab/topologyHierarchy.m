function [tree, visualiseNodes, dependencyVisData] = topologyHierarchy(Y)

% TOPOLOGYHIERARCHY Return an hierarchy for learning a topology.
% DESC Returns a simple hierarchy for top down topological
% constraints on the GP-LVM.
% ARG Y : the data set which is being modelled.
% RETURN tree : the tree structure for the hierarchy split.
% RETURN visualiseNodes : the data structure needed for
% visualisation.
% RETURN dependencyVisData : 
% 
% COPYRIGHT : Neil D. Lawrence, 2007
%
% SEEALSO : acclaimSplitHierarchy

% HGPLVM 


visualiseNodes(2).name = 'topology';
tree(2).children = [1];
tree(2).parent = [];
visualiseNodes(2).model = [];
tree(2).featureInd = [];

visualiseNodes(1).name = 'Euclidean Space';
tree(1).children = [];
tree(1).parent = [];
visualiseNodes(1).model = [];
tree(1).featureInd = 1:size(Y, 2);

% Add in the parents
tree = treeFindParents(tree);

