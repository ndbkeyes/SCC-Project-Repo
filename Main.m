function main

    clc;
    clear all;
    close all;
    
    import Vertex
    import pkg.Lattice.*

   
    % *** NOTE: lattice dimensions need to be EVEN and MORE THAN 2 ***
    % Create and fill lattice of vertices
    lattice = Lattice(6,6,"open");
    lattice.set_neighbors();
    %lattice.disp_all_neighbors();
    
    
    
    
    %%%%% TRANSPORT TESTING %%%%%
    %{ 
    
    % Set up and print first vertex info
    current = lattice.vertex(1,1);
    current.outgoing = [1 0 0 0 0 0];
    current.disp_coords();
    fprintf('%d %d %d %d %d %d\n', current.incoming.' );
    fprintf('%d %d %d %d %d %d\n', current.outgoing.' );
    
    % Track particle through transport chain
    for i=2:lattice.dimx
        
        % Move one to the right
        current = current.neighbors(1);
        current.disp_coords();

         % Transport & show updated incoming
        lattice.transport_all();
        fprintf('%d %d %d %d %d %d\n', current.incoming.' );

        % Collide & show updated outgoing
        lattice.collide_all();
        fprintf('%d %d %d %d %d %d\n', current.outgoing.' );
        
    end
    %}
    
    
    
    
    %%%%% COLLISION TEST %%%%%%
    
    current = lattice.vertex(2,2);
    current.incoming = [1 0 1 1 1 0];
    
    current.disp_coords();
    fprintf('%d %d %d %d %d %d\n', current.incoming.' );
    fprintf('%d %d %d %d %d %d\n', current.outgoing.' );
    
    lattice.collide_all();
    
    current.disp_coords();
    fprintf('%d %d %d %d %d %d\n', current.incoming.' );
    fprintf('%d %d %d %d %d %d\n', current.outgoing.' );
    
    lattice.transport_all();
    
    current = current.neighbors(1);
    current.disp_coords();
    fprintf('%d %d %d %d %d %d\n', current.incoming.' );
    fprintf('%d %d %d %d %d %d\n', current.outgoing.' );
    
    lattice.collide_all();
    
    current.disp_coords();
    fprintf('%d %d %d %d %d %d\n', current.incoming.' );
    fprintf('%d %d %d %d %d %d\n', current.outgoing.' );
    

end



