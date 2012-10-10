function [] = plot_circle(center,radius,arg)

    ifndef('center',[0 0]);
    ifndef('radius',1);
    ifndef('arg','-b');
    
    theta = linspace(0,2*pi,20);
    x = radius * cos(theta) + center(1);
    y = radius * sin(theta) + center(2);
    plot(x,y,arg)
    
end