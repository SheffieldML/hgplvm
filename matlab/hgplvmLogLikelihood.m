function ll = hgplvmLogLikelihood(model)

% HGPLVMLOGLIKELIHOOD Log-likelihood for an HGPLVM.
% FORMAT
% DESC returns the log likelihood for a given hierarchical GP-LVM model.
% ARG model : the model for which the log likelihood is to be
% computed. The model contains the data for which the likelihood is
% being computed in the 'y' component of the structure.
% RETURN ll : the log likelihood of the data given the model.
%
% COPYRIGHT : Neil D. Lawrence, 2007
%
% SEEALSO : fgplvmLogLikelihood, hgplvmCreate

% HGPLVM
ll = 0;
for i = 1:length(model.node)
  ll = ll + fgplvmLogLikelihood(model.node(i));
end
