classdef Vertex < handle
    
    properties (GetAccess = 'public', SetAccess = 'public')
        
        x
        y
        neighbors
        num_particles
        
        incoming
        outgoing
        
    end
    
    
    methods
        
        %%% Constructor method
        function obj = Vertex(xcoord,ycoord)
            
            obj.x = xcoord;
            obj.y = ycoord;
        
            obj.neighbors = Vertex.empty(6,0);
            obj.incoming = zeros(1,6);
            obj.outgoing = zeros(1,6);
            
        end
        
        
        
        %%% Run one collision step
        % INCOMING particles to this vertex -> OUTGOING particles from this vertex
        function obj = collision(obj)
            
            for i=1:6
                incoming_value = obj.incoming(i);
                obj.outgoing(opplink(i)) = incoming_value;
                
            end
            
        end
        
        
        %%% Run one transport step
        % OUTGOING particles from one vertex -> INCOMING particles to another vertex
        function obj = transport(obj)
            
            %fprintf("TRANSPORT - (%d,%d)\n", obj.x, obj.y);
            
            
        end
        
        
        %%% Display all neighbors of the vertex
        function disp_neighbors(obj)
            fprintf("Neighbors of (%d,%d) : ", obj.x, obj.y);
            for i=1:6
                neighbor = obj.neighbors(i);
                fprintf("(%d,%d) ", neighbor.x, neighbor.y);
            end
            fprintf("\n");
        end
        
        
        %%% Display coordinates of the vertex
        function disp_coords(obj)
            fprintf("(%d, %d) \n",obj.x,obj.y);
        end
        
    end
    
end


%%% Calculate index of "opposite" link
function opp = opplink(i)
    opp = mod(i+3,6);
    if opp == 0
        opp = 6;
    end
    %fprintf("opplink of %d = %d\n", i, opp);
end

