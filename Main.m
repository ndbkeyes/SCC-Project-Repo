function main

    clc;
    clear all;
    close all;
    
    
    % Create and fill lattice of vertices
    [xdim, ydim, plot_scale] = deal(10,10,1);
    lattice = Lattice(xdim,ydim,"closed",plot_scale);
    lattice.set_neighbors();
    
    
    
    %%%% PLOTTING TESTING %%%%

    % Set initial conditions through outgoing on certain vertices
    center = lattice.vertex(5,5);
    
    
    % Step forward in time
    for i=1:50
        
        % Set center vertex as constant source!!
        center.outgoing = [1 1 1 1 1 1];
        
        % Clear plot, display
        disp(i);
        clf;
        
        % Plot current lattice
        lattice.plot_lattice();
        xlim([-1 11]);
        ylim([-1 11]);
        
        pause(0.001);
        
        % Step lattice forward by one - transport, then collide
        lattice.step_forward();
        
    end
    
    
end



