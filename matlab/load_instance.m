function [phi_demo, phi_k] = load_instance( nb_demo, nb_samples, nb_features )

formatSpec = '%03d';

filename = ['data/spheres_features_', num2str(nb_samples,formatSpec), '.txt'];
% display(filename)

% load file according to the number of samples
m = load(filename);

% gets the features of the demos (at the beginning of the file)
phi_demo = m(1:nb_demo,:);

% gets the features of the random samples
phi_k = zeros( nb_samples, nb_features, nb_demo );

for d=1:nb_demo,
    phi_k(:,:,d) = m(((d-1)*nb_samples+(nb_demo+1)):(d*nb_samples+nb_demo),:);
end