x = randn(100,1);
[counts,binCenters] = hist(x,100);
binWidth = diff(binCenters);
binWidth = [binWidth(end),binWidth]; % Replicate last bin width for first, which is indeterminate.
nz = counts>0; % Index to non-zero bins
frequency = counts(nz)/sum(counts(nz));
nz
H = -sum(frequency.*log(frequency./binWidth(nz)))
plot( binCenters, counts )
% plot( frequency )