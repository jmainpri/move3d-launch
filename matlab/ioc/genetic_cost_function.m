function loss = genetic_cost_function(w)

global phi_demo
global phi_k
global nb_used_samples

d_size = size(phi_demo);
w_size = size(w);
if w_size(2) < w_size(1),
    w = w';
end

alpha = 1;
beta = 1000;
gamma = 500;
theta = 0;
loss = 0;

% disp('--------------------------------')

for d=1:d_size(1),
    
    cost_demo = w*phi_demo(d,:)';
    
    for k=1:nb_used_samples,
        
         cost_sample = w*phi_k(k,:,d)';
         delta = cost_sample - cost_demo;
         
%          delta
         
         loss = loss + alpha * exp( -delta );
         
        
%          if delta < 0, % demo has higher cost
%              
%              loss = loss + beta;
%          else
             
%          end
    end
end

loss = loss + theta * norm(w,1); % add the l1 norm for sparsity