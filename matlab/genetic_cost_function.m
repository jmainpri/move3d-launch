function loss = genetic_cost_function(w)

global phi_demo
global phi_k
global nb_used_samples

d_size = size(phi_demo);

loss = 0;

for d=1:d_size(1),
    cost_demo = w*phi_demo(d,:)';
    for k=1:nb_used_samples,
        
        cost_sample = w*phi_k(k,:,d)';
        
         if cost_sample < cost_demo,
             loss = loss + 100;
         end
         
         loss = loss + 0.1 * abs( cost_sample - cost_demo );
    end
end