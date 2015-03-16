function y = hgplvmOut(model, x, parentNode)

% HGPLVMOUT Give the output of the HGPLVM model.
% FORMAT
% DESC evaluates the output of a given Gaussian process model.
% ARG model : the model for which the output is being evaluated.
% ARG x : the input position for which the output is required.
% RETURN y : the output of the HGPLVM model. The function checks if
% there is a noise model associated with the HGPLVM, if there is, it is
% used, otherwise the mean of hgplvmPosteriorMeanVar is returned.
%
% SEEALSO : hgplvmCreate
%
% COPYRIGHT : Neil D. Lawrence, 2007

% HGPLVM

