

This folder stores the programs necessary to generate the training datasets.

* ``CP_field.m`` - Evaluates the equations of the CP problem on a given point. Required by the integrator (ode78).
* ``orbitEvents.m`` - Checks if a given point belongs to the Poincaré section.
* ``IntegrateCP.m`` - Generates the equidistant dataset (``PS_train_equidistant.csv``).
* ``IntegrateCP_limited.m`` - Generates the limited dataset (``PS_train_limited.csv``).
* ``IntegrateCP_random.m`` - Generates the random dataset (``PS_train_random_42_500.csv``). Please note that the dataset name also includes the value of the random seed and the number of randomized points.
