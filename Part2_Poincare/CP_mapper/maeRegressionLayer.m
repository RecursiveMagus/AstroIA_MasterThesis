classdef maeRegressionLayer < nnet.layer.RegressionLayer ...
        & nnet.layer.Acceleratable
    % Example custom regression layer with mean-absolute-error loss.
    
    methods
        function layer = maeRegressionLayer(name)
            % layer = maeRegressionLayer(name) creates a
            % mean-absolute-error regression layer and specifies the layer
            % name.
			
            % Set layer name.
            layer.Name = name;

            % Set layer description.
            layer.Description = 'Mean absolute error';
        end
        
        function loss = forwardLoss(layer, Y, T)
            % loss = forwardLoss(layer, Y, T) returns the MAE loss between
            % the predictions Y and the training targets T.

            % Calculate MAE.
            R = size(Y,3);
            meanAbsoluteError = sum(abs(Y-T),3)/R;
    
            % Take mean over mini-batch.
            N = size(Y,4);
            loss = sum(meanAbsoluteError)/N;
        end
        function dLdY = backwardLoss(layer,Y,T)
            % (Optional) Backward propagate the derivative of the loss 
            % function.
            %
            % Inputs:
            %         layer - Output layer
            %         Y     – Predictions made by network
            %         T     – Training targets
            %
            % Output:
            %         dLdY  - Derivative of the loss with respect to the 
            %                 predictions Y        

            loss = forwardLoss(layer, Y, T);
            dLdY = dlgradient(dlarray(loss), layer.Learnables);
        end
    end
end