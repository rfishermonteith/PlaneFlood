function t = getTLine(X, line)


t = (X-line(1:3))./line(4:6);

t = t(~isnan(t)&~isinf(t));
t = mean(t);
