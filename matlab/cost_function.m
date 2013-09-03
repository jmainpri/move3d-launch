function loss = cost_function(w)

global phi_demo
global phi_k

d_size = size(phi_demo);
k_size = size(phi_k);

% double denominator = 1e-9;
% for (size_t k=0; k<phi_k_.size();k++)
%   denominator += std::exp(-1.0*w.transpose()*phi_k_[d][k]);
% loss += std::log( std::exp(-1.0*w.transpose()*phi_demo_[d]) / denominator );

loss = 0;

% Iterate over all max length
for d=1:d_size(1),
    denonimnator=0;
    for k=1:k_size(3),
        denonimnator = denonimnator + exp(-1.0*w*phi_k(k,:,d)');
    end
    loss = loss - log( exp(-1.0*w*phi_demo(d,:)') / denonimnator );
end
