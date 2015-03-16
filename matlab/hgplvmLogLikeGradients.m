function g = hgplvmLogLikeGradients(model)

% HGPLVMLOGLIKEGRADIENTS Compute the gradients for the HGPLVM.
% FORMAT
% DESC returns the gradients of the log likelihood with respect to the
% parameters of the hierarchical GP-LVM model and with respect to the latent
% positions of the GP-LVM models. 
% ARG model : the HGPLVM structure containing the parameters and
% the latent positions.
% RETURN g : the gradients of the latent positions and the
% parameters of the GP-LVM models.
%
% COPYRIGHT : Neil D. Lawrence, 2007
%
% SEEALSO : hgplvmLogLikelihood, hgplvmCreate, modelLogLikeGradients

% HGPLVM

g = zeros(1, model.numParams);
endVal = 0;
gParentX = hgplvmLatentGradients(model);
for i = 1:length(model.node)
  q = model.node(i).q;
  N = model.node(i).N;
  if ~isempty(model.tree(i).dataInd)
    dataInd = model.tree(i).dataInd;
  else
    dataInd = [];
  end
  subModel = model.node(i);
  if isfield(subModel, 'back')
    % Temporarily remove back constraints.
    subModel = rmfield(subModel, 'back');
  end
  endValX = endVal + N*q;
  startVal = endVal + 1;
  endVal = endVal + subModel.numParams;
  [gX, gParam] = fgplvmLogLikeGradients(subModel);
  gX = gX + gParentX{i};
  % Check for back constraints.
  gX_or_back = fgplvmBackConstraintGrad(model.node(i), gX);
  g(startVal:endVal) = [gX_or_back(:)' gParam];
end


