function [loss,dw] = cost_function_and_gradient(w)

global phi_demo
global phi_k
global nb_used_samples

d_size = size(phi_demo);

% Flip vector for CMA
w_size = size(w);
if w_size(2) < w_size(1),
    w = w';
end

% Cost
loss = cost_function(w);
genetic_cost_function(w)

% Gradient
dw = zeros( size(w) );
for d=1:d_size(1),
        denominator = 0.0;
        for k=1:nb_used_samples,
            denominator = denominator + exp(-1.0*w*phi_k(k,:,d)');
        end
        for i=1:w_size(2), 
            numerator = 0.0;
            for k=1:nb_used_samples,
                numerator = numerator + exp(-1.0*w*phi_k(k,:,d)') * phi_k(k,i,d);
            end
            
            if denominator == 0 ,
               denominator = realmin;
            end
            
            dw(i) = dw(i) + phi_demo(d,i) - ( numerator /  denominator );
        end
end

loss
dw