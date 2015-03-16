function f = hgplvmObjective(params, model)

% HGPLVMOBJECTIVE Wrapper function for hierarchical GP-LVM objective.
% FORMAT
% DESC provides a wrapper function for the hierarchical GP-LVM, it
% takes the negative of the log likelihood, feeding the parameters
% correctly to the model.
% ARG params : the parameters of the GP-LVM model.
% ARG model : the model structure in which the parameters are to be
% placed.
% RETURN f : the negative of the log likelihood of the model.
% 
% SEEALSO : hgplvmCreate, hgplvmLogLikelihood, hgplvmExpandParam
%
% COPYRIGHT : Neil D. Lawrence, 2007

% HGPLVM

model = hgplvmExpandParam(model, params);
f = - hgplvmLogLikelihood(model);
