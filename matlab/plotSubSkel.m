function visHandle = plotSubSkel(visIndex, model, subSkel, padding, ...
                                 axesHandle)

% PLOTSUBSKEL Plot a given sub-skeleton.
% FORMAT 
% DESC plots a sub skeleton on for the given visualisation.
% ARG visIndex : the index of the visualisation structure into which the
% plot will be made.
% ARG model : the model containing the learned information about
% the skeleton to be plotted.
% ARG subSkel : the sub-skeleton structure to be plotted.
% ARG padding : any padding to be added to the skeleton.
%
% COPYRIGHT Andrew J. Moore, 2006
%
%

% HGPLVM
global visualiseInfo;
if nargin < 5
  figure(2)
else
  axes(axesHandle)
end

visData = zeros(1, model.d);
%set visData to frame with max sum of squares of joint angles
[void, maxInd] = min(sum((model.y.*model.y), 2));
visData = model.y(maxInd, :);

visHandle = visualiseInfo(visIndex).visualiseFunction(visData, subSkel, visIndex, padding);

set(axesHandle, 'UserData', 0);
set(visHandle, 'eraseMode', 'xor');
colormap gray;




