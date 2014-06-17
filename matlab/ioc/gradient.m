clear; clc

syms w1 w2
w = [w1, w2];

syms phio1 phio2
phi_o = [phio1, phio2];

syms phi11 phi12
phi_1 = [phi11, phi12];

syms phi21 phi22
phi_2 = [phi21, phi22];

f = -log( exp(-w*phi_o') / ( exp(-w*phi_1') + exp(-w*phi_2') ) );
g = gradient(f, [w1, w2]);

simplify(g)

% (exp(w1*conj(phi11) + w2*conj(phi12))*conj(phi11) + exp(w1*conj(phi21) + w2*conj(phi22))*conj(phi21))/(exp(w1*conj(phi11) + w2*conj(phi12)) + exp(w1*conj(phi21) + w2*conj(phi22))) - conj(phio1)
% (exp(w1*conj(phi11) + w2*conj(phi12))*conj(phi12) + exp(w1*conj(phi21) + w2*conj(phi22))*conj(phi22))/(exp(w1*conj(phi11) + w2*conj(phi12)) + exp(w1*conj(phi21) + w2*conj(phi22))) - conj(phio2)
 
% (exp(w1*phi11 + w2*phi12)*phi11 + exp(w1*phi21 + w2*phi22)*phi21)/(exp(w1*phi11 + w2*phi12) + exp(w1*phi21 + w2*phi22)) - phio1
% (exp(w1*phi11 + w2*phi12)*phi12 + exp(w1*phi21 + w2*phi22)*phi22)/(exp(w1*phi11 + w2*phi12) + exp(w1*phi21 + w2*phi22)) - phio2

% conj(phio1) - (exp(- w1*conj(phi11) - w2*conj(phi12))*conj(phi11) + exp(- w1*conj(phi21) - w2*conj(phi22))*conj(phi21))/(exp(- w1*conj(phi11) - w2*conj(phi12)) + exp(- w1*conj(phi21) - w2*conj(phi22)))
% conj(phio2) - (exp(- w1*conj(phi11) - w2*conj(phi12))*conj(phi12) + exp(- w1*conj(phi21) - w2*conj(phi22))*conj(phi22))/(exp(- w1*conj(phi11) - w2*conj(phi12)) + exp(- w1*conj(phi21) - w2*conj(phi22)))
 
% phio1 - (exp(- w1*phi11 - w2*phi12)*phi11 + exp(- w1*phi21 - w2*phi22)*phi21)/(exp(- w1*phi11 - w2*phi12) + exp(- w1*phi21 - w2*phi22))
% phio2 - (exp(- w1*phi11 - w2*phi12)*phi12 + exp(- w1*phi21 - w2*phi22)*phi22)/(exp(- w1*phi11 - w2*phi12) + exp(- w1*phi21 - w2*phi22))
 
for i=1:1000,
    
    w = rand(1,2);
    phi_o = rand(1,2);
    phi_1 = rand(1,2);
    phi_2 = rand(1,2);
    
    g_s = [0 0];
    g_s(1) = phi_o(1) - (exp(- w(1)*phi_1(1) - w(2)*phi_1(2))*phi_1(1) + exp(- w(1)*phi_2(1) - w(2)*phi_2(2))*phi_2(1))/(exp(- w(1)*phi_1(1) - w(2)*phi_1(2)) + exp(- w(1)*phi_2(1) - w(2)*phi_2(2)));
    g_s(2) = phi_o(2) - (exp(- w(1)*phi_1(1) - w(2)*phi_1(2))*phi_1(2) + exp(- w(1)*phi_2(1) - w(2)*phi_2(2))*phi_2(2))/(exp(- w(1)*phi_1(1) - w(2)*phi_1(2)) + exp(- w(1)*phi_2(1) - w(2)*phi_2(2)));
    
    %----------------
    % Numerical gradient
    
    g_n = [0 0];
    
    eps = 1e-6;
    
    f = [0 0];
    f(1) = -log( exp(-w*phi_o') / ( exp(-w*phi_1') + exp(-w*phi_2') ) );
    
    w_2 = [0 0];
    w_2(1) = w(1) + eps;
    w_2(2) = w(2);
    
    f(2) = -log( exp(-w_2*phi_o') / ( exp(-w_2*phi_1') + exp(-w_2*phi_2') ) );
    
    g_n(1) = ( f(2) - f(1) ) / eps ;
    
    w_2(1) = w(1);
    w_2(2) = w(2) + eps;
    
    f(2) = -log( exp(-w_2*phi_o') / ( exp(-w_2*phi_1') + exp(-w_2*phi_2') ) );
    
    g_n(2) = ( f(2) - f(1) ) / eps ;
    
    disp('-----------------------------')
    disp(['symbolic gradient : ' num2str(g_s)])
    disp(['numerical gradient : ' num2str(g_n)])
    disp(['error : ' num2str(g_s-g_n)])
end
