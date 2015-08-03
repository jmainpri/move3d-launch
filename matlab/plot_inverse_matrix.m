K     = load('diff_mat.txt');
KtK1  = load('control_costs_all.txt');
KtK2  = load('cost_free.txt')
A     = load('invcost_matrix.txt');
M     = load('m_mat.txt');

%a = load('control_costs_all.txt')
plot(A)
%for i=1:size(a(:,1)),
%    hold on
%    plot(a(i,:))
%end