function main

    clc;
    clear all;
    close all;

   
    % *** NOTE: lattice dimensions need to be EVEN and MORE THAN 2 ***
    % Create and fill lattice of vertices
    lattice = Lattice(6,6,'open');
    lattice.set_neighbors();
    lattice.disp_all_neighbors();
    
    
    current = lattice.vertex(3,1);
    current.outgoing(2) = 1;

    current.disp_coords();
    fprintf('%d %d %d %d %d %d\n', current.incoming.' );
    fprintf('%d %d %d %d %d %d\n', current.outgoing.' );
    
    
    for i=2:lattice.dimx
        
        % Move one to the right
        current = current.neighbors(2);

        current.disp_coords();

         % Transport & show updated incoming
        lattice.transport_all();
        fprintf('%d %d %d %d %d %d\n', current.incoming.' );

        % Collide & show updated outgoing
        lattice.collide_all();
        fprintf('%d %d %d %d %d %d\n', current.outgoing.' );
        
    end
   
end
