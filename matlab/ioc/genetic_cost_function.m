function loss = genetic_cost_function(w)

global phi_demo
global phi_k
global nb_used_samples

d_size = size(phi_demo);
w_size = size(w);
if w_size(2) < w_size(1),
    w = w';
end

alpha = 10;
beta = 100;
gamma = 10;
loss = 0;

for d=1:d_size(1),
    
    cost_demo = w*phi_demo(d,:)';
    
    for k=1:nb_used_samples,
        
        cost_sample = w*phi_k(k,:,d)';
        
        delta = abs( cost_sample - cost_demo );
        
         if cost_sample < cost_demo,
             
             loss = loss + alpha * ( gamma * beta );
          
         else
             
             loss = loss + alpha * ( gamma * exp( -delta ) );
             
         end
    end
end

loss = loss + norm(w,1); % add the l1 norm for sparsity