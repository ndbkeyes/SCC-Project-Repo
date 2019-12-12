function main

    clc;
    clear all;
    close all;
    
    
    % Create and fill lattice of vertices
    [xdim, ydim, plot_scale] = deal(6,6,1);
    lattice = Lattice(xdim,ydim,"open",plot_scale);
    lattice.set_neighbors();
    
    
    
    %%%% PLOTTING TESTING %%%%

    % Set initial conditions through outgoing on certain vertices
    c1 = lattice.vertex(3,2);
    c2 = lattice.vertex(4,4);
    c1.outgoing = [0 1 0 0 0 0];
    c2.outgoing = [0 0 0 0 1 0];
    
    % Step forward in time
    for i=1:10
        
        disp(i);
        pause(0.5);
        clf;
        
        % Plot current lattice
        lattice.plot_lattice();
        xlim([0 7]);
        ylim([0 7]);
        
        % Step lattice forward by one - transport, then collide
        lattice.step_forward();
        
    end
    
    
end



