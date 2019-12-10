function main

    clc;
    clear all;
    close all;

    %Import classes for vertices and lattice
    import pkg.VertexOld.* 
    import pkg.LatticeOld.*
    
    %Create and fill 4x4 lattice (Lattice object of vertices)
    lattice = Lattice(3,3,'open');
    lattice.setneighbors();
    
    a = lattice.vertex(1,1);
    b = lattice.vertex(2,1);
    c = lattice.vertex(3,1);
    
    a.add_particle(4);
    
    a.disp_links();
    b.disp_links();
    c.disp_links();
    
    
    a.collision();
    
    
    a.disp_links();
    b.disp_links();
    c.disp_links();

    
    a.transport();
    
    
    a.disp_links();
    b.disp_links();
    c.disp_links();
    
    
    
    % NEED TO FIGURE OUT HOW TO DO TRANSPORTS SO THAT THEY DON"T CANCEL OUT
    % maybe use separate array in vertices called "incoming" that then gets
    % updated for each particle at the very end???
    
    
    
   
end
