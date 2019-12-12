classdef Lattice < handle
    
    properties (GetAccess = 'public', SetAccess = 'public')
        
        dimx
        dimy
        vertices
        bcopt
        nullneighbor
        phys_scale
        
    end
    
    
    methods
        
        %%% Constructor method
        function obj = Lattice(dx,dy,bc,scale)
            
            % Validate input: dimensions even and >= 2, bcopt open, closed, or wrap
            if dx < 2 || dy < 2
                disp("Lattice dimension too small - must be at least 2 in each direction");
                return
            end
            if rem(dx,2) ~= 0 || rem(dy,2) ~= 0
                disp("Lattice dimensions need to be even");
                return
            end
            if ~strcmp(bc,"open") && ~strcmp(bc,"closed") && ~strcmp(bc,"wrap")
                disp("Lattice boundary condition invalid");
                return
            end
            
            % Set dimensions and bcopt after verification
            obj.dimx = dx;
            obj.dimy = dy;
            obj.bcopt = bc;
            obj.phys_scale = scale;
            
            % Create vertex set
            varr = {};
            for y=1:obj.dimy
                for x=1:obj.dimx
                    varr{y,x} = Vertex(x,y,obj.phys_scale,obj.bcopt);
                end
            end
            obj.vertices = varr;   
            
            % Create nullneighbor with nullneighbor neighbors itself
            obj.nullneighbor = Vertex(0,0,obj.phys_scale,obj.bcopt);
            obj.nullneighbor.neighbors = [obj.nullneighbor obj.nullneighbor obj.nullneighbor obj.nullneighbor obj.nullneighbor obj.nullneighbor];
            
        end
        
        
        %%% Set all the neighbor connections in the lattice
        function obj = set_neighbors(obj)
                        
            
            % ======= INTERIOR VERTICES ===================================
            
            for y=2:obj.dimy-1
                for x=2:obj.dimx-1
                    
                    v = obj.vertex(x,y);
                    
                    % odd rows
                    if rem(y,2) == 1  %        (1)                (2)                  (3)               (4)               (5)                (6)
                        v.neighbors = [ obj.vertex(x+1,y) obj.vertex(x+1,y+1) obj.vertex(x,y+1) obj.vertex(x-1,y) obj.vertex(x,y-1) obj.vertex(x+1,y-1) ];
                    end
                    
                    % even rows
                    if rem(y,2) == 0  %        (1)                (2)                  (3)               (4)               (5)                (6)
                        v.neighbors = [ obj.vertex(x+1,y) obj.vertex(x,y+1) obj.vertex(x-1,y+1) obj.vertex(x-1,y) obj.vertex(x-1,y-1) obj.vertex(x,y-1) ];
                    end
                    
                    
                end
            end
            
            
            % ======= CORNERS =============================================
            % assuming that y dimension is even (for purposes of SW and SE)
            
            [xnw, ynw] = deal(1,obj.dimy);
            [xne, yne] = deal(obj.dimx, obj.dimy);
            [xsw, ysw] = deal(1,1);
            [xse, yse] = deal(obj.dimx,1);
            
            nw = obj.vertex(xnw,ynw);
            ne = obj.vertex(xne,yne);
            sw = obj.vertex(xsw,ysw);
            se = obj.vertex(xse,yse);
            
                           % (1)                    (2)                     (3)                     (4)                    (5)                 (6)
            nw.neighbors = [ obj.vertex(xnw+1,ynw)  obj.nullneighbor        obj.nullneighbor        obj.nullneighbor       obj.nullneighbor        obj.vertex(xnw,ynw-1) ];
            ne.neighbors = [ obj.nullneighbor       obj.nullneighbor        obj.nullneighbor        obj.vertex(xne-1,yne)  obj.vertex(xne-1,yne-1) obj.vertex(xne,yne-1) ];
            sw.neighbors = [ obj.vertex(xsw+1,ysw)  obj.vertex(xsw+1,ysw+1) obj.vertex(xsw,ysw+1)   obj.nullneighbor       obj.nullneighbor        obj.nullneighbor ];
            se.neighbors = [ obj.nullneighbor       obj.nullneighbor        obj.vertex(xse,yse+1)   obj.vertex(xse-1,yse)  obj.nullneighbor        obj.nullneighbor ];

            
            
            
            % ======= BORDERS =============================================
            % assuming that y dimension is even (for purposes of southern border)
            
            
            %%% ------ North / South ------ %%%
            y_north = obj.dimy;
            y_south = 1;
            
            for x=2:obj.dimx-1
                
                vert_north = obj.vertex(x,y_north);
                vert_south = obj.vertex(x,y_south);
                
                                     %   (1)               (2)                  (3)                 (4)               (5)                 (6)
                vert_north.neighbors = [ obj.vertex(x+1,y_north) obj.nullneighbor     obj.nullneighbor    obj.vertex(x-1,y_north) obj.vertex(x-1,y_north-1) obj.vertex(x,y_north-1) ];
                vert_south.neighbors = [ obj.vertex(x+1,y_south) obj.vertex(x+1,y_south+1)  obj.vertex(x,y_south+1)   obj.vertex(x-1,y_south) obj.nullneighbor    obj.nullneighbor ];
                
            end
            
            
            
            %%% ------ East / West ------ %%%
            x_west = 1;
            x_east = obj.dimx;
            
            % loop over y values
            for y=2:obj.dimy-1
                
                vert_east = obj.vertex(x_east,y);
                vert_west = obj.vertex(x_west,y);

                % EVEN row
                if rem(y,2) == 0        %   (1)                         (2)                     (3)                         (4)                     (5)                         (6)
                    vert_east.neighbors = [ obj.nullneighbor            obj.vertex(x_east,y+1)  obj.vertex(x_east-1,y+1)    obj.vertex(x_east-1,y)  obj.vertex(x_east-1,y-1)    obj.vertex(x_east,y-1) ];
                    vert_west.neighbors = [ obj.vertex(x_west+1,y) obj.vertex(x_west,y+1)  obj.nullneighbor            obj.nullneighbor        obj.nullneighbor            obj.vertex(x_west,y-1) ];
                    
                % ODD row
                elseif rem(y,2) == 1    %   (1)                     (2)                         (3)                     (4)                     (5)                     (6)
                    vert_east.neighbors = [ obj.nullneighbor        obj.nullneighbor            obj.vertex(x_east,y+1)  obj.vertex(x_east-1,y)  obj.vertex(x_east,y-1)  obj.nullneighbor];
                    vert_west.neighbors = [ obj.vertex(x_west+1,y)  obj.vertex(x_west+1,y+1)    obj.vertex(x_west,y+1)  obj.nullneighbor        obj.vertex(x_west,y-1)  obj.vertex(x_west+1,y-1) ];
                    
                else
                end
                
            end
            

        end
        

        
        %%% Get (x,y) element of lattice
        function v = vertex(obj,x,y)
            v = obj.vertices{y,x};
        end
        
        
        %%% Display all neighbors
        function disp_all_neighbors(obj)
            for x=1:obj.dimx
                for y=1:obj.dimy
                    obj.vertex(x,y).disp_neighbors();
                end
            end
            fprintf("\n\n--------------------------\n\n\n");
        end
        
        
        %%% Run collision on each vertex in lattice
        function collide_all(obj)
            for x=1:obj.dimx
                for y=1:obj.dimy
                    v = obj.vertex(x,y);
                    v.collision();
                end
            end
        end
        
        %%% Run transport on each vertex in lattice
        function transport_all(obj)
            for x=1:obj.dimx
                for y=1:obj.dimy
                    v = obj.vertex(x,y);
                    v.transport();
                end
            end
        end
        
        
        %%% Update lattice by one transport step
        function step_forward(obj)
            obj.transport_all();
            obj.collide_all();
            % *** ORDER IS KEY HERE !
        end
        
        
        
        
        %%% Set initial conditions - trying to simulate stone in pond???
        function set_init(obj)
            
            for i=1:obj.dimx
                for j=1:obj.dimy
                    
                    vertex = obj.vertex(i,j);
                    vertex.outgoing = [1 0 0 0 0 0];
                    
                end
            end
            
        end
        
        
        
        %%% ----------------------------------------------------------- %%%
        %%% ----------------- PLOTTING CODE --------------------------- %%%
        %%% ----------------------------------------------------------- %%%
        
        
        function plot_lattice(lattice)
            
            hold on;

            for x=1:lattice.dimx
                for y=1:lattice.dimy
                    lattice.vertex(x,y).plot_vertex();
                end
            end

        end
                
        
    end
    
    
end