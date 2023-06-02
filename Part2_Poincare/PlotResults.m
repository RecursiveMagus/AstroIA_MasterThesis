function PlotResults(real_points, prediction_points, is_progresor)

    x0=10;
    y0=10;
    width=1400;
    height=300 * 3 +50;
    set(gcf,'position',[x0,y0,width,height]);

    if is_progresor
        plot(real_points(:,4), real_points(:,5), '.', MarkerSize = 1, Color = 'blue'); % Actual points
        hold on;
        plot(prediction_points(:,1), prediction_points(:,2), '.', MarkerSize = 1,  Color = 'red'); % Predictions
    else
        plot(real_points(:,1), real_points(:,2), '.', MarkerSize = 1, Color = 'blue'); % Actual points
        hold on;
        plot(prediction_points(:,1), prediction_points(:,2), '.', MarkerSize = 1,  Color = 'red'); % Predictions
    end


end

