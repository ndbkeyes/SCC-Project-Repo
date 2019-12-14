function main

    clc;
    clear all;
    close all;
    
    
    % Create and fill lattice of vertices
    % *** remember that lattice dimensions have to be even and greater than 2
    % *** AND block size should be that too!
    xdim = 200;
    ydim = 200;
    bcopt = "closed";
    plot_scale = 1;
    block_size = 50;
    prob = 0.25;
    
    lattice = Lattice(xdim,ydim,bcopt,plot_scale,block_size);
    lattice.set_neighbors();
    lattice.initialize(prob,1,lattice.dimy);
    
    
    
    
    
    % Create figure
    fig = figure;
    im = {};
    axis tight manual % this ensures that getframe() returns a consistent size
    filename = 'testAnimated.gif';
    delay = 0.1;
    fopen('PhaseTrajectory.txt','w');
    
    plot_arrows = 0;                    % YES plot the arrows on the lattice
    
    
    %%% =========== TIMESTEPPING LOOP! ============== %%%
    
    tfinal = 50;
    for t=1:tfinal
        
        % Clear plot, display time
        disp(t);
        
        if t ~= tfinal
            clf;
        end
        
        % Plot current lattice

        %lattice.plot_lattice(plot_arrows);
        xlim([-2 xdim+1]);
        ylim([-2 ydim+1]);
        pause(0.001);
        
        % ---- SAVE IMAGE INTO GIF ----
        % get image
        frame = getframe(fig);
        im{t} = frame2im(frame);
        [A,map] = rgb2ind(im{t},256);
        % write to file
        if t == 1
            imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',delay);
        else
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',delay);
        end
        % ----------------------------
        
        % Step lattice forward by one (transport, then collide)
        lattice.step_forward();
        
        % Drive cavity flow!
        lattice.cavity_drive();
        
        
    end
    
    
    
    %{
    %%% ======== PLOT PHASE TRAJECTORY ======== %%%
    data = csvread("PhaseTrajectory.txt");
    disp(data);
    
    clf;
    plot(data(:,1),data(:,2));
    scatter(data(:,1),data(:,2),'filled');
    saveas(gcf,"PhaseTrajectory_Plot.png");
    %}
    
    hold on;
    lattice.calc_vecfield(block_size);
    xlim([-2 xdim+1]);
    ylim([-2 ydim+1]);
    
    
end