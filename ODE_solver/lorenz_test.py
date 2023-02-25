import numpy as np
from ODE_solver import  RungeKuttaFehlberg78, RungeKuttaFehlberg45
import matplotlib.pyplot as plt
import pandas as pd


def f(t,y):
    ro = 28.0
    sigma = 10.0
    beta = 8.0 / 3.0



    trm1 = sigma*(y[1]-y[0])  # dx / dt
    trm2 = y[0] * (ro - y[2]) - y[1] # dy / dt
    trm3 = y[0] * y[1] - beta * y[2]
    return np.array([trm1, trm2, trm3])

# We want to write each calculated point on a file, in order to plot them
# when the main loop is finished.
fitxer = open("points.txt", "w")

# Initial point:
y = np.array([1,1,1])

# Total size for each "step":
H = 1e-4

#Initial time:
t = 0

while t < 300:

    # Integrate between y and y+H:
    t, y = RungeKuttaFehlberg78(f, t, y, H, 1e-11)

    # Uncomment the next line to print the information of each point on screen:
    print(t, " | ", y )

    # We save the point (x,y) in the 'points.txt' file:
    fitxer.write(str(y[0]) + "," + str(y[2]) + "\n")

# Close the points file:
fitxer.close()

# Using pandas, we open the points file and store its contents inside a DF:
data = pd.read_csv("points.txt", sep=",", header = None)
#data = pd.DataFrame(data)

# We draw a scatterplot with the contents of the DF:
x = data[0]
z = data[1]
plt.scatter(x,z, H)
plt.show()
