import numpy as np
from ODE_solver import  RungeKuttaFehlberg78, RungeKuttaFehlberg45
import matplotlib.pyplot as plt
import pandas as pd


def f(t,y):
    # Brusselator equation
    A = 1
    B = 2.5

    trm1 = A + (y[0]**2)*(y[1]) -B * y[0] - y[0]
    trm2 = B * y[0] - (y[0] ** 2) * y[1]
    return np.array([trm1, trm2])

# We want to write each calculated point on a file, in order to plot them
# when the main loop is finished.
fitxer = open("points.txt", "w")

# Initial point:
y = np.array([1,0])

# Total size for each "step":
H = 1e-4

#Initial time:
t = 0

while t < 50:

    # Integrate between y and y+H:
    t, y = RungeKuttaFehlberg78(f, t, y, H, 1e-14)

    # Uncomment the next line to print the information of each point on screen:
    print(t, " | ", y )

    # We save the point (x,y) in the 'points.txt' file:
    fitxer.write(str(y[0]) + "," + str(y[1]) + "\n")

# Close the points file:
fitxer.close()

# Using pandas, we open the points file and store its contents inside a DF:
data = pd.read_csv("points.txt", sep=",", header = None)
#data = pd.DataFrame(data)

# We draw a scatterplot with the contents of the DF:
x = data[0]
y = data[1]
plt.scatter(x,y, H)
plt.show()
