import sys
sys.path.insert(1, '../ODE_solver/')

import numpy as np
import random
from ODE_solver import RungeKuttaFehlberg45, RungeKuttaFehlberg78

class SatelliteEnviroment():
    def __init__(self):
        self.T_list = [
            [0.0,0.0,0.0],
            [0.01,0.0,0.0],
            [-0.01,0.0,0.0],
            [0.01,0.0,0.0],
            [0.0,-0.01,0.0],
            [0.0,0.0,-0.01],
            [0.0,0.0,0.01]
        ]

        self.n_actions = len(self.T_list)

    def sample_random_action(self):
        return random.sample(range(self.n_actions), 1)[0]

    def reset(self, H = 1e-4):
        self.T = self.T_list[0]

        # Set inertia tensor: Sputnik!
        self.I = (2.0/5.0) * 4 * 0.29 * np.array([[1,0,0],[0,1,0],[0,0,1]])
        self.I_inv = np.linalg.inv(self.I)

        self.w = np.array([0.0,0.0,0.0])
        self.w[0] = random.uniform(-2.5, 2.5)
        self.w[1] = random.uniform(-2.5, 2.5)
        self.w[2] = random.uniform(-2.5, 2.5)
        self.w_desired = np.array([0.0,0.0,0.0])

        self.H = H

        self.t = 0.0

        return self.w, []

    def calculate_reward(self):
        reward = 0
        """if np.abs(self.w[0]) <= 1e-2:
            reward += 100
        if np.abs(self.w[1]) <= 1e-2:
            reward += 100
        if np.abs(self.w[2]) <= 1e-2:
            reward += 100
        if np.abs(self.w[0]) <= 1e-4:
            reward += 500
        if np.abs(self.w[1]) <= 1e-4:
            reward += 500
        if np.abs(self.w[2]) <= 1e-4:
            reward += 500"""

        #return reward + 1.0 / (np.sqrt(2.0 * np.pi)) * np.exp(-0.5 * np.linalg.norm(self.w))
        return -1.0 * np.linalg.norm(self.w, 2)

    def step(self, action):
        self.T = self.T_list[action]
        t, w = RungeKuttaFehlberg45(self.f, self.t, self.w, self.H, 1e-14)

        self.w = w
        self.t = t

        trunc = (self.t >= 20)
        term = (np.linalg.norm(self.w, 1) <= 1e-5)


        return self.w, self.calculate_reward(), term, trunc

    def f(self,t,w):
        #print("T = ", self.T)
        trm1 = np.array(self.T) - np.cross( -w , np.matmul(self.I, w) )
        return np.matmul(self.I_inv , trm1)
