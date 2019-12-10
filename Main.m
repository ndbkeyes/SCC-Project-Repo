function main

    clc;
    clear all;
    close all;

    %Import classes for vertices and lattice
    import pkg.VertexOld.* 
    import pkg.LatticeOld.*
    
    
    % *** NOTE: lattice dimensions need to be EVEN and MORE THAN 2 ***
    % Create and fill lattice of vertices
    lattice = Lattice(4,4,'open');
    lattice.set_neighbors();
   
    % Display each vertex's neighbors
    for x=1:lattice.dimx
        for y=1:lattice.dimy
            lattice.vertex(x,y).disp_neighbors();
        end
    end
    
    
    % NEED TO FIGURE OUT HOW TO DO TRANSPORTS SO THAT THEY DON"T CANCEL OUT
    % maybe use separate array in vertices called "incoming" that then gets
    % updated for each particle at the very end???
    
   
end
