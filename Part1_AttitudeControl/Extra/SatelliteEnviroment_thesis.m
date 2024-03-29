classdef SatelliteEnviroment_thesis < rl.env.MATLABEnvironment

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
        Max_t = 60;

        % Perturbation torque properties.
        perturb_mu = 0; % Mean
        perturb_sig = 1e-3; % Standard deviation



        %%%% Satellite properties %%%%

        % Mass of the satellite:
        Mass = 5.0;
        Side = 1;
        max_mass = 0;
        max_side = 0;
        min_mass = 0;
        min_side = 0;

        % Inertia matrix and its inverse:
        I = zeros(3,3); 
        I_inv = zeros(3,3);
        

        % Array to store the torque value in the three body-axis:
        T = [0,0,0]

        % Variables to store current angular velocity and orientation:
        omega = [0;0;0];
        q = quaternion(1,0,0,0);

        % Desired orientation:
        q_desired = quaternion(1,0,0,0);

        % Initial orientation and angular velocity backup variables:
        initial_omega = [0;0;0];
        initial_q = quaternion(1,0,0,0);

        % Scaling factor for the angular velocity observations:
        MAX_W = 10;


        %%% Training and debugging properties %%%

        % Episode counter (duh.)
        episode_counter = -1;

        % Step counter for each episode:
        steps_done = 0;

        % When the training is done, this property will be set to 'true'
        % This will change the console output:
        train_done = false;

        % Maximum training episodes:
        max_episodes = 10;
    end

    %% NECESSARY METHODS
    % Used by Matlab's reinforcement learning trainer
    methods
        function this = SatelliteEnviroment_thesis()

            % Constructor function.

            % Initialize Observation information:
            ObservationInfo = rlNumericSpec([9 1]);
            ObservationInfo.Name = 'SatelliteEnviroment States';
            ObservationInfo.Description = 'q0, q1, q2, q3, omega_x, omega_y, omega_z, Mass, Side';

            % Initialize Action information:   
            ActionInfo = rlFiniteSetSpec([1:31]);
            ActionInfo.Name = 'SatelliteEnviroment Action';

            % Create a handler to this MATLABEnviroment object:
            this = this@rl.env.MATLABEnvironment(ObservationInfo,ActionInfo);
        end


        function [Observation,Reward,IsDone,LoggedSignals] = step(this,Action)
            LoggedSignals = [];
            IsDone = false;

            % This function takes a simulation step.



            % Calculate the torque from the selected Action:
            this.T = GetTorque(this, Action);
            

            % Integrate Euler's equation(s):
            tspan = [this.t, this.t + this.Ts];
            [t_vec, y_vec] = ode45(@(t,y) EulerDynamics(this, t,y), tspan, [compact(this.q)'; this.omega]);

            % Get the new time, orientation and angular velocity
            this.t = t_vec(end);
            new_state = y_vec(end,:);
            this.q = normalize(quaternion(new_state(1:4)));
            this.omega = new_state(5:7)';


            % The returned observation is the current [q;w]:
            Observation = [compact(this.q)'; this.omega/this.MAX_W; this.Mass / this.max_mass; this.Side / this.max_side];

            % Calculate the reward:
            Reward = GetReward(this);

            % If we are simulating and the attitude is less than the
            % precision, we stop:
            if this.train_done && abs(dist(this.q, this.q_desired)) <= 1e-3 && max(abs(this.initial_omega)) <= 1e-3
                IsDone = true;
            end

            % Increase the simulation step counter:
            this.steps_done = this.steps_done + 1;

            
            % If this step is the final step of the episode, display a
            % brief summary of the results.
            % Please note that this results will not be shown during the
            % training episodes if we are training the agent in parallel
            % (since, for some reason, Matlab seems to disable the 'disp' 
            % method when using parallel computing).
            if (this.steps_done == floor(this.Max_t / this.Ts))
                text_to_start = 'Episode:';
                if (this.train_done)
                    text_to_start = 'Simulation:';
                end
                % Display the initial and final errors (in inf. norm)
                % Ideally, the final error should be close to the value of
                % 'this.desired_precision':
                disp([text_to_start, num2str(this.episode_counter)])
                disp([' || Err. ini. w = ', num2str(max(abs(this.initial_omega)))]);
                disp([' || Err. ini. q = ', num2str(dist(this.initial_q, this.q_desired))]);
                disp([' || Err. fin. w = ', num2str(max(abs(this.omega)))]);
                disp([' || Err. fin. q = ', num2str(dist(this.q, this.q_desired))]);
                disp(' ');
            end
            


        end

        function InitialObservation = reset(this)

            % Advance the global episode counter:
            this.episode_counter = this.episode_counter + 1;

            % Set the steps and current time to zero:
            this.steps_done = 0;
            this.t = 0;

            % Initialize a random Inertia Matrix:
            this.max_mass = 25;
            this.min_mass = 5;
            this.max_side = 5;
            this.min_side = 0.5;
            this.Mass = (this.max_mass-this.min_mass).*rand(1) + this.min_mass;
            this.Side = (this.max_side-this.min_side).*rand(1) + this.min_side;
            this.I = this.Mass * (this.Side * this.Side / 6) * [1,0,0;0,1,0;0,0,1]; 

            % Add a perturbation:
            Pert = rand(3,3) * 0.1; % Generate a small perturbation
            Pert = Pert - tril(Pert,-1) + triu(Pert,1)'; % Make it symmetrical, by copying the upper triangle
            this.I = this.I + Pert;

            % Calculate the inverse:
            this.I_inv = inv(this.I);

            % Generate a random initial condition:
            this.omega = normrnd(0,1.5, [1,3])';
            this.q_desired = quaternion(1,0,0,0);
            this.q = randrot(1);

            % Backup of the initial angular velocity and orientation:
            this.initial_omega = this.omega;
            this.initial_q = this.q;
            InitialObservation = [compact(this.q)'; this.omega / this.MAX_W; this.Mass / this.max_mass; this.Side / this.max_side];

        end

    end

    %% ADDITIONAL METHODS
    % Auxiliary functions used to make some additional computations such as
    % calculating rewards, converting actions to actual torque forces, etc.
    methods
        function reward = GetReward(this)

            %rq = abs(dist(this.q, this.q_desired));%abs(q2) + abs(q3) + abs(q4);
            rw = abs(this.omega(1)) + abs(this.omega(2)) + abs(this.omega(3));

            %reward = -rq -rw;

            compact_q = compact(this.q);%abs(dist(this.q, this.q_desired));
            rq = abs(compact_q(2)) + abs(compact_q(3)) + abs(compact_q(4));
            %rw = norm(this.omega);
            reward = - 3 * rq - rw;




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

            % Return the torque whose index in the previous list correspond
            % to the 'action_index' argument.
            torque = T_list(action_index, :);
            torque = torque + normrnd(this.perturb_mu,this.perturb_sig,[1,3]);

            
        end

        function [y_out] = EulerDynamics(this,t,y)

            % Euler rigid body rotation equations

            qt = quaternion(y(1), y(2), y(3), y(4));
            w = [y(5); y(6); y(7)]; 

            d_q = compact(0.5 * qt * quaternion(0, w(1), w(2), w(3)));
            d_w = this.I_inv * (this.T' + cross(-w, (this.I * w) ) );

            y_out = [d_q'; d_w];

        end

    end



end