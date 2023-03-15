from SatelliteEnviroment import SatelliteEnviroment
import math
import random
import matplotlib
import matplotlib.pyplot as plt
from collections import namedtuple, deque
from itertools import count
import numpy as np

import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F

env = SatelliteEnviroment()

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
if torch.cuda.is_available():
    print("We are using CUDA!")

plt.ion()


Transition = namedtuple('Transition', ('state', 'action', 'next_state', 'reward'))

class ReplayMemory(object):
    def __init__(self, capacity):
        self.memory = deque([], maxlen=capacity)

    def push(self, *args):
        self.memory.append(Transition(*args))

    def sample(self, batch_size):
        return random.sample(self.memory, batch_size)

    def __len__(self):
        return len(self.memory)


class DQN(nn.Module):
    def __init__(self, n_observations, n_actions):
        super(DQN,self).__init__()
        self.layer1 = nn.Linear(n_observations, 1024)
        self.layer2 = nn.Linear(1024,2048)
        self.layer3 = nn.Linear(2048, n_actions)

    def forward(self, x):
        x = F.relu(self.layer1(x))
        x = F.relu(self.layer2(x))
        return self.layer3(x)
TAU = 0.005
GAMMA = 0.99
BATCH_SIZE = 128
EPS_START = 0.99
EPS_END = 0.05
EPS_DECAY = 1000
LR = 1e-4 #Learning rate



n_actions = env.n_actions

state, info = env.reset(1e-4)
n_observations = len(state)

policy_net = DQN(n_observations, n_actions).to(device)
target_net = DQN(n_observations, n_actions).to(device)
target_net.load_state_dict(policy_net.state_dict()) #We copy 'policy_net' parameters into 'target_net'

optimizer = optim.AdamW(policy_net.parameters(), lr = LR, amsgrad = True)
memory = ReplayMemory(10000)

steps_done = 0





def select_action(state):
    global steps_done
    sample = random.random()
    eps_threshold = EPS_END + (EPS_START-EPS_END) * math.exp(-1 * steps_done / EPS_DECAY)
    steps_done += 1
    if sample > eps_threshold:
        return policy_net(state).max(1)[1].view(1,1)
    else:
        return torch.tensor([[env.sample_random_action()]], device=device, dtype=torch.long)


###TRAINING LOOP

def optimize_model():
    if len(memory) < BATCH_SIZE:
        return
    transitions = memory.sample(BATCH_SIZE)
    batch = Transition(*zip(*transitions))

    non_final_mask = torch.tensor(tuple(map(lambda s: s is not None, batch.next_state)), device=device, dtype = torch.bool)

    non_final_next_states = torch.cat([s for s in batch.next_state if s is not None])

    state_batch = torch.cat(batch.state)
    action_batch = torch.cat(batch.action)
    reward_batch = torch.cat(batch.reward)

    state_action_values = policy_net(state_batch).gather(1, action_batch)

    next_state_values = torch.zeros(BATCH_SIZE, device = device)
    with torch.no_grad():
        next_state_values[non_final_mask] = target_net(non_final_next_states).max(1)[0]

    expected_state_action_values = (next_state_values * GAMMA) + reward_batch

    criterion = nn.SmoothL1Loss()
    loss = criterion(state_action_values, expected_state_action_values.unsqueeze(1))

    optimizer.zero_grad()
    loss.backward()

    torch.nn.utils.clip_grad_value_(policy_net.parameters(), 100)
    optimizer.step()

fitxer = open("results_train.txt", "w")
num_episodes = 500

for i_episode in range(num_episodes):
    # Initialize the environment and get it's state
    H = 1e-2
    state, info = env.reset(H, tmax = 120)
    ini_state = state
    total_reward = 0
    state = torch.tensor(state, dtype=torch.float32, device=device).unsqueeze(0)
    for t in count():
        action = select_action(state)
        observation, reward, terminated, truncated = env.step(action.item())
        done = terminated or truncated
        total_reward += reward
        reward = torch.tensor([reward], device=device)


        if terminated:
            next_state = None
        else:
            next_state = torch.tensor(observation, dtype=torch.float32, device=device).unsqueeze(0)

        # Store the transition in memory
        memory.push(state, action, next_state, reward)

        # Move to the next state
        state = next_state

        # Perform one step of the optimization (on the policy network)
        optimize_model()

        # Soft update of the target network's weights
        # θ′ ← τ θ + (1 −τ )θ′
        target_net_state_dict = target_net.state_dict()
        policy_net_state_dict = policy_net.state_dict()
        for key in policy_net_state_dict:
            target_net_state_dict[key] = policy_net_state_dict[key]*TAU + target_net_state_dict[key]*(1-TAU)
        target_net.load_state_dict(target_net_state_dict)

        if done:
            print("---Ep.", i_episode, "| m:", env.mass, "| In. Att: ", ini_state, "| Fin. Att: ", env.w, "| Avg. Rew: ", total_reward / t, "| t: ", env.t)#, "| Avg reward =", total_reward / (20.0 / H))
            fitxer.write(str(i_episode) + ";" + str(ini_state[0]) + ";" + str(ini_state[1]) + ";" + str(ini_state[2]) + ";" + str(env.w[0]) + ";" + str(env.w[1]) + ";" + str(env.w[2]) + ";" + str(total_reward / t) + ";" + str(env.t) + "\n")
            break

print('Complete')
fitxer.close()

print("\n\n----------------\nTesting phase.")
for i_episode in range(25):
    H = 1e-2
    state, info = env.reset(H, tmax = 120)
    ini_state = state
    state = torch.tensor(state, dtype=torch.float32, device=device).unsqueeze(0)
    for t in count():
        action = select_action(state)
        observation, _, terminated, truncated = env.step(action.item())

        state = torch.tensor(observation, dtype=torch.float32, device=device).unsqueeze(0)

        if terminated or truncated:
            print("---> Test Ep.", i_episode, "| In. Att: ", ini_state, "| Fin. Att: ", env.w, "| t: ", env.t)
            break
