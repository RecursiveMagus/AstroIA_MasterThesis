function PlotSimulationEpisode(experience, index, zoom)

    state_history = experience(index).Observation.SatelliteEnviromentStates.Data;
    s = size(state_history);
    


    w1 = state_history(1,1,:);
    w2 = state_history(2,1,:);
    w3 = state_history(3,1,:);



    x0=10;
    y0=10;
    width=1400;
    height=300 * 3 +50;
    set(gcf,'position',[x0,y0,width,height]);


    plot(10*w1(:), LineWidth=2);
    hold on;
    plot(10*w2(:), LineWidth=2);
    hold on;
    plot(10*w3(:), LineWidth=2);
    title('Angular velocity (rad/s)');
    xlim([zoom 3000]);
    xlabel('Time step');
    ylabel('Ang. vel. (rad/s)');
    legend({'X axis','Y axis', 'Z axis'},'Location','northeast');


    
    



    



end