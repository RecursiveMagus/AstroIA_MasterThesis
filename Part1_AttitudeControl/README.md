

This folder contains the programs and results of each Experiment detailed in Chapter II, Section 2.4 of the thesis document.

### Experiment summary

* **Experiment I** - we have trained a controller to stabilize the angular velocity of the satellite, without taking into account the orientation (quaternion).
* **Experiment IIa / IIb** - we have trained the agent to control the full attitude of the satellite (orientation and ang. vel.). We have divided this experiment into two sub-experiments, each one with a different inertia matrix configuration (a microsatellite and a cubesat).
* **Experiment III** - we have trained a controller capable of stabilizing the full attitude of a satellite in the presence of perturbations. These perturbations take the form of small torques added at each integration time step, and small random changes to the inertia matrix at the beginning of each training episode.
* **Extra** - This extra experiment was a kind suggestion by Dr. Josep Masdemont from UPC. The idea was to encode the mass and aproximate size of the inertia tensor into the state vector that is feeded into the actor/critic neural networks, thus providing the agent with the tools to estimate the shape of the spacecraft and -in theory- allowing it to control multiple classes of satellites. The experiment has not been included into the thesis document since the results have not been good enough, and also because I did not have time to polish the hyperparameters. However, I believe that with more training episodes, longer simulation times, and deeper networks for the agent and critic, this experiment could yield very promising results.


### Contents

Each experiment folder contains the following:

* ``PPO_test.m`` - Creates the actor/critic networks, the reinforcement learning agent, and performs the training process using the PPO algorithm. After the training process is done, it performs 25 simulation episodes without further training (i.e. without modifying the parameters of the actor/critic networks).
* ``SatelliteEnviroment.m`` - Models the "world" with which the satellite interacts. Basically, it randomizes the initial conditions of each training episode and integrates Euler's equations for rigid body dynamics.
* ``PlotSimulationEpisode.m`` - Auxiliary function to plot the detailed results of a simulation episode.
* ``PlotTrainingProgress.m`` - Auxiliary function to plot the training process of the agent during all training episodes.
* ``agent.mat`` - Matlab object that contains the fully-trained agent. 
* ``trainingStats.mat`` - Matlab object that contains the full-results of each training episode.
* ``experience.mat`` - Matlab object that contains the results of each simulation done after the trianing process.
* In addition to this, each folder contains images of the figures included in the thesis document regarding the training process and simulation results. These figures have been created using the ``PlotSimulationEpisode.m`` and ``PlotTrainingProgress.m`` scripts.



Note that the script ``PPO_test.m`` also sets some of the parameters of the training enviroment, while others remain unchanged. This should be adressed in future versions and the parameters of the enviroment should be *all* set in a third script.



### Replication

To replicate the experiments from scratch (including the training process), you need to do the following:

* Make sure you have a Matlab Parallel pool configured and enabled. I recommend using, at least, 4-6 workers.
* Have ``PPO_test.m`` and ``SatelliteEnviroment.m`` in the same folder.
* Run ``PPO_test.m``. This will initiate the training process, which may take a few hours, or even a day.
* Go grab a coffe and maybe watch a movie or two. This will take a while.







