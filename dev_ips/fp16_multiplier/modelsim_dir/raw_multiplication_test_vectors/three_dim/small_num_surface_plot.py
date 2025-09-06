import numpy as np
import matplotlib.pyplot as plt
#from mpl_toolkits.mplot3d import Axes3D  # Ensure this import is here, but may not always be necessary

# Read the CSV file
F = np.loadtxt('small_num.csv', delimiter=',')

# Extract the third column and transpose it
err = F[:, 2]

# Define the range and step size for the grid
step_size = 0.0015
range_values = np.arange(-1, 1, step_size)

# Generate the grid
in_a, in_b = np.meshgrid(range_values, range_values)

# Reshape the err vector into a 2D matrix
err_mat = np.reshape(err, (len(range_values), len(range_values)))

# Create a 3D mesh plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.plot_surface(in_a, in_b, err_mat, cmap='viridis')

# Set labels
ax.set_xlabel('Input A')
ax.set_ylabel('Input B')
ax.set_zlabel('Error(%)')

plt.show()

