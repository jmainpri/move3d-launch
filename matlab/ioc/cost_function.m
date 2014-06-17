function loss = cost_function(w)

global phi_demo
global phi_k
global nb_used_samples

d_size = size(phi_demo);

% Cost function
loss = 0;
for d=1:d_size(1),
    denonimnator=0;
    for k=1:nb_used_samples,
        denonimnator = denonimnator + exp(-1.0*w*phi_k(k,:,d)');
        %error('your quitting error message') 
    end
    loss = loss - log( exp(-1.0*w*phi_demo(d,:)') / denonimnator );
end