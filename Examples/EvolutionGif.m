pso = PSO(@schwefel, 2);
pso.velocityParam = 0.1;
pso.sizePopulation = 10;
pso.plotEachIterationB = true;
pso.plotPopulationB = true;
pso.plotBestSolutionB = true;
pso.plotHistoricB = false;
pso.eachIterationFunction = @recordPlot;
r = pso.start();

function recordPlot(pso)
    axis tight manual % this ensures that getframe() returns a consistent size
    filename = 'PSO_evolution.gif';
    frame = getframe(); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if pso.actualIteration == 1 
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
      imwrite(imind,cm,filename,'gif','WriteMode','append'); 
    end 
end