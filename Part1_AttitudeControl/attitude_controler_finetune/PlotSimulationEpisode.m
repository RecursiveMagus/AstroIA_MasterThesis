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

    b = [];
    for i = 1:s(3)
        d = dist(quaternion(q1(i), q2(i), q3(i), q4(i)), quaternion(1,0,0,0));
        b = [b;rad2deg(d)];
    end

    subplot(3,1,1);
    plot(q1(:));
    hold on;
    plot(q2(:));
    hold on;
    plot(q3(:));
    hold on;
    plot(q4(:));
    hold on;
    title('Quaternion');
    xlim([0 3000])

    subplot(3,1,2);
    plot(b(:));
    title('Attitude error (º)');
    xlim([0 3000]);

    subplot(3,1,3);
    plot(10*w1(:));
    hold on;
    plot(10*w2(:));
    hold on;
    plot(10*w3(:));
    title('Angular velocity (rad/s)');
    xlim([0 3000]);

    disp(" ");
    disp('Max attitude error (in º) after time step 500 is:');
    disp(max(b(500:end)));

    disp('Max ang. vel. (in º/s) after time step 500 is:');
    max_w1 = max(abs(w1));
    max_w2 = max(abs(w2));
    max_w3 = max(abs(w3));
    max_omega = rad2deg(max([max_w1, max_w2, max_w3]));
    disp(max_omega);


    
    



    



end