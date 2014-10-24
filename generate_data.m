%Generate data
x = linspace(0,30,1000);
xpost = linspace(30,50,1000);
r = randperm(length(x));
x = x(r);
ntrain = 20;
y = cos([x xpost])+-0.5*sqrt([x xpost]);
xtrain = x(1:ntrain);
xtest = [x(ntrain+1:end) xpost];
ytrain = y(1:ntrain);
ytest = y(ntrain+1:end);

cov = {@covSEiso}; sf = 1; ell = 0.4;                             % setup the GP
hyp0.cov  = log([ell;sf]);
mean = {@meanZero};
hyp0.mean = [];
lik = {@likGauss}; sn = 0.2;
hyp0.lik  = log(sn);
inf = {@infExact}; 
Ncg = 50;                                   % number of conjugate gradient steps
% ymu{1} = f(xte); ys2{1} = sn^2; nlZ(1) = -Inf;

hyp = minimize(hyp0,'gp', -Ncg, inf, mean, cov, lik, xtrain', ytrain'); % opt hypers

[ymu ys2 fmu fs2] = gp(hyp, inf, mean, cov, lik, xtrain', ytrain', xtest');

hold on;
plot(xtrain,ytrain,'o');
% plot(xtest,ytest,'o');
plot(xtest,ymu,'.r');