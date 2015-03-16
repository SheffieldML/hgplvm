function model = hgplvmCreate(q, d, Y, options)

% HGPLVMCREATE Creates an HGPLVM model.
% FORMAT
% DESC creates a hierarchical GP-LVM model given a data set and an
% options structure. The options structure contains the details of
% the hierarchy (see hgplvmOptions).
% ARG q : dimensionality of latent space.
% ARG d : dimensionality of data space.
% ARG Y : the data to be modelled in design matrix format (as many
% rows as there are data points).
% ARG options : options structure as returned from
% FGPLVMOPTIONS. This structure determines the type of
% approximations to be used (if any).
% RETURN model : the GP-LVM model.
%
% COPYRIGHT : Neil D. Lawrence, 2007
%
% SEEALSO : modelCreate, hgplvmOptions

% HGPLVM


model.type = 'hgplvm';
model.optimiser = options.optimiser;
for i = 1:length(options.tree)
  if ~isfield(options.tree(i), 'q') | isempty(options.tree(i).q)
    qNode = q;
  else
    qNode = options.tree(i).q;
  end
  if ~isempty(options.tree(i).dataInd)
    dataInd = options.tree(i).dataInd;
  else
    dataInd = 1:size(Y, 1);
  end
  YNode = Y(dataInd, options.tree(i).featureInd);
  for j = 1:length(options.tree(i).children)
    child = options.tree(i).children(j);
    childInd = options.tree(i).childLatentInd{j};
    YNode = [YNode model.node(child).X(dataInd, childInd)];
  end
  dNode = size(YNode, 2);
  optionsNode = options.tree(i).fgplvmOptions;
  model.node(i) = fgplvmCreate(qNode, dNode, YNode, optionsNode);
  % Remove prior, because hierarchy provides it.
  model.node(i).prior = [];
  model.node(i).dynamics = [];
  model.tree(i) = rmfield(options.tree(i), 'fgplvmOptions');
end
model.numParams = 0;
for i = 1:length(model.node)
  model.numParams = model.numParams + model.node(i).numParams;
end