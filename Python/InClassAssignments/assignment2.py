#requires DataGenerator file
try: import DataGenerator
except ImportError as e:
    print(f"Error on import - did you forget to put DataGenerator.py in the same directory as this file?\n{e}")
    raise SystemExit
import numpy as np
import matplotlib.pyplot as plt


def point_slope(x1,x2,y1,y2):
    """Given 2 points (x1,y1) & (x2,y2), returns the slope (float) of the intersecting line
       - x1: x-value of the first point
       - y1: y-value of the first point
       - x2: x-value of the second point
       - y2: y-value of the second point

       Note: a zero-division error will result in a numpy NaN return value
       """
    #y = mx+b
    try: return (y2-y1)/(x2-x1)
    except ZeroDivisionError: return np.NaN

def fwd_slope(i:int,x_array:np.array,y_array:np.array) -> float:
    """For a given array index (i), return the slope of the line between  
       it and the next point in the x & y arrays. Final point will be compared
       to the array's first point.
       
       - i: index value for the 2 arrays
       - x_array: numpy array containing x-values
       - y_array: numpy array containing y-values
       
       Note: arrays must be the same shape
       """
    #Error handling -- arrays of different shape will not be permitted
    if x_array.shape != y_array.shape:
        print(f"Arrays must have the same number of values!")
        return None
    #find x & y values at the given index (xi,yi) and the next point (xip,yip)
    try:
        x1,x2 = x_array[i],x_array[i+1]
        y1,y2 = y_array[i],y_array[i+1]
    #handling the end of the index range; compare to the first point
    except IndexError:
        x1,x2 = x_array[i],x_array[0]
        y1,y2 = y_array[i],y_array[0]
    m = point_slope(x1,x2,y1,y2)
    #print(f"You supplied x index {i} with coordinates ({x1:.4f},{y1:.4f}), "+\
    #      f"that when compared to ({x2:.4f},{y2:.4f}) has a slope of {m:.4f}")
    return m

def arraywise_slope(i:int,x_array:np.array,y_array:np.array) -> float:
    """For a given array index (i), return the average slope of the line between  
       it and every other point in the x & y arrays.
       
       - i: index value for the 2 arrays
       - x_array: numpy array containing x-values
       - y_array: numpy array containing y-values

       Note: arrays must be the same shape
       """
    #Error handling -- arrays of different shape will not be permitted
    if x_array.shape != y_array.shape:
        print(f"Arrays must have the same number of values!")
        return None
    x1,y1 = x_array[i],y_array[i]
    m_array = np.array([point_slope(x1,x_array[j],y1,y_array[j]) for j in range(x_array.shape[0]) if i != j])
    m = m_array.mean()
    #print(f"You supplied x index {i} with coordinates ({x1:.4f},{y1:.4f}), "+\
    #      f"that when compared to all other points has a slope of {m:.4f}")
    return m



def main():
    """Using DataGenerator.py's generate_data() function, tries out linear regression methods across
       50 points. Results are plotted with matplotlib with labeled axes, a legend, and the equation
       of the fitted regression lines where coefficients are expressed to 2 decimal places.
    """

    x_array,y_array = DataGenerator.generate_data()
    x_mean, y_mean = x_array.mean(),y_array.mean()
    print(f"x_array: {x_array}")
    print(f"y_array: {y_array}")
    print()

    #Method 1 - determine the slope m between each successive point & take the average,
    #           then take the average x and y value to determine y intercept b
    m_array = np.array([fwd_slope(i,x_array,y_array) for i in range(x_array.shape[0])])
    m_mean = m_array.mean()
    print(f"METHOD 1\n--------")
    print(f"Average slope = {m_mean:.4f}")
    #b = y/mx
    b = y_mean/(m_mean*x_mean)
    m1m,m1b = m_mean,b
    print(f"Y-intercept = {b:.4f}")
    m1eq = f"y = {m_mean:.2f}x + {b:.2f}"
    print(f"Method 1 equation: {m1eq}")
    print(f"\n\n\n")

    #Method 2 - extending method 1, but calculating the slope from each point to every other
    #           point, and then averaging. Then each of these averages is also averaged to
    #           obtain a (potentially) more accurate slope value
    m_array = np.array([arraywise_slope(i,x_array,y_array) for i in range(x_array.shape[0])])
    m_mean = m_array.mean()
    print(f"METHOD 2\n--------")
    print(f"Average slope = {m_mean:.4f}")
    #b = y/mx
    b = y_mean/(m_mean*x_mean)
    m2m,m2b = m_mean,b
    print(f"Y-intercept = {b:.4f}")
    m2eq = f"y = {m_mean:.2f}x + {b:.2f}"
    print(f"Method 2 equation: {m2eq}")
    print(f"\n\n\n")

    #Method 3 - extending method 2 by calculating an average y intercept using the average
    #           slope value against each point. 
    m_array = np.array([arraywise_slope(i,x_array,y_array) for i in range(x_array.shape[0])])
    m_mean = m_array.mean()
    print(f"METHOD 3\n--------")
    print(f"Average slope = {m_mean:.4f}")
    #b = y/mx
    b_array = np.array([y_array[i]/(m_array[i]*x_array[i]) for i in range(x_array.shape[0])])
    b = b_array.mean()
    m3m,m3b = m_mean,b
    print(f"Y-intercept = {b:.4f}")
    m3eq = f"y = {m_mean:.2f}x + {b:.2f}"
    print(f"Method 3 equation: {m3eq}")
    print(f"\n\n\n")

    #Method 4 - extend method 2 by calculating the average y-distance between each point and
    #           method 2's regression line. Use this to shift b either up or down so that it
    #           minimizes the average y variance.
    m4m = m3m
    print(f"METHOD 4\n--------")
    print(f"Average slope = {m4m:.4f}")
    m2_y_array = np.array([m2m*x + m2b for x in x_array])
    m2_y_variation = y_array - m2_y_array
    m4b = m2b + m2_y_variation.mean()
    print(f"Y-intercept = {m4b:.4f}")
    m4eq = f"y = {m4m:.2f}x + {m4b:.2f}"
    print(f"Method 4 equation: {m4eq}")
    print(f"\n\n\n")


    #Plot the 4 equations using matplotlib, using accessible color palatte for the equation lines
    x_range = np.linspace(min(x_array)-1, max(x_array)+1)
    plt.figure()
    plt.scatter(x_array,y_array,color='black',label='DataGenerator Points',zorder=1)
    plt.plot(x_range, m1m*x_range + m1b, label=f'M1: {m1eq}', color='#A41034')
    plt.plot(x_range, m2m*x_range + m2b, label=f'M2: {m2eq}', color='#C29d00')
    plt.plot(x_range, m3m*x_range + m3b, label=f'M3: {m3eq}', color='#006085')
    plt.plot(x_range, m4m*x_range + m4b, label=f'M4: {m4eq}', color='#57116A')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title('Linear Regression Methods Against DataGenerator Plotpoints')
    plt.legend()
    #plt.grid(True)
    plt.show()

    
    
    return

if __name__ == "__main__":
    main()