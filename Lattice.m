classdef Lattice < handle
    
    properties (GetAccess = 'public', SetAccess = 'public')
        
        dimx
        dimy
        vertices
        bcopt
        nullneighbor
        
    end
    
    
    methods
        
        %%% Constructor method
        function obj = Lattice(dx,dy,bc)
            
            % Requires that dx and dy be at least 2!
            if dx < 2 || dy < 2
                disp("Lattice dimension too small - must be at least 2 in each direction");
                return
            end
            
            % Set dimensions of lattice
            obj.dimx = dx;
            obj.dimy = dy;
            obj.bcopt = bc;
            
            % Create vertex set
            varr = {};
            for y=1:obj.dimy
                for x=1:obj.dimx
                    varr{y,x} = Vertex(x,y);
                end
            end
            obj.vertices = varr;         
            
        end
        
        
        %%% Set all the neighbor connections
        function obj = setneighbors(obj)
                        
            
            % ======= INTERIOR VERTICES ===================================
            
            for y=2:obj.dimy-1
                for x=2:obj.dimx-1
                    v = obj.vertex(x,y);
                    
                    % account for the fact that the even/odd-ness of rows affects coordinates of neighbors!
                    % have to offset x-coordinates of vertices 2, 3, 5, and 6 by 1
                    if rem(y,2) == 0
                        v.neighbors = [ obj.vertex(x+1,y), obj.vertex(x,y-1), obj.vertex(x-1,y-1), obj.vertex(x-1,y), obj.vertex(x-1,y+1), obj.vertex(x,y+1) ];
                    elseif rem(y,2) == 1
                        v.neighbors = [ obj.vertex(x+1,y), obj.vertex(x+1,y-1), obj.vertex(x,y-1), obj.vertex(x-1,y), obj.vertex(x,y+1), obj.vertex(x+1,y+1) ];
                    else
                        disp("wow something's really wrong - y isn't an integer. yikes :(");
                    end
                    
                end
            end
            

            % ======= SET PHANTOM NEIGHBOR VALUE ==========================
            
            % if bcopt is open, set phantom neighbor to null vertex          
            if strcmp(obj.bcopt, 'open')
                obj.nullneighbor = Vertex(0,0);
            % if bcopt is closed, set phantom neighbor to tag to indicate reflection needed
            elseif strcmp(obj.bcopt, 'closed')
                obj.nullneighbor = 'reflect';
            else
                % deal with wrapping later
            end
            
            
            % ======= NSEW BOUNDARIES =====================================
            
            % North & South boundaries
            y_north = 1;
            y_south = obj.dimy;
            
            for x=2:obj.dimx-1

                % Get north & south border vertices at current x
                vert_north = obj.vertex(x,y_north);
                vert_south = obj.vertex(x,y_south);

                % Set north neighbors
                vert_north.neighbors = [ obj.vertex(x+1,y_north), obj.nullneighbor, obj.nullneighbor, obj.vertex(x-1,y_north), obj.vertex(x,y_north+1), obj.vertex(x+1,y_north+1) ];

                % Account for dependence on even/oddness of lattice's y-dimension
                % for southern border neighbors
                if rem(obj.dimy,2) == 0
                    vert_south.neighbors = [ obj.vertex(x+1,y_south), obj.vertex(x,y_south-1), obj.vertex(x-1,y_south-1), obj.vertex(x-1,y_south), obj.nullneighbor, obj.nullneighbor ];
                elseif rem(obj.dimy,2) == 1
                    vert_south.neighbors = [ obj.vertex(x+1,y_south), obj.vertex(x+1,y_south-1), obj.vertex(x,y_south-1), obj.vertex(x-1,y_south), obj.nullneighbor, obj.nullneighbor ];
                else
                    disp("error - y not integer yikes :(");
                end

            end


            % East & West boundaries
            x_west = 1;
            x_east = obj.dimx;
            
            for y=2:obj.dimy-1
                
                vert_west = obj.vertex(x_west,y);
                vert_east = obj.vertex(x_east,y);
                
                if rem(y,2) == 0
                    vert_west.neighbors = [ obj.vertex(x_west+1,y), obj.vertex(x_west,y-1), obj.nullneighbor, obj.nullneighbor, obj.nullneighbor, obj.vertex(x_west,y+1) ];
                    vert_east.neighbors = [ obj.nullneighbor, obj.vertex(x_east,y-1), obj.vertex(x_east-1,y-1), obj.vertex(x_east-1,y), obj.vertex(x_east-1,y+1), obj.vertex(x_east,y+1) ];
                elseif rem(y,2) == 1
                    vert_west.neighbors = [ obj.vertex(x_west+1,y), obj.vertex(x_west+1,y-1), obj.vertex(x_west,y-1), obj.nullneighbor, obj.vertex(x_west,y+1), obj.vertex(x_west+1,y+1) ];
                    vert_east.neighbors = [ obj.nullneighbor, obj.nullneighbor, obj.vertex(x_east,y-1), obj.vertex(x_east-1,y), obj.vertex(x_east,y+1), obj.nullneighbor ];
                else
                end
                
            end

 
            % ======= CORNERS =============================================
            
            nw = obj.vertex(1, 1);
            ne = obj.vertex(obj.dimx,1);
            sw = obj.vertex(1, obj.dimy);
            se = obj.vertex(obj.dimx, obj.dimy);

            % Northern corners always handled same
            nw.neighbors = [ obj.vertex(2,1), obj.nullneighbor, obj.nullneighbor, obj.nullneighbor, obj.vertex(1,2), obj.vertex(2,2) ];
            ne.neighbors = [ obj.nullneighbor, obj.nullneighbor, obj.nullneighbor, obj.vertex(obj.dimx-1,1), obj.vertex(obj.dimx,2), obj.nullneighbor ];

            % Southern corners - matters if lattice's y-dimension is even or odd
            if rem(obj.dimy,2) == 0
                sw.neighbors = [ obj.vertex(2,obj.dimy), obj.vertex(1,obj.dimy-1), obj.nullneighbor, obj.nullneighbor, obj.nullneighbor, obj.nullneighbor ];
                se.neighbors = [ obj.nullneighbor, obj.vertex(obj.dimx,obj.dimy-1), obj.vertex(obj.dimx-1,obj.dimy-1), obj.vertex(obj.dimx-1,obj.dimy), obj.nullneighbor, obj.nullneighbor ];
            elseif rem(obj.dimy,2) == 1
                sw.neighbors = [ obj.vertex(2,obj.dimy), obj.vertex(2,obj.dimy-1), obj.vertex(1,obj.dimy-1), obj.nullneighbor, obj.nullneighbor, obj.nullneighbor ]; 
                se.neighbors = [ obj.nullneighbor, obj.nullneighbor, obj.vertex(obj.dimx, obj.dimy-1), obj.vertex(obj.dimx-1,obj.dimy), obj.nullneighbor, obj.nullneighbor ];
            else
                disp("again, something terribly wrong - y isn't an integer. yikes :(");
            end
            
                
            
        end
        

        
        %%% Get (x,y) element of lattice
        function v = vertex(obj,x,y)
            v = obj.vertices{y,x};
        end
        
        
        function step_forward(obj)
            
            for x=1:obj.dimx
                for y=1:obj.dimy
                    v = obj.vertex(x,y);
                    v.collision(lattice);
                    v.transport(lattice);
                end
            end
            
        end
                
        
    end
    
    
end