function PlotTrainingProgress(trainingResults)

    episodeReward = trainingResults.EpisodeReward;
    episodeIndex = trainingResults.EpisodeIndex;
    averageReward = trainingResults.AverageReward;
    Q0 = trainingResults.EpisodeQ0;

    n_subplots = 2;
    zoom = 1000;

    x0=10;
    y0=10;
    width=800 * n_subplots +50;
    height=600 +50;
    set(gcf,'position',[x0,y0,width,height]);
    
    
    subplot(1, n_subplots, 1);
    plot(episodeIndex, episodeReward, '-', Color = "#8BC7FF", LineWidth=3, Marker = "None");
    ylim([-5e4 2e3]);
    grid on;
    hold on;
    plot(episodeIndex, averageReward, '-', Color = "#0072BD", LineWidth=3.5, Marker = "None");
    xlabel('Training episode');
    ylabel('Total reward sum'); 
    legend({'Episode reward','Average reward (window 100)'},'Location','southeast');


    subplot(1, n_subplots, 2);
    plot(episodeIndex(zoom:end), episodeReward(zoom:end), '-', Color = "#8BC7FF", LineWidth=3, Marker = "None");
    hold on;
    grid on;
    plot(episodeIndex(zoom:end), averageReward(zoom:end), '-', Color = "#0072BD", LineWidth=3.5, Marker = "None");
    xlabel('Training episode');
    ylabel('Total reward sum'); 
    legend({'Episode reward','Average reward (window 100)'},'Location','southeast');
    


end

