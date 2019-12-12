function main

    clc;
    clear all;
    close all;
    
    
    % Create and fill lattice of vertices
    [xdim, ydim, plot_scale] = deal(50,50,1);
    lattice = Lattice(xdim,ydim,"closed",plot_scale);
    lattice.set_neighbors();
    lattice.set_init();
    
    
    
    fig = figure;
    im = {};
    axis tight manual % this ensures that getframe() returns a consistent size
    filename = 'testAnimated.gif';
    delay = 0.1;
    
    %%% =========== TIMESTEPPING LOOP! ================
    for i=1:50
        
        % Clear plot, display
        disp(i);
        clf;
        
        % Plot current lattice
        lattice.plot_lattice();
        xlim([0 xdim+1]);
        ylim([0 ydim+1]);
        pause(0.001);
        
        % --- GET IMAGE INTO GIF ---
        
        % get image
        frame = getframe(fig);
        im{i} = frame2im(frame);
        [A,map] = rgb2ind(im{i},256);
        
        % write to file
        if i == 1
            imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',delay);
        else
            imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',delay);
        end

        % --------------------------
        
        
        % Step lattice forward by one (transport, then collide)
        lattice.step_forward();
        
    end
    
    
end



