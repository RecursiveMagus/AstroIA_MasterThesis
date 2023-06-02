

This folder stores the programs for the second part of the thesis (Chapter III).


### Contents

##### Folders:

* The folder ``dataset_generation`` contains the scripts to generate the *training* datasets.
* The folder ``datasets`` contain the testing and training datasets in .csv format.
* The folder ``trained_networks`` contain the Matlab objects with the fully-trained regressors and progressors trained with each different dataset, plus some figures that show the predicions over the testing dataset.

##### Scripts:

Recall that, as stated in Section 3.3 of the thesis document, although all models used are actually regressors (since they predict numbers) we decided to call *progressors* to those models get some initial condition $(x,y,x',y')$ as input and try to predict its first intersection with the Poincaré section, and *regressors* to those models that do the opposite.

* ``progressor_equidistant.m`` - Trains a *progressor* using the equidistant dataset (``PS_train_equidistant.csv``), and shows its predictions over the testing dataset (``PS_testing.csv``).
* ``regressor_equidistant.m`` - Trains a *regressor* using the equidistant dataset, and shows its predictions over the testing dataset.
* ``progressor_random.m`` - Trains a *progressor* using the random dataset (``PS_train_random_42_500.csv``) and shows its predictions over the testing dataset.
* ``regressor_random.m`` - Trains a *regressor* using the random dataset and shows its predictions over the testing dataset.
* ``progressor_limited.m`` - Trains a *progressor* using the limited dataset (``PS_train_limited.csv``) and shows its predictions over the limited testing dataset (``PS_test_for_limited.csv``).
* ``regressor_limited.m`` - Trains a *regressor* using the limited dataset and shows its predictions over the limited testing dataset.





### Replication

To replicate the results detailed in the thesis, copy the appropiate training and testing dataset from the folder ``datasets``, and then run the desired script (``progressor_equidistant.m``, ``regressor_limited.m``, etc).
