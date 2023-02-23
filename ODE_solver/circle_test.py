import numpy as np
from ODE_solver import  RungeKuttaFehlberg78, RungeKuttaFehlberg45
import matplotlib.pyplot as plt
import pandas as pd


def f(t,y):
    # Equation of the circle.
    return np.array([y[1], -y[0]])

# We want to write each calculated point on a file, in order to plot them
# when the main loop is finished.
fitxer = open("points.txt", "w")

# Initial point:
y = np.array([1,0])

# Total size for each "step":
H = 1e-4

# Lap counters:
lap_count = 0
max_laps = 10


for t in range( int(max_laps * 2*np.pi / H) ):

    # Integrate between y and y+H:
    y = RungeKuttaFehlberg78(f, t, y, H, 1e-14)

    # Uncomment the next line to print the information of each point on screen:
    # print(t, " | ", lap_count, " | ", y, " | ", np.abs(np.sqrt(y[0]*y[0]+y[1]*y[1]) - 1.0), " | ")

    # We save the point (x,y) in the 'points.txt' file:
    fitxer.write(str(y[0]) + "," + str(y[1]) + "\n")

    # Error test: if the newly calculated points do not have euclidean norm close to 1,
    # then our integrator does not work as it should:
    d = np.linalg.norm(y, 2)
    if(abs(d - 1.0) > 1e-5):
        print("ERROR !")
        break

    # We write the current lap:
    if(t % int(2*np.pi / H) == 0):
        print("Volta", lap_count)
        lap_count += 1

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
