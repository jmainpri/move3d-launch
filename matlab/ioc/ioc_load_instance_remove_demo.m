function [phi_demo, phi_k] = ioc_load_instance_remove_demo( ...
    nb_samples, nb_features, data_folder, demo_id, nb_demos )

formatSpec = '%03d';

filename_data = [data_folder 'spheres_features_', ...
    num2str(nb_samples,formatSpec), '.txt'];
filename_ids = [data_folder 'spheres_features_demo_ids_', ...
    num2str(nb_samples,formatSpec), '.txt'];

display(data_folder)
display(filename_data)

% DEMO_ID SHOULD START AT 0 
% IF demo_od is -1 will work accounting for nb_demos
% as the parameter to specify how to use the matrix
% The function does not require the demo_id
% to start at 0, this depends on the Move3D implementation

% load file according to the number of samples
m = load(filename_data);

% load id files
ids = load(filename_ids);
% Set the index of all demo superior to nb_demos
% to -1 to deactivate them
ids( (1:size(ids)) > nb_demos ) = -1;
    
% gets the features of the demos (at the beginning of the file)
% remove the demos corresponding to demo_id
phi_demo = m( ids~=demo_id & ids>=0, :);

% gets the features of the random samples
phi_k = zeros( nb_samples, nb_features, size(phi_demo, 1) );

% gets the number of demos
% this is the total number of demos in the matrix
nb_demo = size(ids, 1);

index = 1;
for d=1:size(ids),
    % only adds the rows that do not belong to that demo id
    if ( ids(d) ~= demo_id ) && ids(d) >= 0, 
        phi_k(:,:,index) = ... 
            m(((d-1)*nb_samples+(nb_demo+1)):(d*nb_samples+nb_demo),:);
        index = index + 1;
    end
end