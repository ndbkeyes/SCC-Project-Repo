function main

    clc;
    clear all;
    close all;
    
    
    % Create and fill lattice of vertices
    % *** remember that lattice dimensions have to be even and greater than 2
    [xdim, ydim, plot_scale] = deal(20,20,1);
    lattice = Lattice(xdim,ydim,"closed",plot_scale);
    lattice.set_neighbors();
    lattice.set_tracker(1,lattice.dimy);
    
    
    % Create figure
    fig = figure;
    im = {};
    axis tight manual % this ensures that getframe() returns a consistent size
    filename = 'testAnimated.gif';
    delay = 0.1;
    fopen('PhaseTrajectory.txt','w');
    
    
    %%% =========== TIMESTEPPING LOOP! ============== %%%
    
    for t=1:100
        
        % Clear plot, display time
        disp(t);
        clf;        
        
        % Plot current lattice
        lattice.plot_lattice();
        xlim([0 xdim+1]);
        ylim([0 ydim+1]);
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
    
    
    
    %%% ======== PLOT PHASE TRAJECTORY ======== %%%
    data = csvread("PhaseTrajectory.txt");
    disp(data);
    
    clf;
    plot(data(:,1),data(:,2));
    scatter(data(:,1),data(:,2),'filled');
    saveas(gcf,"PhaseTrajectory_Plot.png");
    
    
end