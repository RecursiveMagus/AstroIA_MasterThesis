import numpy as np
from ODE_solver import  RungeKuttaFehlberg78, RungeKuttaFehlberg45
import matplotlib.pyplot as plt
import pandas as pd


def f(t,y):
    # Equation of the circle.
    return np.array([y[1], -y[0]])

# We want to write each calculated point on a file, in order to plot them
# when the main loop is finished.
fitxer = open("circle_points_python.txt", "w")

# Initial point:
y = np.array([1,0])

# Total size for each "step":
H = 1e-4

#Initial time:
t = 0

while t < 5*2*np.pi:

    # Integrate between y and y+H:
    t, y = RungeKuttaFehlberg78(f, t, y, H, 1e-14)

    # Uncomment the next line to print the information of each point on screen:
    print(t, " | ", y, " | ", np.abs(np.sqrt(y[0]*y[0]+y[1]*y[1]) - 1.0), " | ")

    # We save the point (x,y) in the 'points.txt' file:
    fitxer.write(str(y[0]) + "," + str(y[1]) + "\n")

    # Error test: if the newly calculated points do not have euclidean norm close to 1,
    # then our integrator does not work as it should:
    d = np.linalg.norm(y, 2)
    if(abs(d - 1.0) > 1e-5):
        print("ERROR !")
        break

# Close the points file:
fitxer.close()

# Using pandas, we open the points file and store its contents inside a DF:
data = pd.read_csv("circle_points_python.txt", sep=",", header = None)
#data = pd.DataFrame(data)

# We draw a scatterplot with the contents of the DF:
x = data[0]
y = data[1]
plt.scatter(x,y, H)
plt.show()
