

x = linspace(-5,5,100);
f = @(x) x.^3 - 3*x + 2;
dfdx = @(x) 3*x.^2 - 3;

xc = 20 * ( 2*rand()-1 ); % start between -10 and 10
    
figure;
hold on;
plot(x,f(x),'b');

ymin = min(f(x));
ymax = max(f(x));

for i = 1:10
    
    record(i,:) = [ xc f(xc) dfdx(xc) ];
    
    plot(xc,f(xc),'.r');
    display(xc);
    display(f(xc));
    
    m = dfdx(xc);
    b = f(xc) - m*xc;
    plot(x,m*x+b,'r');
    
    xc = xc - f(xc)/dfdx(xc);
    
end
    
ylim([ymin ymax]);
    