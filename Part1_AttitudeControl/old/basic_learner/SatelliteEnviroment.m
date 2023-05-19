classdef SatelliteEnviroment < rl.env.MATLABEnvironment

    %% PROPERTIES
    % of both the Enviroment and the actual Satellite
    properties

        %%% Enviromental and simulation properties%%%
        
        % Time interval resolution - will act as the satellite response
        % time, and as the integrator interval (H)
        Ts = 1e-2; % By default, 0.01s

        % Current simulation time:
        t = 0;

        % Max simulation time:
        Max_t = 45;

        % Desired precision:
        desired_precision = 1e-2;



        %%%% Satellite properties %%%%

        % Mass of the satellite:
        Mass = 5.0;

        % Inertia matrix and its inverse:
        I = zeros(3,3); 
        I_inv = zeros(3,3);
        

        % Array to store the torque value in the three body-axis:
        T = [0,0,0]

        % Current angular velocity in the three body-axis.
        omega = [0;0;0];

        % Initial omega
        initial_omega = [0;0;0];


        %%% Training and debugging properties %%%

        % Episode counter (duh.)
        episode_counter = -1;

        % Step counter for each episode:
        steps_done = 0;

        % When the training is done, this property will be set to 'true'
        % This will change the console output.
        train_done = false;

        % Difficulty of each episode. The initial angular velocity vector
        % will be multiplied by this value:
        hardness = 3.0;

        % Maximum training episodes:
        max_episodes = 10;
    end

    %% NECESSARY METHODS
    % Used by Matlab's reinforcement learning trainer
    methods
        function this = SatelliteEnviroment()

            % Constructor function.

            % Initialize Observation information:
            ObservationInfo = rlNumericSpec([3 1]);
            ObservationInfo.Name = 'SatelliteEnviroment States';
            ObservationInfo.Description = 'omega_x, omega_y, omega_z';

            % Initialize Action information:   
            ActionInfo = rlFiniteSetSpec([1:16]);
            ActionInfo.Name = 'SatelliteEnviroment Action';

            % Create a handler to this MATLABEnviroment object:
            this = this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);
        end

        function [Observation,Reward,IsDone,LoggedSignals] = step(this,Action)

            % This function takes a simulation step.



            % Not sure what 'LoggedSignals' is supposed to do, but Matlab requires
            % that the step() function returns it in the form of an array:
            LoggedSignals = [];

            % Calculate the torque from the selected Action:
            this.T = GetTorque(this, Action);

            % Calculate the integration time span:
            tspan = [this.t, this.t + this.Ts];

            % Integrate euler's equation:
            [t_vec, y_vec] = ode45(@(t,y) EulerDynamics(this, t, y), tspan, this.omega);

            % Get the new time and angular velocity:
            this.t = t_vec(end);
            this.omega = y_vec(end,:);
            this.omega = this.omega'; % Transpose


            % The returned observation is the current angular velocity:
            Observation = this.omega;

            % If the inf. norm of the angular velocity vector is less than
            % the desired precision, the current episode is done:
            IsDone = (max(abs(this.omega)) < this.desired_precision);

            % Calculate the reward:
            Reward = GetReward(this, this.omega);

            % Increase the simulation step counter:
            this.steps_done = this.steps_done + 1;

            % If this step is the final step of the episode, display a
            % brief summary of the results:
            if (IsDone || this.steps_done == floor(this.Max_t / this.Ts))
                text_to_start = 'Episode:';
                if (this.train_done)
                    text_to_start = 'Simulation:';
                end
                % Display the initial and final errors (in inf. norm)
                % Ideally, the final error should be close to the value of
                % 'this.desired_precision':
                disp([text_to_start, num2str(this.episode_counter)])
                disp([' || State ini. ', mat2str(this.initial_omega)]);
                disp([' || Err. ini. ', num2str(max(abs(this.initial_omega)))]);
                disp([' || State fin. ', mat2str(this.omega)]);
                disp([' || Err. fin. ', num2str(max(abs(this.omega)))]);
                disp(' ');
            end


        end

        function InitialObservation = reset(this)

            % Advance the global episode counter:
            this.episode_counter = this.episode_counter + 1;

            % Set the steps and current time to zero:
            this.steps_done = 0;
            this.t = 0;

            % Initialize the Inertia Matrix:
            this.Mass = 5;
            this.I = (2/5) * this.Mass * 0.29 * [1,0,0;0,1,0;0,0,1];
            this.I_inv = inv(this.I);
            % Note: In future versions, the Inertia Matrix will be randomized.

            % Generate a random initial condition:
            this.omega = rand(1,3)' * 2 - 1; % Each axis will have a value between [-1,1]

            % If using an unstable Reinf. Learning algorithm (such as DQN)
            % you can uncomment the next line in order to initialize all
            % episodes with a constant angular velocity modulus. This
            % should help with stability:
            %this.omega = this.omega / norm(this.omega);

            % Multiply the initial angular velocity by the hardness
            % parameter.
            this.omega = this.hardness * this.omega;

            % Backup of the initial angular velocity:
            this.initial_omega = this.omega;

            % Value to be returned:
            InitialObservation = this.omega;

        end

    end

    %% ADDITIONAL METHODS
    % Auxiliary functions used to make some additional computations such as
    % calculating rewards, converting actions to actual torque forces, etc.
    methods
        function rw = GetReward(this, w)

            % This function calculates the reward for the current state.
            % Note that in most cases the reward is actually a penalty, and
            % this should incentivize the agent to finish the episode
            % quickly.

            % If the current state terminates the episode (i.e., if the
            % angular velocity is small enough), we offer a large reward.
            % Well done, agent!
            if (max(abs(this.omega)) < this.desired_precision)
                rw = 100 ;

            % We will also add a small incentive if the agent is getting
            % closer to the terminal state, by dividing the penalty by 10.
            elseif norm(this.omega) < this.desired_precision * 10
                rw = -norm(this.omega) / 10;

            % Otherwise, the penalty is the euclidean norm of the current
            % angular velocity.
            else
                rw = -norm(this.omega);
            end
        end


        function torque = GetTorque(this, action_index)

            % Given an integer representing an action, this function
            % returns its corresponding torque.
            % NOTE: I should find a way to make this function prettier.

            % List of possible torques:
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
                [0.001,0,0],
                [-0.001,0,0],
                [0,0.001,0],
                [0,-0.001,0],
                [0,0,0.001],
                [0,0,-0.001]
                ]; 

            % Return the torque whose index in the previous list correspond
            % to the 'action_index' argument.
            torque = T_list(action_index, :);

            
        end

        function [y_out] = EulerDynamics(this, t, y)

            % Euler rigid body rotation equations
            w = y(1:3); % In a future version, y will also include the orientation

            % Calculate the angular acceleration and return it:
            d_w = this.I_inv * (this.T' + cross(-w, (this.I * w) ) );
            y_out = [d_w];

        end

    end



end