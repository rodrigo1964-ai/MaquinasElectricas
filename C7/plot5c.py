"""
plot file for Project 5
Save the output of each case in a Workspace array
by first reassigning it with a different name, e.g. y, y2, y3
and then using Python save command (e.g., np.save or pickle)

e.g. np.save('data2.npy', y2)

Reload the stored arrays using numpy load before using this plot file
e.g. y2 = np.load('data2.npy')

It is assumed that the arrays of the three cases
are stored as y, y2, and y3, respectively.
"""

import numpy as np
import matplotlib.pyplot as plt

# Load data files (uncomment when data files are available)
# y = np.load('data1.npy')
# y2 = np.load('data2.npy')
# y3 = np.load('data3.npy')

# For now, create a placeholder
print("This script plots comparison data from three simulation runs")
print("Data files need to be loaded: y, y2, y3")
print("Example usage:")
print("  y = np.load('data1.npy')")
print("  y2 = np.load('data2.npy')")
print("  y3 = np.load('data3.npy')")
print("Then run the plotting section below")

# Plotting section (uncomment when data is available)
'''
fig, axs = plt.subplots(4, 1, figsize=(10, 12))

# Subplot 1: Power angle delta
axs[0].plot(y[:, 0], y[:, 5], '-', label='SET3A with S5')
axs[0].plot(y2[:, 0], y2[:, 5], '-.', label='SET3B with S5')
axs[0].plot(y3[:, 0], y3[:, 5], '--', label='SET3C with S1')
axs[0].set_ylabel('Delta in rad')
axs[0].set_title('Power angle delta')
axs[0].legend()
axs[0].grid(True)

# Subplot 2: Field current for SET3A
axs[1].plot(y[:, 0], y[:, 7], '-')
axs[1].set_ylabel('If in pu')
axs[1].set_title('Field current for SET3A')
axs[1].grid(True)

# Subplot 3: Field current for SET3B
axs[2].plot(y2[:, 0], y2[:, 7], '-')
axs[2].set_ylabel('If in pu')
axs[2].set_title('Field current for SET3B')
axs[2].grid(True)

# Subplot 4: Field current for SET3C
axs[3].plot(y3[:, 0], y3[:, 7], '-')
axs[3].set_ylabel('If in pu')
axs[3].set_xlabel('time in sec')
axs[3].set_title('Field current for SET3C')
axs[3].grid(True)

plt.tight_layout()
plt.show()
'''
