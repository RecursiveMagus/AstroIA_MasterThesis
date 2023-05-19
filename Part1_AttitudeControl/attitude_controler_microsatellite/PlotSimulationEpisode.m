function PlotSimulationEpisode(experience, index, zoom)

    state_history = experience(index).Observation.SatelliteEnviromentStates.Data;
    s = size(state_history);
    

    q1 = state_history(1,1,:);
    q2 = state_history(2,1,:);
    q3 = state_history(3,1,:);
    q4 = state_history(4,1,:);


    w1 = state_history(5,1,:);
    w2 = state_history(6,1,:);
    w3 = state_history(7,1,:);

    b = [];
    for i = 1:s(3)
        d = dist(quaternion(q1(i), q2(i), q3(i), q4(i)), quaternion(1,0,0,0));
        b = [b;rad2deg(d)];
    end

    x0=10;
    y0=10;
    width=1400;
    height=300 * 3 +50;
    set(gcf,'position',[x0,y0,width,height]);

    subplot(3,1,1);
    plot(q1(:), LineWidth=2);
    hold on;
    plot(q2(:), LineWidth=2);
    hold on;
    plot(q3(:), LineWidth=2);
    hold on;
    plot(q4(:), LineWidth=2);
    hold on;
    title('Quaternion');
    xlim([zoom 3000])
    xlabel('Time step');
    ylabel('Quaternion');
    legend({'q1','q2', 'q3','q4'},'Location','northeast');

    subplot(3,1,2);
    plot(b(:), LineWidth=2);
    title('Attitude error (º)');
    xlim([zoom 3000]);
    xlabel('Time step');
    ylabel('Degrees (º)');

    subplot(3,1,3);
    plot(10*w1(:), LineWidth=2);
    hold on;
    plot(10*w2(:), LineWidth=2);
    hold on;
    plot(10*w3(:), LineWidth=2);
    title('Angular velocity (rad/s)');
    xlim([zoom 3000]);
    xlabel('Time step');
    ylabel('Ang. vel. (rad/s)');
    legend({'X axis','Y axis', 'Z_axis'},'Location','northeast');


    
    



    



end