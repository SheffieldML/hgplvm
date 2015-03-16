function g = hgplvmGradient(params, model)

% HGPLVMGRADIENT Hierarchical GP-LVM gradient wrapper.
% FORMAT
% DESC is a wrapper function for the gradient of the negative log
% likelihood of a hierarchical GP-LVM model with respect to the latent postions
% and parameters.
% ARG params : vector of parameters and latent postions where the
% gradient is to be evaluated.
% ARG model : the model structure into which the latent positions
% and the parameters will be placed.
% RETURN g : the gradient of the negative log likelihood with
% respect to the latent positions and the parameters at the given
% point.
% 
% SEEALSO : hgplvmLogLikeGradients, hgplvmExpandParam
%
% COPYRIGHT : Neil D. Lawrence, 2007

% HGPLVM

model = hgplvmExpandParam(model, params);
g = - hgplvmLogLikeGradients(model);
