function PlotSimulationEpisode(experience, index)

    state_history = experience(index).Observation.SatelliteEnviromentStates.Data;
    s = size(state_history);

    

    q1 = state_history(1,1,:);
    q2 = state_history(2,1,:);
    q3 = state_history(3,1,:);
    q4 = state_history(4,1,:);


    w1 = state_history(5,1,:);
    w2 = state_history(6,1,:);
    w3 = state_history(7,1,:);

    subplot(2,1,1);
    plot(q1(:));
    hold on;
    plot(q2(:));
    hold on;
    plot(q3(:));
    hold on;
    plot(q4(:));
    hold on;

    subplot(2,1,2);
    plot(10*w1(:));
    hold on;
    plot(10*w2(:));
    hold on;
    plot(10*w3(:));



end