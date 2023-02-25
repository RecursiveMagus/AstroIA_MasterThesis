import numpy as np



#######################################
#   RungeKutta78(f, x0, y0, h)
#
#   ### Description:
#   This method uses both RK7 and RK8 to approximate the solution of the ivp
#       y' = f(x, y)    x0 <= x <= x0 + H     y(x0) = y0
#   with a local truncation error less than the specified tolerance TOL.
#
#   ### Arguments:
#   [f]   derivative function of the ODE, i.e., y' = f(x,y). This function should
#       return a numpy array of size (n,).
#   [x0], [y0]  initial parameters to be feeded to the function f.
#   [H]   Total step we want to integrate
#
#   ### Returns:
#   [y] numerical approximation of y(x) at x = x0+H
#
#######################################
def RungeKuttaFehlberg78(f, x0, y0, H, TOL):
    if H <= 0.0:
        return y0

    b = x0 + H
    y = y0
    x = x0

    BAND = 1

    h = H

    while(BAND):

        k1 = h * f( x , y )
        k2 = h * f( x+2*h/27, y + 2 * k1 / 27)
        k3 = h * f( x + h / 9.0, y + 1.0/36.0*( k1 + 3.0 * k2) )
        k4 = h * f( x + h / 6.0, y + h / 24.0 * ( k1 + 3.0 * k3) )
        k5 = h * f( x + 5 * h / 12.0 , y + 1.0 / 48.0 * (20.0 * k1 - 75 * k3 + 75 * k4))
        k6 = h * f( x + h / 2.0, y + 1.0 / 20.0 * ( k1 + 5.0 * k4 + 4.0 * k5 ) )
        k7 = h * f( x + 5.0 * h / 6.0, y + 1.0/108.0 * ( -25.0 * k1 + 125.0 * k4 - 260.0 * k5 + 250.0 * k6 ) )
        k8 = h * f( x + h / 6.0, y + ( 31.0/300.0 * k1 + 61.0/225.0 * k5 - 2.0/9.0 * k6 + 13.0/900.0 * k7) )
        k9 = h * f( x + 2.0*h / 3.0, y + ( 2.0* k1 - 53.0/6.0 * k4 + 704.0/45.0 * k5 - 107.0/9.0 * k6 + 67.0/90.0 * k7 + 3.0 * k8) )
        k10 = h * f( x + h/3.0, y + ( -91.0/108.0 * k1 + 23.0/108.0 * k4 - 976.0/135.0 * k5 + 311.0/54.0 * k6 - 19.0/60.0 * k7 + 17.0/6.0 * k8 - 1.0/12.0 * k9) )
        k11 = h * f( x + h, y + ( 2383.0/4100.0 * k1 - 341.0/164.0 * k4 + 4496.0/1025.0 * k5 - 301.0/82.0 * k6 + 2133.0/4100.0 * k7 + 45.0/82.0 * k8 + 45.0/164.0 * k9 + 18.0/41.0 * k10) )
        k12 = h * f( x, y+( 3.0/205.0 * k1 - 6.0/41.0 * k6 - 3.0/205.0 * k7 - 3.0/41.0 * k8 + 3.0/41.0 * k9 + 6.0/41.0 * k10) )
        k13 = h * f( x+h, y + ( -1777.0/4100.0 * k1 - 341.0/164.0 * k4 + 4496.0/1025.0 * k5- 289.0/82.0 * k6 + 2193.0/4100.0 * k7 + 51.0/82.0 * k8 + 33.0/164.0 * k9 + 12.0/41.0 * k10 + k12) )

        err = (1.0 / h) * np.abs( (41.0 / 840.0) * (-k1 -k11 + k12 + k13) )
        err = np.linalg.norm(err, 2)

        if(err <= TOL):
            x = x + h
            y = y + ((41.0 / 840.0) * (k1 + k11)  + (34.0 / 105.0) * k6 + (9.0 / 35.0) * (k7 + k8)+ (9.0 / 280.0) * (k9 + k10))

        delta = 0.84 * (TOL / err) ** (1.0 / 7.0)
        if delta < 0.1 :
            h = h * 0.1
        elif delta > 10.0 :
            h = 10.0 * h
        else:
            h = delta * h

        if x >= b:
            BAND = 0
        elif x + h > b:
            h = b - x

    return x, y



#######################################
#   RungeKuttaFehlberg45(f, x0, y0, H, TOL)
#
#   ### Description:
#   New and shiny implementation of the RKF4(5) method.
#   This method uses both RK4 and RK5 to approximate the solution of the ivp
#       y' = f(x, y)    x0 <= x <= x0 + H     y(x0) = y0
#   with a local truncation error less than the specified tolerance TOL.
#
#   ### Arguments:
#   [f]   derivative function of the ODE, i.e., y' = f(x,y). This function should
#       return a numpy array of size (n,).
#   [x0], [y0]  initial parameters to be feeded to the function f.
#   [H]   Total step we want to integrate
#
#   ### Returns:
#   [y] numerical approximation of y(x) at x = x0+H
#
#   ### Additional notes:
#   Implementation based on "Analisis Numérico" (Burden & Faires) 7th spanish
#   edition, Algorithm 5.3 (pags. 285-286)
#######################################
def RungeKuttaFehlberg45(f, x0, y0, H, TOL):
    if H <= 0.0:
        return y0

    b = x0 + H
    y = y0
    x = x0

    BAND = 1

    h = H

    while(BAND):
        k1 = h * f(x, y)
        k2 = h * f(x + 0.25 * h, y + 0.25 * k1)
        k3 = h * f(x + (3.0 / 8.0) * h, y + (3.0 / 32.0) * k1 + (9.0 / 32.0) * k2)
        k4 = h * f(x + (12.0 / 13.0) * h, y + (1932.0 / 2197.0) * k1 - (7200.0 / 2197.0) * k2 + (7296.0 / 2197.0) * k3)
        k5 = h * f(x + h, y + (439.0 / 216.0) * k1 - 8.0 * k2 + (3680.0 / 513.0) * k3 - (845.0 / 4104) * k4)
        k6 = h * f(x + 0.5*h, y - (8.0 / 27.0) * k1 + 2.0 * k2 - (3544.0 / 2565.0) * k3 + (1859.0 / 4104.0) * k4 - (11.0 / 40.0) * k5)

        err = (1.0 / h) * np.abs( (1.0 / 360.0) * k1 - (128.0 / 4275.0) * k3 - (2197.0 / 75240.0) * k4 + (1.0 / 50.0) * k5 + (2.0 / 55.0) * k6 )
        err = np.linalg.norm(err, 2)

        if(err <= TOL):
            x = x + h
            y = y + (25.0 / 216.0) * k1 + (1408.0 / 2565.0) * k3 + (2197.0 / 4104.0) * k4 - (1.0 / 5.0) * k5

        delta = 0.84 * (TOL / err) ** 0.25
        if delta < 0.1 :
            h = h * 0.1
        elif delta > 10.0 :
            h = 10.0 * h
        else:
            h = delta * h

        if x >= b:
            BAND = 0
        elif x + h > b:
            h = b - x

    return x, y
