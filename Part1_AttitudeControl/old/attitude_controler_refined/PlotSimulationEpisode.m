function PlotSimulationEpisode(experience, index)

    state_history = experience(index).Observation.SatelliteEnviromentStates.Data;
    s = size(state_history);

    action_history = experience(index).Action.SatelliteEnviromentAction.Data;

    T_list = [
                [0,0,0], 
                [1,0,0], 
                [-1,0,0],
                [0,1,0],
                [0,-1,0],
                [0,0,1],
                [0,0,-1],
                [0.1,0,0],
                [-0.1,0,0],
                [0,0.1,0],
                [0,-0.1,0],
                [0,0,0.1],
                [0,0,-0.1],
                [0.01,0,0],
                [-0.01,0,0],
                [0,0.01,0],
                [0,-0.01,0],
                [0,0,0.01],
                [0,0,-0.01],
                [0.001,0,0],
                [-0.001,0,0],
                [0,0.001,0],
                [0,-0.001,0],
                [0,0,0.001],
                [0,0,-0.001]
                [0.0001,0,0],
                [-0.0001,0,0],
                [0,0.0001,0],
                [0,-0.0001,0],
                [0,0,0.0001],
                [0,0,-0.0001]
                ]; 

    

    q1 = state_history(1,1,:);
    q2 = state_history(2,1,:);
    q3 = state_history(3,1,:);
    q4 = state_history(4,1,:);


    w1 = state_history(5,1,:);
    w2 = state_history(6,1,:);
    w3 = state_history(7,1,:);

    subplot(3,1,1);
    plot(q1(:));
    hold on;
    plot(q2(:));
    hold on;
    plot(q3(:));
    hold on;
    plot(q4(:));
    hold on;
    xlim([0 3000])

    subplot(3,1,2);
    plot(10*w1(:));
    hold on;
    plot(10*w2(:));
    hold on;
    plot(10*w3(:));
    xlim([0 3000])

    subplot(3,1,3);
    plot(T_list(action_history(:),:));
    xlim([0 3000])


    



end