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
            
            old_links = obj.links;
            
            for i=1:6
                obj.links(i) = old_links(opplink(i));
            end
            
        end
        
        %run one transport step
        function obj = transport(obj)
            
            disp("TRANSPORT");
            
            for i=1:6
                
                this_neighbor = obj.neighbors(i);
                
                opp = opplink(i);
                
                %If link i a particle on it, then the opposite (i+3 mod 6) link on
                %neighbor i gets that particle
                if obj.links(i) == 1
                    
                    obj.links(i) = 0;  % set this vertex's link value to zero since particle is leaving!
                    this_neighbor.set_link(opp,1);  % set neighbor's link value
                    
                    obj.num_particles = obj.num_particles - 1;  % decrement this vertex's particle number
                    this_neighbor.num_particles = this_neighbor.num_particles + 1;  % increment neighbor's particle number

                else
                    
                    this_neighbor.links(opp) = 0;  % set neighbor's link value - def doesn't have a particle on it now!
                    
                end
                
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

