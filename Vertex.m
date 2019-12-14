classdef Vertex < handle
    
    properties (GetAccess = 'public', SetAccess = 'public')
        
        xgrid           % x-coordinate of vertex in grid/computer space
        ygrid           % y-coordinate of vertex in grid/computer space
        bcopt           % String holding boundary condition to use for collisions
        
        xphys           % x-coordinate of vertex in physical space
        yphys           % y-coordinate of vertex in physical space
        phys_scale      % scaling factor for plotting

        neighbors       % Array of neighboring vertex objects    
        
        num_particles   % Stores number of particles outgoing from vertex
        incoming        % Array of incoming particle truth values
        outgoing        % Array of outgoing particle truth values
        
    end
    
    
    methods
        
        %%% Constructor method
        function obj = Vertex(xcoord,ycoord,scale,bc,bsize)
            
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
            
            
            % CHECK FOR TRACKER before running collision!
            tracker_index = 0;
            if ismember(2,obj.outgoing)
                tracker_index = find(obj.outgoing==2);
            end
            
            
            config_int = links_to_int(obj.incoming);
            coll3 = (config_int == 42) || (config_int == 21);
            coll2 = (config_int == 36) || (config_int == 18) || (config_int == 9);
            

            % ----- 3-collisions -----
            if coll3

                % reflect back the same way!
                obj.outgoing = obj.incoming;
                

            % ----- 2-collisions -----
            elseif coll2
                
                shift = randi([-1,1]);

                % choose randomly between scattering cases
                obj.outgoing = circshift(obj.incoming,shift);
                
                
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
            obj.num_particles = nnz(obj.outgoing);


            % HANDLE TRACKER COLLISION separately
            if tracker_index ~= 0
                obj.outgoing(opplink(tracker_index)) = 2;
            end

            % Print vertex coordinates to file if tracker is outgoing from it
            for i=1:6
                if obj.outgoing(i) == 2
                    outputFile = fopen('PhaseTrajectory.txt', 'a+');
                    %fprintf("Tracker at (%d,%d)\n",obj.xphys,obj.yphys);
                    fprintf(outputFile,"%d,%d\n",obj.xphys,obj.yphys);
                    fclose(outputFile);
                end
            end
                
            
        end
        
        
        %%% Run one transport step
        % OUTGOING particles from one vertex -> INCOMING particles to another vertex
        function obj = transport(obj)
            
            for i=1:6
                
                link_i = obj.outgoing(i);           % get value of ith outgoing link
                n = obj.neighbors(i);               % get ith neighbor vertex
                
                % Handle bounceback for closed border
                if n.xgrid == 0 && n.ygrid == 0 && strcmp(obj.bcopt, "closed") && link_i ~= 0
                    obj.incoming(i) = link_i;  % bounce back - send outgoing value to incoming on same link
                    
                    %%% NEED TO FIX BOUNCEBACK - this sends it directly
                    %%% back instead of reflecting with equal angle!!!
                    
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
        
        function plot_vertex(obj,a)
            
            % CHECK GRID VS PHYS
            [x,y] = deal(obj.xphys,obj.yphys);

            % Plot ALL hexagons
            %{
            color_arr = [1, 1, (1 - obj.num_particles/6)];
            if ismember(2,obj.outgoing)
                color_arr = [0, 0, 0];
            end
            fill([x+0.5,x+0.25,x-0.25,x-0.5,x-0.25,x+0.25,x+0.5],[y,y+0.5,y+0.5,y,y-0.5,y-0.5,y],color_arr,'LineStyle','none');
            %}
            
            % ONLY plot hexagon for tracker!
            if ismember(2,obj.outgoing)
                fill([x+0.5,x+0.25,x-0.25,x-0.5,x-0.25,x+0.25,x+0.5],[y,y+0.5,y+0.5,y,y-0.5,y-0.5,y],[ 0 0 0 ],'LineStyle','none');
            end
            
            
            % Plot point at which vertex is located
            % plot(x,y,'o','color',[0 0 0]);
            
            % Plot arrows representing outgoing particles
            if a
                arrows = [ 1 0; 0.5 1; -0.5 1; -1 0; -0.5 -1; 0.5 -1] * obj.phys_scale/2;
                for i=1:6
                    if obj.outgoing(i) ~= 0
                        quiver(x, y, arrows(i,1), arrows(i,2),0,'MaxHeadSize',1.0,'color',[0 0 1]);
                    end
                end
            end
            

        end
        
        
        %%% Sum up the direction vectors of links with outgoing particles
        function vector = sum_links(obj)
            
            direction_vectors = [ 0.5, 0 ; 0.25, 0.5 ; -0.25, 0.5 ; -0.5, 0 ; -0.25, -0.5 ; 0.25, -0.5];
            vector = [0,0];
            
            % Loop over links
            for i=1:6

                % Add appropriate direction vector if link is nonzero
                if obj.outgoing(i) ~= 0
                    vector = vector + direction_vectors(i,:);
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


%%% Convert link array to number using binary
function sum = links_to_int(links)

    sum = 0;
    power = 0;
    for i=6:-1:1
        if links(i) ~= 0
            sum = sum + 2^power;
        end
        power = power + 1;
    end
    
end
