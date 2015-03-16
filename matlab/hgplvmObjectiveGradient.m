function [f, g] = hgplvmObjectiveGradient(params, model)

% HGPLVMOBJECTIVEGRADIENT Wrapper function for HGPLVM objective and gradient.
% FORMAT
% DESC returns the negative log likelihood of a Gaussian process
% model given the model structure and a vector of parameters. This
% allows the use of NETLAB minimisation functions to find the model
% parameters.
% ARG params : the parameters of the model for which the objective
% will be evaluated.
% ARG model : the model structure for which the objective will be
% evaluated.
% RETURN f : the negative log likelihood of the HGPLVM model.
% RETURN g : the gradient of the negative log likelihood of the HGPLVM
% model with respect to the parameters.
%
% SEEALSO : minimize, hgplvmCreate, hgplvmGradient, hgplvmLogLikelihood, hgplvmOptimise
% 
% COPYRIGHT : Neil D. Lawrence, 2007

% HGPLVM

% Check how the optimiser has given the parameters
if size(params, 1) > size(params, 2)
  % As a column vector ... transpose everything.
  transpose = true;
  model = hgplvmExpandParam(model, params');
else
  transpose = false;
  model = hgplvmExpandParam(model, params);
end

f = - hgplvmLogLikelihood(model);
if nargout > 1
  g = - hgplvmLogLikeGradients(model);
end
if transpose
  g = g';
end