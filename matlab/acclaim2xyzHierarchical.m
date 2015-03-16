function xyz = acclaim2xyzHierarchical(skel, channels, visIndex)

% ACCLAIM2XYZHIERARCHICAL Compute XYZ values given skeleton structure and channels.
% FORMAT
% DESC Converts a series of joint angles (channel data) into xyz
% coordinates for the given skeleton.
% ARG skel : The skeleton being animated.
% ARG channels : The channel data for this frame of animation.
% ARG visIndex : visIndex indicates the index of the current subskel node.
% RETURN xyz : the data structure containing the xyz value and rotation
% matrix for each joint in the skeleton.
% 
% COPYRIGHT : Andrew J. Moore and Neil D. Lawrence, 2006, 2007
%
% HGPLVM

global dependencyVisData;

%/~
% hasDependency = 0;
% isMaster = 0;
% dependencyId = 0;
% %check to see if root node has a dependency.
% for i=1:size(dependencyVisData)
%     if (strcmp(skel.tree(1).name, dependencyVisData(i).name)
%         %check to see if this is a master or a dependent.
%         if dependencyVisData(i).masterNodeIndex == visIndex
%            isMaster = 1;
%            dependencyId = i;
%         else 
%             xyzStruct(1).rot = dependencyVisData(i).rot;
%             xyzStruct(1).xyz = dependencyVisData(i).xyz;
%             hasDependency = 1;
%         end
%     end
% end
% if ~hasDependency
%~/
rotVal = skel.tree(1).orientation;
for i = 1:length(skel.tree(1).rotInd)
  rind = skel.tree(1).rotInd(i);
  if rind
    rotVal(i) = rotVal(i) + channels(rind);
  end
end
xyzStruct(1).rot = rotationMatrix(deg2rad(rotVal(1)), ...
                                   deg2rad(rotVal(2)), ...
                                   deg2rad(rotVal(3)), ...
                                   skel.tree(1).axisOrder);

xyzStruct(1).xyz = skel.tree(1).offset;
%/~
% end
%~/

for i = 1:length(skel.tree(1).posInd)
  pind = skel.tree(1).posInd(i);
  if pind
    xyzStruct(1).xyz(i) = xyzStruct(1).xyz(i) + channels(pind);
  end
end
xyzStruct(1) = checkForDependency(1, visIndex, xyzStruct(1));


for i = 1:length(skel.tree(1).children)
  ind = skel.tree(1).children(i);
  xyzStruct = getChildXyz(skel, xyzStruct, ind, channels);
end
xyz = reshape([xyzStruct(:).xyz], 3, length(skel.tree))';

  function xyzStruct = getChildXyz(skel, xyzStruct, ind, channels)

  % GETCHILDXYZ 

    parent = skel.tree(ind).parent;
    children = skel.tree(ind).children;
    rotVal = zeros(1, 3);
    for j = 1:length(skel.tree(ind).rotInd)
      rind = skel.tree(ind).rotInd(j);
      if rind
        rotVal(j) = channels(rind);
      else
        rotVal(j) = 0;
      end
    end
    tdof = rotationMatrix(deg2rad(rotVal(1)), ...
                          deg2rad(rotVal(2)), ...
                          deg2rad(rotVal(3)), ...
                          skel.tree(ind).order);
    
    torient = rotationMatrix(deg2rad(skel.tree(ind).axis(1)), ...
                             deg2rad(skel.tree(ind).axis(2)), ...
                             deg2rad(skel.tree(ind).axis(3)), ...
                             skel.tree(ind).axisOrder);
    torientInv = rotationMatrix(deg2rad(-skel.tree(ind).axis(1)), ...
                                deg2rad(-skel.tree(ind).axis(2)), ...
                                deg2rad(-skel.tree(ind).axis(3)), ...
                                skel.tree(ind).axisOrder(end:-1:1));
    xyzStruct(ind).rot = torientInv*tdof*torient*xyzStruct(parent).rot;
    xyzStruct(ind).xyz = xyzStruct(parent).xyz + (skel.tree(ind).offset*xyzStruct(ind).rot);
    
    xyzStruct(ind) = checkForDependency(ind, visIndex, xyzStruct(ind));
    
    for n = 1:length(children)
      cind = children(n);
      xyzStruct = getChildXyz(skel, xyzStruct, cind, channels);
    end
    
  end
    
  function xyzStruct = checkForDependency(ind, visIndex, xyzStruct)

  % CHECKFORDEPENDENCY
  
    %/~
    %below prob shite
    %0 = no dependency
    %1 = dependency, is dependent
    %2 = dependency, is master
    %~/
    for k=1:length(dependencyVisData)
      if (strcmp(skel.tree(ind).name, dependencyVisData(k).name))
        %check to see if this is a master or a dependent.
        if dependencyVisData(k).masterNodeIndex == visIndex
          % It is master.
          dependencyVisData(k).rot = xyzStruct.rot;
          dependencyVisData(k).xyz = xyzStruct.xyz;
        else 
          %hot fix, but question is, why might the dependency master info be
          %requested before is has been assigned?
          if ~isempty(dependencyVisData(k).rot)
            % It is a dependent
            xyzStruct.rot = dependencyVisData(k).rot;
            xyzStruct.xyz = dependencyVisData(k).xyz;
          end
        end
      end
    end
  end

end
