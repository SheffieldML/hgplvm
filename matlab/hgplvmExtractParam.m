function params = hgplvmExtractParam(model)

% HGPLVMEXTRACTPARAM Extract a parameter vector from an HGPLVM model.
% FORMAT
% DESC extracts a parameter vector from a given hierarchical GP-LVM structure.
% ARG model : the model from which parameters are to be extracted.
% RETURN params : the parameter vector extracted from the model.
%
% COPYRIGHT : Neil D. Lawrence, 2007
%
% SEEALSO : hgplvmCreate, hgplvmExpandParam, modelExtractParam

% HGPLVM

params = zeros(1, model.numParams);
endVal = 0;
for i = 1:length(model.node)
  startVal = endVal + 1;
  endVal = endVal + model.node(i).numParams;
  params(startVal:endVal) = fgplvmExtractParam(model.node(i));
end
