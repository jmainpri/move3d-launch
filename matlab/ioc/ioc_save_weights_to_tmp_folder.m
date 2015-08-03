function ioc_save_weights_to_tmp_folder()

% Set move3d and matlab working directories
move3d_dir = '/jim_local/Dropbox/move3d/move3d-launch/';
matlab_dir = [move3d_dir 'matlab/'];
move3d_data_dir = 'move3d_tmp_data_human_trajs/';

loo_splits = [];
loo_splits = [loo_splits ; '[0444-0585]'];
loo_splits = [loo_splits ; '[0446-0578]'];
loo_splits = [loo_splits ; '[0489-0589]'];
loo_splits = [loo_splits ; '[0525-0657]'];
loo_splits = [loo_splits ; '[0780-0871]'];
loo_splits = [loo_splits ; '[1537-1608]'];
loo_splits = [loo_splits ; '[2711-2823]'];

with_replan = 'replan';

folder = [matlab_dir move3d_data_dir];

for i=1:size(loo_splits),

    weights = load(['results_current/tmp_results_' with_replan '/weig_human_motion_' with_replan '_' loo_splits(i,:) '.mat']);
    w = weights.recovered_weights;
    csvwrite( [folder 'tmp_weights/' loo_splits(i,:) '_spheres_weights_700.txt'], squeeze(w)');

end