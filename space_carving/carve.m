function [voxels] = carve( voxels, frame)
% CARVE: carves away voxels that are not inside the silhouette contained in 
%   the view of the camera frame. The resulting voxel array is returned.
% Arguments:
%    voxels - an Nx3 matrix where each row is the location of a cubic voxel
%    frame - The frame we are using to carve the voxels with. Useful data
%       stored in here are the "silhouette" matrix and the
%       projection matrix "P". 
% Returns:
%    voxels - a subset of the argument passed that are inside the
%       silhouette
N = size(voxels, 1);

voxelsi = ones(N,1);
X = frame.P * horzcat(voxels, ones(N,1))';
for i = 1:N
    x = round([X(2,i); X(1,i)]/X(3,i));
    
    % Don't cut out voxels that project outside of the frame
    if x(1) < 1 || x(1) > size(frame.silhouette, 1) || x(2) < 1 || x(2) > size(frame.silhouette, 2)
        voxelsi(i,:) = 0;
        continue
    end
    
    if frame.silhouette(x(1), x(2)) == 0
        voxelsi(i) = 0;
    end
end
voxels = voxels(voxelsi == 1,:);

end
