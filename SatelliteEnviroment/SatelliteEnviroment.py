import sys
sys.path.insert(1, '../ODE_solver/python/')

import numpy as np
import random
from ODE_solver import RungeKuttaFehlberg45, RungeKuttaFehlberg78

class SatelliteEnviroment():
    def __init__(self):

        # List of possible actions for the satellite:
        self.T_list = [
            [0.0,0.0,0.0],
            [0.01,0.0,0.0],
            [-0.01,0.0,0.0],
            [0.0,0.01,0.0],
            [0.0,-0.01,0.0],
            [0.0,0.0,-0.01],
            [0.0,0.0,0.01],
            [0.001,0.0,0.0],
            [-0.001,0.0,0.0],
            [0.0,0.001,0.0],
            [0.0,-0.001,0.0],
            [0.0,0.0,-0.001],
            [0.0,0.0,0.001],
			[0.1,0.0,0.0],
            [-0.1,0.0,0.0],
            [0.0,0.1,0.0],
            [0.0,-0.1,0.0],
            [0.0,0.0,-0.1],
            [0.0,0.0,0.1],
            [1.0,0.0,0.0],
            [-1.0,0.0,0.0],
            [0.0,1.0,0.0],
            [0.0,-1.0,0.0],
            [0.0,0.0,-1.0],
            [0.0,0.0,1.0],

        ]

        # Number of possible actions (i.e. len of the previous list of vectors)
        self.n_actions = len(self.T_list)

    def sample_random_action(self):
        return random.sample(range(self.n_actions), 1)[0]

    def reset(self, H = 1e-4, tmax = 60.0, perturbation_std = 1e-4, error_tolerance = 1e-4):
        self.T = self.T_list[0]

        self.mass = 0
        self.I = np.array([[2.0257,0.6498,1.1226],[0.6498,0.7998,0.1833],[1.1226,0.1833,1.2753]])
        self.I_inv = np.linalg.inv(self.I)

        self.w = np.array([0.0,0.0,0.0])
        self.w[0] = random.uniform(-1, 1)
        self.w[1] = random.uniform(-1, 1)
        self.w[2] = random.uniform(-1, 1)
        self.w_desired = np.array([0.0,0.0,0.0])

        self.w_ant = self.w

        self.H = H

        self.t = 0.0
        self.tmax = tmax

        self.perturbation_std = perturbation_std
        self.error_tolerance = error_tolerance

        return self.w, []

    def calculate_reward(self):
        reward = 0

        reward = - np.exp(np.linalg.norm(self.w, 2))


        if np.max(np.abs(self.w)) < self.error_tolerance:
                reward += 100

        return reward


    def step(self, action):
        self.T = self.T_list[action] + np.random.normal(0, self.perturbation_std, 3)
        t, w = RungeKuttaFehlberg45(self.f, self.t, self.w, 1e-3, 1e-10)#self.H, 1e-10)


        self.T = np.random.normal(0, self.perturbation_std, 3)#self.T_list[0]
        t, w = RungeKuttaFehlberg45(self.f, t, w, self.H - 1e-3, 1e-10)

        self.w_ant = self.w
        self.w = w
        self.t = t

        trunc = (self.t >= self.tmax)
        term = (np.max(np.abs(self.w)) < self.error_tolerance)

        return self.w, self.calculate_reward(), term, trunc

    def f(self,t,w):
        trm1 = np.array(self.T) - np.cross( w , np.matmul(self.I, w) )
        return np.matmul(self.I_inv , trm1)
