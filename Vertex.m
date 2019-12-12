classdef Vertex < handle
    
    properties (GetAccess = 'public', SetAccess = 'public')
        
        xgrid
        ygrid
        bcopt
        
        xphys
        yphys
        phys_scale

        neighbors
        
        num_particles
        incoming
        outgoing
        
    end
    
    
    methods
        
        %%% Constructor method
        function obj = Vertex(xcoord,ycoord,scale,bc)
            
            % ----- set computer grid coordinates of vertex ----- %
            obj.xgrid = xcoord;
            obj.ygrid = ycoord;
            
            % ----- set physical coordinates of vertex ----- %
            obj.phys_scale = scale;
            obj.yphys = ycoord * scale;
            % odd rows
            if rem(ycoord,2) == 1
                obj.xphys = (xcoord + 0.5) * scale;
            % even rows
            else
                obj.xphys = xcoord * scale;
            end
        
            % ----- create needed arrays ----- %
            obj.neighbors = Vertex.empty(6,0);
            obj.incoming = zeros(1,6);
            obj.outgoing = zeros(1,6);
            
            obj.bcopt = bc;
            obj.num_particles = 0;
            
        end
        
        
        
        %%% Run one collision step
        % INCOMING particles to this vertex -> OUTGOING particles from this vertex
        function obj = collision(obj)
            
            
            % ----- 3-collisions: both -----
            if isequal(obj.incoming, [1 0 1 0 1 0]) || isequal(obj.incoming, [0 1 0 1 0 1])
                
                % reflect back the same way!
                obj.outgoing = obj.incoming;
                
                
                
                
            % ----- 2-collision #1: (1,4) -----
            elseif isequal(obj.incoming, [1 0 0 1 0 0])
                
                % choose randomly between scattering cases
                if randi([0,1])
                    obj.outgoing = [0 1 0 0 1 0];
                else
                    obj.outgoing = [0 0 1 0 0 1];
                end
                
            % ----- 2-collision #2: (2,5) -----
            elseif isequal(obj.incoming, [0 1 0 0 1 0])
                
                % choose randomly between scattering cases
                if randi([0,1])
                    obj.outgoing = [1 0 0 1 0 0];
                else
                    obj.outgoing = [0 0 1 0 0 1];
                end
                
            % ----- 2-collision #3: (3,6) -----
            elseif isequal(obj.incoming, [0 0 1 0 0 1])
                
                % choose randomly between scattering cases
                if randi([0,1])
                    obj.outgoing = [1 0 0 1 0 0];
                else
                    obj.outgoing = [0 1 0 0 1 0];
                end
                
                
                
            % ----- NON-collision case ! -----
            else
                
                % pass particles through directly
                for i=1:3
                    obj.outgoing(i) = obj.incoming(i+3);
                    obj.outgoing(i+3) = obj.incoming(i);
                end
                
            end
            
            
            % reset incoming array
            obj.incoming = [0 0 0 0 0 0];    
            
            
            % count up total number of particles outgoing from vertex
            obj.num_particles = sum(obj.outgoing);
            
        end
        
        
        %%% Run one transport step
        % OUTGOING particles from one vertex -> INCOMING particles to another vertex
        function obj = transport(obj)
            
            for i=1:6
                
                link_i = obj.outgoing(i);           % get value of ith outgoing link
                n = obj.neighbors(i);               % get ith neighbor vertex
                
                % Handle bounceback for closed border
                if n.xgrid == 0 && n.ygrid == 0 && strcmp(obj.bcopt, "closed") && link_i == 1
                    obj.incoming(i) = link_i;  % bounce back - send outgoing value to incoming on same link
                    
                % Transport as normal for interior points and/or open border
                else
                    n.incoming( opplink(i) ) = link_i;  % set ith neighbor's incoming link to current outgoing link value
                end

            end
            
            obj.outgoing = [0 0 0 0 0 0];           % reset outgoing array
            
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
        
        
        
        
        %%% ----------------------------------------------------------- %%%
        %%% ----------------- PLOTTING CODE --------------------------- %%%
        %%% ----------------------------------------------------------- %%%
        
        function plot_vertex(obj)

            % Plot point at which vertex is located
            [x,y] = deal(obj.xphys,obj.yphys);
            plot(x,y,'o','color',[0 0 0]);
            
            % Plot hexagon
            fill([x+0.5,x+0.25,x-0.25,x-0.5,x-0.25,x+0.25,x+0.5],[y,y+0.5,y+0.5,y,y-0.5,y-0.5,y],[1, 1, (1 - obj.num_particles/6)]);
            
            % Plot arrows representing outgoing particles
            arrows = [ 1 0; 0.5 1; -0.5 1; -1 0; -0.5 -1; 0.5 -1] * obj.phys_scale/2;
            for i=1:6
                if obj.outgoing(i) == 1
                    quiver(obj.xphys, obj.yphys, arrows(i,1), arrows(i,2),0,'MaxHeadSize',1.0,'color',[0 0 1]);
                end
            end

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
