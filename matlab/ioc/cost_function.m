function loss = cost_function(w)

global phi_demo
global phi_k
global nb_used_samples

d_size = size(phi_demo);

% Flip vector for CMA
w_size = size(w);
if w_size(2) < w_size(1),
    w = w';
end

% Cost function
loss = 0;
for d=1:d_size(1),
    denominator=0;
    for k=1:nb_used_samples,
        denominator = denominator + exp(-1.0*w*phi_k(k,:,d)');
        %error('your quitting error message') 
    end
    
    if denominator == 0 ,
        denominator = realmin;
    end
    
    numerator = exp(-1.0*w*phi_demo(d,:)');
    if numerator < 1e-60 ,
        numerator = 1e-60;
    end
            
    loss = loss - log( numerator / denominator );
end

% w
% loss