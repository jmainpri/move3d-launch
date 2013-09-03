function loss = cost_function(w)

global phi_demo
global phi_k

d_size = size(phi_demo);
k_size = size(phi_k);

% Cost function
loss = 0;
for d=1:d_size(1),
    denonimnator=0;
    for k=1:k_size(3),
        denonimnator = denonimnator + exp(-1.0*w*phi_k(k,:,d)');
    end
    loss = loss - log( exp(-1.0*w*phi_demo(d,:)') / denonimnator );
end

