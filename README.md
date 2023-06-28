# AstroIA_MasterThesis
***"Solving classical astrodynamics problems by means of Machine Learning approaches"***


<a name="readme-top"></a>



<!-- ABOUT THE PROJECT -->
## About The Project

This is the code repository for my Master's Thesis "Solving classical astrodynamics problems by means of Machine Learning approaches" carried out during the final semester of the MSc in Data Science at the University of Girona.

The main goal of this master’s thesis is to analize and explore the usefulness of Machine Learning and AI tools applied to two classical problems in the field of Dynamical Systems, more concretely in Celestial Mechanics and Astrodynamics, and classic atomic physics: the spacecraft attitude (i.e. orientation) control problem and the approximation of the Poincaré map in a dynamical system of a Hydrogen molecule under a microwave field.

##### 1. Attitude control problem

The attitude control problem has the main goal of finding the optimal sequence of movements (usually in the form of *torques* generated with weak impulse thrusters and/or *magnetorquers*) that allows for the correction of the angular velocity and orientation of a space artifact in order to reach a desired final attitude. In this thesis, this problem has been formulated as a reinforcement learning problem where an agent (the "brain" of the satellite) tries to learn an optimal policy (strategy) that allows it to decide which torque should be applied at each moment in order to maximize a reward function inversely proportional to the attitude error. Several experiments have been performed, using different satellite shapes and with/without environmental perturbations. The results and programs can be found in the folder ``Part1_AttitudeControl``.

##### 2. Approximation of the Poincaré map

In the field Dynamical Systems (in particular, Celestial Mechanics or Astrodynamics, Poincaré maps are a key mathematical tool that helps to study the dynamics around a specific region of the phase space, in particular, around stable periodic orbits. For example, when considering an orbital system generated by two large mass objects (such as the system created by our planet and the Moon), there are five positions in which a small object placed there would remain stationary with respect to the large objects. These positions are known as Lagrange points or Libration points, and are usually surrounded by periodic orbits that are useful for those missions that require the deployment of an stationary artifact (such as an antenna or a radiotelescope). To have a good knowledge of these regions is crucial for the design of successful space missions.

In the second part of this thesis we want to approximate the Poincaré map of a dynamical system using an artificial neural network in two different ways. More concretely, we want to build a neural network that is able to reproduce a Poincaré map, first forwards in time, second backwards in time.
The original idea was to work with the dynamical system of the restricted three body problem (RTBP), but we decided to begin our first tests with the CP problem (the study of the movement of a Hydrogen atom when subject to a microwave field). However, the poor results and inaccuracy obtained during this second part has prevented us from progressing further. Nevertheless, the programs have been included in this repository, in the folder ``Part2_Poincare``.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTENTS -->
# Project tree

This repository is divided in the following directories:

    .
    ├── Part1_AttitudeControl	# Programs of the 1st part of the thesis (attitude control)
    │   ├── Experiment_I		# Angular velocity control
    │   ├── Experiment_IIa		# Full attitude control (microsatellite)
    │   ├── Experiment_IIb		# Full attitude control (cubesat)
    │   ├── Experiment_III		# Full attitude control + perturbations
    │   └── Extra			# Extra experiment, not included in the thesis document.
    ├── Part2_Poincare		# Programs for the 2nd part of the thesis (poincare map approx.)
    │   ├── dataset_generation	# Scripts to create the training datasets.
    │   ├── datasets		# Training and testing datasets (.csv)
	│	└── trained_networks	# Fully trained regressors/progressors + some figures.
	│		├── equidistant		# Results obtained w/ equidistant dataset.
	│		├── limited_section	# Results obtained w/ limited dataset.
	│		└── random		# Results obtained w/ random dataset.
    ├── Extra_videos			# Videos showing the simulation results.
    └── Thesis_document			# Contains the full thesis document in .pdf format.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

Simply download the scripts on your computer and run them using Matlab. Please, take a moment to read the README files in each folder.

### Prerequisites

Code has been developed using Matlab 2022b and 2023a. You will need the following toolboxes:

* :brain: Deep Learning Toolbox
* :robot: Reinforcement Learning Toolbox
* :desktop_computer: Parallel Computing Toolbox






<p align="right">(<a href="#readme-top">back to top</a>)</p>






<!-- LICENSE -->
## License

Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg



<!-- CONTACT -->
## Contact

Isaac de Palau (RecursiveMagus) - idepalau(funny-A-symbol)gmail(little-point)com

If you have any questions regarding the programs or the contents of the thesis, do not hesitate to write me an email. I don't bite (usually).

<p align="right">(<a href="#readme-top">back to top</a>)</p>


