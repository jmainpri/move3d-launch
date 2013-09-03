clear; clc

m = load('features.txt');

global phi_demo
global phi_k

phi_demo = m(1:10,:);
phi_k = zeros(10,16,10);

for d=1:10,
    phi_k(:,:,d) = m((d-1)*10+11:d*10+10,:);
end

w = zeros(1,16);
cost_function(w)
w = ones(1,16);
cost_function(w)