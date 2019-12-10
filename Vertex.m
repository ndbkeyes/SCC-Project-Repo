classdef Vertex < handle
    
    properties (GetAccess = 'public', SetAccess = 'public')
        
        x
        y
        links
        incoming
        neighbors
        num_particles
        
    end
    
    
    methods
        
        %constructor method
        function obj = Vertex(xcoord,ycoord)
            obj.x = xcoord;
            obj.y = ycoord;
            obj.links = zeros(6,1);
            obj.neighbors = Vertex.empty(6,0);
        end
        
        
        %set value of a link (either 0/false if no particle or 1/true if particle) - i is axis number
        function obj = set_link(obj,i,val)
            obj.links(i) = val;
        end
        
        
        %run one collision step
        function obj = collision(obj)
            
            disp("COLLISION");
            
        end
        
        %run one transport step
        function obj = transport(obj)
            
            disp("TRANSPORT");
            
            for i=1:6
                
                % neighbor stuff
               
            end
                        
            
        end
        
        
        
        function disp_links(obj)
            fprintf("Links of (%d,%d) : ", obj.x, obj.y);
            for i=1:6
                fprintf("%d ", obj.links(i));
            end
            fprintf("\n");
        end
        
        
        
        function disp_neighbors(obj)
            fprintf("Neighbors of (%d,%d) : ", obj.x, obj.y);
            for i=1:6
                neighbor = obj.neighbors(i);
                fprintf("(%d,%d) ", neighbor.x, neighbor.y);
            end
            fprintf("\n");
        end
        
        
        % Add particle at index i
        function add_particle(obj,i)
            
            obj.num_particles = obj.num_particles + 1;
            obj.links(i) = 1;
            
        end
        
        
    end
    
end

function opp = opplink(i)
    opp = mod(i+3,6);
    if opp == 0
        opp = 6;
    end
    %fprintf("opplink of %d = %d\n", i, opp);
end

